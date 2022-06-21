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

@interface TimelineViewController () <UITableViewDataSource>
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    
    
    // Get timeline
    [self fetchTweets];
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:(UIControlEventValueChanged)];
//    [self.activityIndicator setCenter:self.tableView.center];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void) fetchTweets {
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎 Successfully loaded home timeline");
            for (Tweet *dictionary in tweets) {
                NSLog(@"%@", dictionary.user.name);
                
            }
            
            self.arrayOfTweets = (NSMutableArray *) tweets;
            [self.tableView reloadData];
            NSLog(@"%lu", (unsigned long)self.arrayOfTweets.count);
            [self.refreshControl endRefreshing];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
//    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    Tweet *tweet = self.arrayOfTweets[indexPath.row];

    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
//    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    cell.tweetName.text = (tweet.user.name);
    cell.tweetName.font = [cell.tweetName.font fontWithSize:14];
    
    cell.tweetText.text = (tweet.text);
    cell.tweetText.font = [cell.tweetText.font fontWithSize:12];
    
    [cell.tweetPhoto setImageWithURL:url ];
    
//    [cell.tweetPhoto setImage:(NS *) urlData];

    self.tableView.rowHeight = 180;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//
    return self.arrayOfTweets.count;
//    return 20;
}
@end
