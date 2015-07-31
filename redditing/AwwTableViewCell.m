//
//  AwwTableViewCell.m
//  redditing
//
//  Created by Hugey on 7/30/15.
//  Copyright (c) 2015 Beam Technologies. All rights reserved.
//

#import "AwwTableViewCell.h"
#import "AwwPost.h"
#import "AwwApi.h"

@interface AwwTableViewCell()

@property (nonatomic, strong) UILabel* postTitleLabel;
@property (nonatomic, strong) UIImageView* thumbnailImageView;

@end

@implementation AwwTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) { return nil; }
    
    UIView* contentView = self.contentView;
    
    _postTitleLabel = [[UILabel alloc] init];
    _postTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _postTitleLabel.numberOfLines = 0;
    [contentView addSubview:_postTitleLabel];
    
    _thumbnailImageView = [[UIImageView alloc] init];
    _thumbnailImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _thumbnailImageView.contentMode = UIViewContentModeScaleAspectFit;
    [contentView addSubview:_thumbnailImageView];
    
    NSDictionary* views = NSDictionaryOfVariableBindings(_postTitleLabel, _thumbnailImageView);
    NSDictionary* metrics = @{@"padding" : @(8),
                             @"spacing" : @(12),
                             @"min" : @(40),
                              @"tightPadding" : @(2)
                             };
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-tightPadding-[_thumbnailImageView]-tightPadding@999-|" options:kNilOptions metrics:metrics views:views]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[_postTitleLabel]-padding@999-|" options:kNilOptions metrics:metrics views:views]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[_thumbnailImageView(80)]-spacing-[_postTitleLabel]-padding-|" options:kNilOptions metrics:metrics views:views]];
    NSLayoutConstraint* thumbnailSquareConstraint = [NSLayoutConstraint constraintWithItem:_thumbnailImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_thumbnailImageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    [_thumbnailImageView addConstraint:thumbnailSquareConstraint];
    NSLayoutConstraint* thumbnailCenterYConstraint = [NSLayoutConstraint constraintWithItem:_thumbnailImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    [contentView addConstraint:thumbnailCenterYConstraint];
    
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)setupWithPost:(AwwPost*)post {
    _postTitleLabel.text = post.title;
   
    _thumbnailImageView.image = nil;
    [AwwApi thumbnailForPost:post completion:^(UIImage *image) {
        self.thumbnailImageView.image = image;
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }];
}

@end
