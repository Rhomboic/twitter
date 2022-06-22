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
    // Do any additional setup after loading the view.
    _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, _composeTextView.frame.size.width - 20.0, 34.0)];
    [_placeholderLabel setText:@"What's happening"];
    [_placeholderLabel setBackgroundColor:[UIColor clearColor]];
//  [_placeholderLabel setFont:[challengeDescription font]];
    [_placeholderLabel setTextColor:[UIColor lightGrayColor]];
//  textView is UITextView object you want add placeholder text to
    
    
//    [_userPhoto setImageWithURL: ];
    
    [_composeTextView addSubview:_placeholderLabel];
}

- (void) textViewDidChange:(UITextView *)theTextView
{
  if(![_composeTextView hasText]) {
    [_composeTextView addSubview:_placeholderLabel];
  } else if ([[_composeTextView subviews] containsObject:_placeholderLabel]) {
    [_placeholderLabel removeFromSuperview];
  }
}

- (void)textViewDidEndEditing:(UITextView *)theTextView
{
  if (![_composeTextView hasText]) {
    [_composeTextView addSubview:_placeholderLabel];
  }
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
