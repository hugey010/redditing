//
//  AwwApi.h
//  redditing
//
//  Created by Hugey on 7/30/15.
//  Copyright (c) 2015 Beam Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** PostsBlock should contain an array of AwwPost objects if nil error. */
typedef void (^PostsBlock)(NSArray*, NSError*);
typedef void (^ImageBlock)(UIImage*);

@interface AwwApi : NSObject

extern NSString* const kAwwApiErrorUserInfoKey;

/** Loads posts from reddit in a given subreddit. Delivers completion on main thread.
    Completion block must NOT be nil */
+ (void)postsInSubreddit:(NSString*)subreddit completion:(PostsBlock)completion;

/** Loads posts from reddit in a given subreddit. Delivers completion on main thread. Caches requests based on url.
    Completion block must NOT be nil */
+ (void)imageAtURL:(NSURL*)url completion:(ImageBlock)completion;

/** Use when a cell is being reused and you dont want its completion block get called.
    Often used for UITableViewCells on prepareForReuse. */
+ (void)cancelImageCompletionForURL:(NSURL*)url;

/** clears the thumbnail cache, normally just used in testing */
+ (void)clearThumbnailCache;

@end
