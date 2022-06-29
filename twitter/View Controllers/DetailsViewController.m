//
//  DetailsViewController.m
//  twitter
//
//  Created by Adam Issah on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "TweetCell.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *tweetPhoto;
@property (weak, nonatomic) IBOutlet UILabel *tweetName;
@property (weak, nonatomic) IBOutlet UILabel *tweetUsername;
@property (weak, nonatomic) IBOutlet UILabel *tweetDate;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *replyCount;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UINavigationItem *backButton;
@end

@implementation DetailsViewController
- (IBAction)didTapRetweet:(id)sender {
    [self didTapRetweetAction];
    [self refreshTweet];
    
}
- (IBAction)didTapFavorite:(id)sender {
    [self didTapFavoriteAction];
    [self refreshTweet];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshTweet];
    // Do any additional setup after loading the view.
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    
    self.tweetName.text = (self.tweet.user.name);
    self.tweetName.font = [self.tweetName.font fontWithSize:18];
    self.tweetText.text = (self.tweet.text);
    self.tweetText.font = [self.tweetText.font fontWithSize:16];  self.tweetUsername.text = [@"@" stringByAppendingString: self.tweet.user.screenName];
    self.tweetUsername.font = [self.tweetText.font fontWithSize:16];
    
    [self.tweetPhoto setImageWithURL:url ];
    self.tweetPhoto.layer.cornerRadius = self.tweetPhoto.frame.size.height /2;
    self.tweetPhoto.layer.masksToBounds = YES;
    self.tweetPhoto.layer.borderWidth = 0;
    self.likeCount.text = [[NSString stringWithFormat:@"%i", self.tweet.favoriteCount] stringByAppendingString:@"  Likes"];
    self.likeCount.font = [self.likeCount.font fontWithSize:14];
    self.retweetCount.text = [[NSString stringWithFormat:@"%i", self.tweet.retweetCount]  stringByAppendingString:@"  Retweets"];
    self.retweetCount.font = [self.retweetCount.font fontWithSize:14];
//  selfturn cell;
    self.replyCount.text = [[NSString stringWithFormat:@"%i", self.tweet.replyCount]  stringByAppendingString:@"  Replies"];
    self.replyCount.font = [self.replyCount.font fontWithSize:14];
    self.tweetDate.text = [@"·" stringByAppendingString :self.tweet.createdAtString];
    self.tweetDate.font = [self.tweetDate.font fontWithSize:14];
}


- (void) didTapFavoriteAction {
    NSLog(@"%i", self.tweet.favorited);
    if (self.tweet.favorited == YES) {
        self.likeCount.text = [NSString stringWithFormat:@"%i", [self.likeCount.text intValue] - 1];
        
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
             }
         }];
        
    } else {
        self.likeCount.text = [NSString stringWithFormat:@"%i", [self.likeCount.text intValue] + 1];
        
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
             }
         }];
        
    }
    
}


- (void) didTapRetweetAction {
    
    if (self.tweet.retweeted == YES) {
        self.retweetCount.text = [NSString stringWithFormat:@"%i", [self.retweetCount.text intValue] - 1];
        
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        
        
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
             }
         }];
        
    } else {
        self.retweetCount.text = [NSString stringWithFormat:@"%i", [self.retweetCount.text intValue] + 1];
        
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        
        
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
             }
         }];
        
    }
    
}

- (void) refreshTweet {
     
    self.tweetName.text = (_tweet.user.name);
    self.tweetName.font = [self.tweetName.font fontWithSize:14];
    
    self.tweetText.text = (_tweet.text);
    self.tweetText.font = [self.tweetText.font fontWithSize:12];
//    NSLog(@"%", self.tweet.user.username)
    self.tweetUsername.text = [@"@" stringByAppendingString: self.tweet.user.screenName];
    self.tweetUsername.font = [self.tweetText.font fontWithSize:12];

    NSString *URLString = _tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    [self.tweetPhoto setImageWithURL:url ];
    self.tweetPhoto.layer.cornerRadius = self.tweetPhoto.frame.size.height /2;
    self.tweetPhoto.layer.masksToBounds = YES;
    self.tweetPhoto.layer.borderWidth = 0;
    
    UIImage *retweetIconGrey = [UIImage imageNamed: @"retweet-icon"];
    [self.retweetButton setImage:retweetIconGrey forState:UIControlStateNormal];
    
    self.likeCount.text = [NSString stringWithFormat:@"%i", _tweet.favoriteCount] ;
    self.likeCount.font = [self.likeCount.font fontWithSize:12];
    self.retweetCount.text = [NSString stringWithFormat:@"%i", _tweet.retweetCount];
    self.retweetCount.font = [self.retweetCount.font fontWithSize:12];
    
    self.replyCount.text = [NSString stringWithFormat:@"%i", _tweet.replyCount];
    self.replyCount.font = [self.replyCount.font fontWithSize:12];
    self.tweetDate.text = [@"·" stringByAppendingString: self.tweet.createdAtString];
    self.tweetDate.font = [self.tweetDate.font fontWithSize:12];
    
    if (self.tweet.favorited == YES) {

        UIImage *favorIconRed = [UIImage imageNamed: @"favor-icon-red"];
        [self.likeButton setImage:favorIconRed forState:UIControlStateNormal];
        
    } else {
        UIImage *favorIconGrey = [UIImage imageNamed: @"favor-icon"];
        [self.likeButton setImage:favorIconGrey forState:UIControlStateNormal];
    
    }
    if (self.tweet.retweeted == YES) {
        
        UIImage *retweetIconGreen = [UIImage imageNamed: @"retweet-icon-green"];
        [self.retweetButton setImage:retweetIconGreen forState:UIControlStateNormal];
        
    } else {
        UIImage *retweetIconGrey = [UIImage imageNamed: @"retweet-icon"];
        [self.retweetButton setImage:retweetIconGrey forState:UIControlStateNormal];
    }
    
}
    
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


