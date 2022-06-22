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

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
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
//            for (Tweet *dictionary in tweets) {
//                NSLog(@"%@", dictionary.user.name);
//                
//            }
            
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    
}



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
    
    cell.tweetUsername.text = [@"@" stringByAppendingString: tweet.user.screenName];
    cell.tweetUsername.font = [cell.tweetText.font fontWithSize:12];
    
    [cell.tweetPhoto setImageWithURL:url ];
    cell.tweetPhoto.layer.cornerRadius = cell.tweetPhoto.frame.size.height /2;
    cell.tweetPhoto.layer.masksToBounds = YES;
    cell.tweetPhoto.layer.borderWidth = 0;
    
    cell.likeCount.text = [NSString stringWithFormat:@"%i", tweet.favoriteCount];
    cell.likeCount.font = [cell.likeCount.font fontWithSize:12];
    cell.retweetCount.text = [NSString stringWithFormat:@"%i", tweet.retweetCount];
    cell.retweetCount.font = [cell.retweetCount.font fontWithSize:12];
//    return cell;
    cell.replyCount.text = [NSString stringWithFormat:@"%i", tweet.replyCount];
    cell.replyCount.font = [cell.replyCount.font fontWithSize:12];
    cell.tweetDate.text = [@"." stringByAppendingString:tweet.createdAtString];
    cell.tweetDate.font = [cell.tweetDate.font fontWithSize:12];
    
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
