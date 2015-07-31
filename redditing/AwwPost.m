//
//  AwwPost.m
//  redditing
//
//  Created by Hugey on 7/30/15.
//  Copyright (c) 2015 Beam Technologies. All rights reserved.
//

#import "AwwPost.h"

@implementation AwwPost

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (!self) { return nil; }
   
    NSDictionary* dataDict = dictionary[@"data"];
    _title = dataDict[@"title"];
   
    NSDictionary* mediaDict = dataDict[@"media"];
    if ([mediaDict isEqual:[NSNull null]]) {
        mediaDict = dataDict[@"secure_media"];
    }
    if (![mediaDict isEqual:[NSNull null]]) {
        NSDictionary* oembed = mediaDict[@"oembed"];
        _thumbnailURL = [NSURL URLWithString:oembed[@"thumbnail_url"]];
    }
    
    return self;
}

@end
