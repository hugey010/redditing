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

+ (void)initialize {
    thumbnails = [NSMutableDictionary dictionary];
}

+ (void)postsInSubreddit:(NSString*)subreddit completion:(PostsBlock)completion {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://api.reddit.com/r/aww"]];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        NSInteger statusCode = [httpResponse statusCode];
        if (!connectionError && NSLocationInRange(statusCode, NSMakeRange(200, 299))) {
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(mappedPosts, nil);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil, error);
                });
            }
        } else {
            NSString* errorMessage = [NSString stringWithFormat:@"Unable to load posts at %@.", request.URL];
            NSError* error = [NSError errorWithDomain:@"com.beamtechnologies.error" code:statusCode userInfo:@{kErrorUserInfoKey : errorMessage}];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
        }
    }];
    
}

+ (void)thumbnailForPost:(AwwPost*)post completion:(ThumbnailBlock)completion {
    NSString* urlString = [NSString stringWithFormat:@"%@", post.thumbnailURL];
    if (thumbnails[urlString]) {
        completion(thumbnails[urlString]);
    } else {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:post.thumbnailURL];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            NSInteger statusCode = [httpResponse statusCode];
            if (!connectionError && NSLocationInRange(statusCode, NSMakeRange(200, 299))) {
                UIImage* image = [UIImage imageWithData:data];
                if (image) {
                    thumbnails[urlString] = image;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(image);
                });
            }
        }];
    }
}

@end
