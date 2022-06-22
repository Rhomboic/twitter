//
//  TweetCell.m
//  twitter
//
//  Created by Adam Issah on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)didTapFavorite:(id)sender {
    
    NSLog(@"%i", self.tappedLike);
    if (self.tappedLike == 1) {
        UIImage *favorIconGrey = [UIImage imageNamed: @"favor-icon"];
        [self.likeButton setImage:favorIconGrey forState:UIControlStateNormal];
        
        self.likeCount.text = [NSString stringWithFormat:@"%i", [self.likeCount.text intValue] - 1];
        
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        
        self.tappedLike = 0;
        
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
             }
         }];
        
    } else {
        UIImage *favorIconRed = [UIImage imageNamed: @"favor-icon-red"];
        [self.likeButton setImage:favorIconRed forState:UIControlStateNormal];
        
        self.likeCount.text = [NSString stringWithFormat:@"%i", [self.likeCount.text intValue] + 1];
        
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        
        self.tappedLike = 1;
        
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
    NSLog(@"%i", self.tappedRetweet);
    if (self.tappedRetweet == 1) {
        UIImage *retweetIconGrey = [UIImage imageNamed: @"retweet-icon"];
        [self.retweetButton setImage:retweetIconGrey forState:UIControlStateNormal];
        
        self.retweetCount.text = [NSString stringWithFormat:@"%i", [self.retweetCount.text intValue] - 1];
        
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        
        self.tappedRetweet = 0;
        
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
             }
         }];
        
    } else {
        UIImage *retweetIconGreen = [UIImage imageNamed: @"retweet-icon-green"];
        [self.retweetButton setImage:retweetIconGreen forState:UIControlStateNormal];
        
        self.retweetCount.text = [NSString stringWithFormat:@"%i", [self.retweetCount.text intValue] + 1];
        
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        
        self.tappedRetweet = 1;
        
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
             }
         }];
        
    }
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
