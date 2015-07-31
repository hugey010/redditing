//
//  AwwApiTests.m
//  redditing
//
//  Created by Hugey on 7/31/15.
//  Copyright (c) 2015 Beam Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "AwwApi.h"
#import "AwwPost.h"

@interface AwwApiTests : XCTestCase

@end

@implementation AwwApiTests
// some say its bad practice to hit api's in tests, but I'm gonna because reddit is perfect.

- (void)testBadPostsURL {
    XCTestExpectation* expectation = [self expectationWithDescription:@"Error expectation"];
    [AwwApi postsInSubreddit:@"a_subreddit_that_just_cant_exist!" completion:^(NSArray *posts, NSError *error) {
        XCTAssert(error != nil, @"Should have error");
        XCTAssert([error.userInfo[@"message"] length] > 0, @"Custom error message should be set");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:2.0 handler:^(NSError *error) {
        XCTAssert(error == nil, @"Should have fulfilled expectation");
    }];
}

- (void)testSuccessCSGOPosts {
    XCTestExpectation* expectation = [self expectationWithDescription:@"Success expectation"];
    [AwwApi postsInSubreddit:@"globaloffensive" completion:^(NSArray *posts, NSError *error) {
        XCTAssert(posts.count > 0, @"Should be posts for CSGO!");
        XCTAssert(error == nil, @"Should'nt be an error");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:2.0 handler:^(NSError *error) {
        XCTAssert(error == nil, @"Should have fulfilled expectation");
    }];
}

- (void)testNilPostThumbnails {
    XCTestExpectation* expectationNilPost = [self expectationWithDescription:@"Error expectation"];
    [AwwApi thumbnailForPost:nil completion:^(UIImage *image) {
        XCTAssert(image == nil, @"Shouldn't be an image");
        [expectationNilPost fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:^(NSError *error) {
        XCTAssert(error == nil, @"Should have fulfilled expectation");
    }];
   
    XCTestExpectation* expectationNilThumbnail = [self expectationWithDescription:@"Error expectation"];
    AwwPost* emptyPost = [[AwwPost alloc] initWithDictionary:nil];
    [AwwApi thumbnailForPost:emptyPost completion:^(UIImage *image) {
        XCTAssert(image == nil, @"Shouldn't be an image");
        [expectationNilThumbnail fulfill];
    }];
    [self waitForExpectationsWithTimeout:2.0 handler:^(NSError *error) {
        XCTAssert(error == nil, @"Should have fulfilled expectation");
    }];
}

- (void)testSuccessThumbnail {
    
}

- (void)testCacheThumbnail {
    
}

@end
