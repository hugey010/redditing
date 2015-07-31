//
//  AwwApi.h
//  redditing
//
//  Created by Hugey on 7/30/15.
//  Copyright (c) 2015 Beam Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AwwPost;

/** PostsBlock should contain an array of AwwPost objects if nil error. */
typedef void (^PostsBlock)(NSArray*, NSError*);
typedef void (^ThumbnailBlock)(UIImage*);

@interface AwwApi : NSObject

extern NSString* const kAwwApiErrorUserInfoKey;

/** Loads posts from reddit in a given subreddit. Delivers completion on main thread.
    Completion block must NOT be nil */
+ (void)postsInSubreddit:(NSString*)subreddit completion:(PostsBlock)completion;

/** Loads posts from reddit in a given subreddit. Delivers completion on main thread. Caches requests based on url.
    Completion block must NOT be nil */
+ (void)thumbnailForPost:(AwwPost*)post completion:(ThumbnailBlock)completion;

@end
