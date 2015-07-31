//
//  AwwApi.m
//  redditing
//
//  Created by Hugey on 7/30/15.
//  Copyright (c) 2015 Beam Technologies. All rights reserved.
//

#import "AwwApi.h"
#import "AwwPost.h"

@implementation AwwApi

NSString* const kErrorUserInfoKey = @"message";

static NSMutableDictionary* thumbnails;
static NSMutableDictionary* canceledThumbnails;
static NSRange successRange;

+ (void)initialize {
    thumbnails = [NSMutableDictionary dictionary];
    canceledThumbnails = [NSMutableDictionary dictionary];
    successRange = NSMakeRange(200, 299);
}

+ (void)postsInSubreddit:(NSString*)subreddit completion:(PostsBlock)completion {
    NSString* urlString = [NSString stringWithFormat:@"http://api.reddit.com/r/%@", subreddit];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        NSInteger statusCode = [httpResponse statusCode];
        if (!connectionError && NSLocationInRange(statusCode, successRange)) {
            NSError *error = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization
                                                JSONObjectWithData:data
                                                options:kNilOptions
                                                error:&error];
            if (!error) {
                NSMutableArray* mappedPosts = [NSMutableArray array];
                for (NSDictionary* dict in responseDictionary[@"data"][@"children"]) {
                    AwwPost *post = [[AwwPost alloc] initWithDictionary:dict];
                    [mappedPosts addObject:post];
                }
                if (mappedPosts.count > 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(mappedPosts, nil);
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(nil, [self errorWithStatusCode:-1 andMessage:@"No Posts!"]);
                    });
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil, [self errorWithStatusCode:error.code andMessage:@"Error parsing JSON"]);
                });
            }
        } else {
            NSString* errorMessage = [NSString stringWithFormat:@"Unable to load posts at %@.", request.URL];
            NSError* error = [self errorWithStatusCode:statusCode andMessage:errorMessage];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
        }
    }];
}

+ (void)thumbnailForPost:(AwwPost*)post completion:(ThumbnailBlock)completion {
    if (post.urlString) {
        [canceledThumbnails removeObjectForKey:post.urlString];
    }
    
    if (thumbnails[post.urlString]) {
        if (!canceledThumbnails[post.urlString]) {
            completion(thumbnails[post.urlString]);
        }
    } else {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:post.thumbnailURL];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            NSInteger statusCode = [httpResponse statusCode];
            if (!connectionError && NSLocationInRange(statusCode, successRange)) {
                UIImage* image = [UIImage imageWithData:data];
                if (image) {
                    thumbnails[post.urlString] = image;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!canceledThumbnails[post.urlString]) {
                        completion(image);
                    }
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!canceledThumbnails[post.urlString]) {
                        completion(nil);
                    }
                });
            }
        }];
    }
}

+ (void)cancelThumbnailCompletionForPost:(AwwPost*)post {
    canceledThumbnails[post.urlString] = @(YES);
}

+ (void)clearThumbnailCache {
    thumbnails = [NSMutableDictionary dictionary];
}

#pragma mark - private

+ (NSError*)errorWithStatusCode:(NSInteger)code andMessage:(NSString*)message {
    return [NSError errorWithDomain:@"com.beamtechnologies.error" code:code userInfo:@{kErrorUserInfoKey : message}];
}

@end
