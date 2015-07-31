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

@interface AwwTableViewController ()  <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *redditPosts;

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
            
        }
    }];
}

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
