//
//  TweetCell.h
//  twitter
//
//  Created by Adam Issah on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface TweetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *tweetPhoto;
@property (weak, nonatomic) IBOutlet UILabel *tweetName;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *tweetUsername;


@property Tweet *tweet;
@end

NS_ASSUME_NONNULL_END
