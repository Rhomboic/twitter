//
//  TweetCell.m
//  twitter
//
//  Created by Adam Issah on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"
#import "DateTools.h"
#import "UIImageView+AFNetworking.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
- (IBAction)didTapFavorite:(id)sender {
    [self didTapFavoriteAction];
    [self refreshTweet];
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

- (IBAction)didTapRetweet:(id)sender {
    [self didTapRetweetAction];
    [self refreshTweet];
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
    
    self.likeCount.text = [NSString stringWithFormat:@"%i", _tweet.favoriteCount];
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
    
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
