//
//  AwwPopupView.m
//  redditing
//
//  Created by Hugey on 7/31/15.
//  Copyright (c) 2015 Beam Technologies. All rights reserved.
//

#import "AwwPopupView.h"
#import "AwwApi.h"

@interface AwwPopupView()

@property (nonatomic, strong) NSURL* url;

@end

@implementation AwwPopupView

- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    if (!self) { return nil; }
    
    _url = url;
    [AwwApi imageAtURL:url completion:^(UIImage *image) {
        self.image = image;
    }];
    
    self.contentMode = UIViewContentModeScaleAspectFit;
    self.frame = CGRectZero;
    self.layer.borderColor = UIColor.blackColor.CGColor;
    self.layer.borderWidth = 2.0;
    self.alpha = 0.0;
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor whiteColor];
    
    return self;
}

- (void)performAnimationFromRect:(CGRect)startRect toRect:(CGRect)endRect {
    self.frame = startRect;
    
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(M_PI * 2.0 * 5 * 0.4);
    rotationAnimation.duration = 0.4;
    rotationAnimation.cumulative = YES;
    
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.frame = endRect;
        self.alpha = 1.0;
    }];
}

- (void)dealloc {
    [AwwApi cancelImageCompletionForURL:_url];
}


@end
