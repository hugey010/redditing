//
//  AwwPopupView.h
//  redditing
//
//  Created by Hugey on 7/31/15.
//  Copyright (c) 2015 Beam Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AwwPopupView : UIImageView

- (instancetype)initWithURL:(NSURL*)url NS_DESIGNATED_INITIALIZER;
- (void)performAnimationFromRect:(CGRect)startRect toRect:(CGRect)endRect;

@end
