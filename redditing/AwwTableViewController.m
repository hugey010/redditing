//
//  AwwTableViewController.m
//  redditing
//
//  Copyright (c) 2014 Beam Technologies. All rights reserved.
//

#import "AwwTableViewController.h"
#import "AwwTableViewCell.h"
#import "AwwPost.h"
#import "AwwApi.h"
#import "AwwPopupView.h"

@interface AwwTableViewController ()  <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *redditPosts;
@property (nonatomic, strong) AwwPopupView* blownUpView;

@end

@implementation AwwTableViewController

static NSString* const cellIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[AwwTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    self.tableView.estimatedRowHeight = 56;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.tabBarController.tabBar.frame.size.height, 0);
    
    NSString* subreddit = @"aww";
    if ([self.tabBarController.viewControllers indexOfObject:self] == 1) {
        subreddit = @"globaloffensive";
    }
    [AwwApi postsInSubreddit:subreddit completion:^(NSArray *posts, NSError *error) {
        if (!error) {
            self.redditPosts = posts;
            [self.tableView reloadData];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Oops" message:error.userInfo[kAwwApiErrorUserInfoKey] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        }
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_blownUpView) {
        [_blownUpView removeFromSuperview];
    }
    
    // showing the bigger view with a cool animation
    CGRect cellRect = [tableView rectForRowAtIndexPath:indexPath];
    CGRect startRect = CGRectMake(cellRect.origin.x + 8, cellRect.origin.y + 2, 80, 80);
    

    AwwPost* post = self.redditPosts[indexPath.row];
    
    CGRect frame = self.view.frame;
    CGRect endRect = CGRectMake(frame.size.width / 2.0 - 150, frame.size.height / 2.0 - 150 + tableView.contentOffset.y, 300, 300);
    
    _blownUpView = [[AwwPopupView alloc] initWithURL:post.thumbnailURL];
    [self.view addSubview:_blownUpView];
    [_blownUpView performAnimationFromRect:startRect toRect:endRect];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_blownUpView) {
        [_blownUpView removeFromSuperview];
    }
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.redditPosts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AwwTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell setupWithPost:self.redditPosts[indexPath.row]];
    return cell;
}

@end
