//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "DateTools.h"
#import "DetailsViewController.h"
#import "TweetCell.h"


@interface TimelineViewController () <ComposeViewControllerDelegate,UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property NSMutableArray *arrayOfTweets;
@end

@implementation TimelineViewController
- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}
- (void) viewWillAppear:(BOOL)animated {
    [self fetchTweets];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    [self.refreshControl beginRefreshing];


    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:(UIControlEventValueChanged)];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void) fetchTweets {
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎 Successfully loaded home timeline");

            self.arrayOfTweets = (NSMutableArray *) tweets;
            [self.tableView reloadData];
            for (Tweet *t in self.arrayOfTweets){
                NSLog(@"%@", t.text);
            }
            [self.refreshControl endRefreshing];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"composeSegue"]) {
    UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    } else {
    UITableViewCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    DetailsViewController *detailsController = [segue destinationViewController];
    detailsController.tweet = self.arrayOfTweets[indexPath.row];
    }
}


//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//
//}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];

    Tweet *tweet = self.arrayOfTweets[indexPath.row];

    cell.tweet = tweet;

    [cell refreshTweet];



    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweets.count;
}
- (void)didTweet:(nonnull Tweet *)tweet {
    [self.arrayOfTweets addObject:tweet];

    [self.tableView reloadData];
}

@end
