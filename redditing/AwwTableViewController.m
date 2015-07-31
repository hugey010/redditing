//
//  AwwTableViewController.m
//  redditing
//
//  Copyright (c) 2014 Beam Technologies. All rights reserved.
//

#import "AwwTableViewController.h"

@interface AwwTableViewController ()

@property (nonatomic, strong) NSArray *redditPosts;

@end

@implementation AwwTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    
    [self getPosts];
}

- (void)getPosts {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://api.reddit.com/r/aww"]];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        NSInteger statusCode = [httpResponse statusCode];
        if (!connectionError) {
            if (statusCode != 500) {
                NSError *error = nil;
                NSDictionary *responseDictionary = [NSJSONSerialization
                                                    JSONObjectWithData:data
                                                    options:kNilOptions
                                                    error:&error];
                self.redditPosts = [[responseDictionary objectForKey:@"data"] objectForKey:@"children"];
                [self.tableView reloadData];
            }
        }
    }];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"/r/aww";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.redditPosts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSDictionary *post = [self.redditPosts objectAtIndex:[indexPath row]];
    cell.textLabel.text = [[post objectForKey:@"data"] objectForKey:@"title"];
    
    return cell;
}

@end
