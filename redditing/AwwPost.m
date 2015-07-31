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
    _urlString = dataDict[@"thumbnail"];
    _thumbnailURL = [NSURL URLWithString:_urlString];
    
    return self;
}

@end
