//
//  AwwTableViewCell.h
//  redditing
//
//  Created by Hugey on 7/30/15.
//  Copyright (c) 2015 Beam Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AwwPost;

@interface AwwTableViewCell : UITableViewCell

- (void)setupWithPost:(AwwPost*)post;

@end
