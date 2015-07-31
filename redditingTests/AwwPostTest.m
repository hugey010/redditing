//
//  AwwPostTest.m
//  redditing
//
//  Created by Hugey on 7/31/15.
//  Copyright (c) 2015 Beam Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "AwwPost.h"

@interface AwwPostTest : XCTestCase

@end

@implementation AwwPostTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testNilInit {
    AwwPost* post = [[AwwPost alloc] initWithDictionary:nil];
    XCTAssert(post != nil, @"Nil should still get model");
    XCTAssert(post.title == nil, @"Title should be nil");
    XCTAssert(post.thumbnailURL == nil, @"Thumbnail should be nil");
    XCTAssert(post.url == nil, @"Thumbnail should be nil");
}

- (void)testEmptyFieldsInit {
    NSDictionary* dict = @{@"data" :
                               @{}
                           };
    AwwPost* post = [[AwwPost alloc] initWithDictionary:dict];
    XCTAssert(post != nil, @"Empty should still get model");
    XCTAssert(post.title == nil, @"Title should be nil");
    XCTAssert(post.thumbnailURL == nil, @"Thumbnail should be nil");
    XCTAssert(post.url == nil, @"Url should be nil");
}

- (void)testNormalFieldsInit {
    NSString* title = @"test title";
    NSString* url = @"a_jpg_url.jpg";
    NSString* thumbnail = @"some_thumbnail_url.test";
    NSDictionary* dict = @{@"data" :
                               @{@"title" : title,
                                 @"thumbnail" : thumbnail,
                                 @"url" : url
                                 }
                           };
    AwwPost* post = [[AwwPost alloc] initWithDictionary:dict];
    XCTAssert(post != nil, @"Empty should still get model");
    XCTAssert([post.title isEqualToString:title], @"Title should match dictionary");
    XCTAssert([post.thumbnailURL isEqual:[NSURL URLWithString:thumbnail]], @"Thumbnail url should match dictionary");
    XCTAssert([post.url isEqual:[NSURL URLWithString:url]], @"Url should match dictionary");
}

- (void)testBadURL {
    NSString* url = @"a_jpg_url.gifv";
    NSString* thumbnail = @"some_thumbnail_url.test";
    NSDictionary* dict = @{@"data" :
                               @{@"url" : url,
                                 @"thumbnail": thumbnail
                                 }
                           };
    AwwPost* post = [[AwwPost alloc] initWithDictionary:dict];
    XCTAssert([post.url isEqual:post.thumbnailURL], @"Url should match thumbnail because it is unsupported");
}

@end
