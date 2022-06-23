//
//  ComposeViewController.m
//  twitter
//
//  Created by Adam Issah on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"


@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *composeTextView;
@property (weak, nonatomic) IBOutlet UIImageView *myPhoto;
@property (weak, nonatomic) IBOutlet UILabel *charCount;
@property UILabel *placeholderLabel;
//@property (weak, nonatomic) UIImageView *userPhoto;

@end

@implementation ComposeViewController

- (IBAction)tweetButton:(UIBarButtonItem *)sender {
    [[APIManager shared]postStatusWithText: self.composeTextView.text completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        }
        else{
            [self dismissViewControllerAnimated:true completion:nil];
            [self.delegate didTweet:tweet];
            NSLog(@"Compose Tweet Success!");
            
        }
    }];
}
- (IBAction)closeButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *tweetBird = [UIImage imageNamed: @"account-icon"];
    [self.myPhoto setImage:tweetBird];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
