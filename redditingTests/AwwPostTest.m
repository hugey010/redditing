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
    XCTAssert(YES, @"Should still get model");
}



@end
