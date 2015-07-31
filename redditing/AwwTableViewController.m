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
    
    [AwwApi postsInSubreddit:@"aww" completion:^(NSArray *posts, NSError *error) {
        if (!error) {
            self.redditPosts = posts;
            [self.tableView reloadData];
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
