//
//  AwwPost.h
//  redditing
//
//  Created by Hugey on 7/30/15.
//  Copyright (c) 2015 Beam Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AwwPost : NSObject

@property (nonatomic, copy, readonly) NSString* title;
@property (nonatomic, strong, readonly) NSURL* thumbnailURL;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary NS_DESIGNATED_INITIALIZER;

@end
