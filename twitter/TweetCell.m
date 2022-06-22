//
//  TweetCell.m
//  twitter
//
//  Created by Adam Issah on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)didTapFavorite:(id)sender {
    self.tweet.favorited = YES;
    self.tweet.favoriteCount += 1;
    
    UIImage *favorIconRed = [UIImage imageNamed: @"favor-icon-red"];
    [self.likeButton setImage:favorIconRed forState:UIControlStateNormal];
//    self.likeCount += 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
