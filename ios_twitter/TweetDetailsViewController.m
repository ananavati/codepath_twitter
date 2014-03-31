//
//  TweetDetailsViewController.m
//  ios_twitter
//
//  Created by Arpan Nanavati on 3/30/14.
//  Copyright (c) 2014 Arpan Nanavati. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import <UIImageView+AFNetworking.h>

@interface TweetDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorUserNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;

- (IBAction)onReplyIconButton:(id)sender;
- (IBAction)onRetweetIconButton:(id)sender;
- (IBAction)onFavoriteIconButton:(id)sender;

@end

@implementation TweetDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Tweet";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addReplyToNavBar];
    
    [self initFromTweet];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initFromTweet
{
    Tweet *tweet = self.tweet;
    
    [self.tweetTextLabel setText:tweet.text];
    [self.timeStampLabel setText:tweet.displayCreatedAt];
    [self.authorNameLabel setText:tweet.author.name];
    [self.authorUserNameLabel setText:tweet.author.screenName];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:tweet.author.profileUrl]];
    
    [self updateRetweetCount];
    [self updateFavoriteCount];
    
    if (tweet.isRetweet) {
        [self.retweetLabel setText:[NSString stringWithFormat:@"%@ retweeted", tweet.retweeter.name]];
    } else {
        self.retweetLabel.hidden = true;
    }
}

- (void) addReplyToNavBar
{
    UIBarButtonItem *replyButton = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStyleDone target:self action:@selector(onReplyButton:)];
    self.navigationItem.rightBarButtonItem = replyButton;
}

- (void) onReplyButton:(id) sender
{
    ComposeTweetViewController *reply = [[ComposeTweetViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:reply];
    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    reply.delegate = self;
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)updateFavoriteCount
{
	self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
	self.favoriteCountLabel.textColor = self.tweet.isFavorite ? [UIColor orangeColor] : [UIColor lightGrayColor];
}

- (void)updateRetweetCount
{
	self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
	self.retweetCountLabel.textColor = self.tweet.isRetweeted ? [UIColor orangeColor] : [UIColor lightGrayColor];
}

- (IBAction)onReplyIconButton:(id)sender {
    ComposeTweetViewController *reply = [[ComposeTweetViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:reply];
    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    reply.delegate = self;
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)onRetweetIconButton:(id)sender {
    if (self.tweet.isRetweeted) {
		[self.tweet unretweet];
	}
	else {
		[self.tweet retweet];
	}
    
	[self updateRetweetCount];
}

- (IBAction)onFavoriteIconButton:(id)sender {
    if (self.tweet.isFavorite) {
		[self.tweet removeFromFavorites];
	}
	else {
		[self.tweet addToFavorites];
	}
    
	[self updateFavoriteCount];
}

#pragma mark - ComposeTweetViewControllerDelegate methods

- (void)addTweet:(Tweet *)tweet
{
	[self.delegate addTweet:tweet];
}

@end
