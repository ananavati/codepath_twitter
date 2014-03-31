//
//  ComposeTweetViewController.m
//  ios_twitter
//
//  Created by Arpan Nanavati on 3/30/14.
//  Copyright (c) 2014 Arpan Nanavati. All rights reserved.
//

#import "ComposeTweetViewController.h"

@interface ComposeTweetViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextView *tweetText;

@property (strong, nonatomic) UIBarButtonItem *characterCount;

@property (strong, nonatomic) Tweet *tweet;
@property (weak, nonatomic) UIBarButtonItem *tweetButton;

@end

@implementation ComposeTweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initFromCurrentUser];
    
    [self addTweetButton];
    [self addCancelButton];
}

- (void) initFromCurrentUser
{
    self.tweetText.delegate = self;

	// start with tweet button disabled to prevent posting empty tweets
	self.tweetButton.enabled = NO;
    
    // add a fake button to render character count
	self.characterCount = [[UIBarButtonItem alloc] initWithTitle:@"140" style:UIBarButtonItemStylePlain target:nil action:nil];
	
	User *currentUser = [User currentUser];
    [self.nameLabel setText:currentUser.name];
    [self.usernameLabel setText:currentUser.screenName];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:currentUser.profileUrl]];
    self.tweetText.text = self.tweet ? [NSString stringWithFormat:@"@%@ ", self.tweet.author.screenName] : @"";
    [self.tweetText becomeFirstResponder];
}

- (void) addTweetButton
{
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStyleDone target:self action:@selector(onTweetButton:)];
    self.navigationItem.rightBarButtonItem = tweetButton;
    self.navigationItem.rightBarButtonItems = @[tweetButton, self.characterCount];
    self.tweetButton = tweetButton;
}

- (void) addCancelButton
{
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(onCancelButton:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self updateNavigationButtonsWithCount];
}

- (void)updateNavigationButtonsWithCount
{
	int count = 140 - (int)self.tweetText.text.length;
    
	if (count >= 0 && count < 140) {
		self.tweetButton.enabled = YES;
		self.characterCount.title = [NSString stringWithFormat:@"%d", count];
		self.characterCount.tintColor = [UIColor lightGrayColor];
	}
	else {
		self.tweetButton.enabled = NO;
		self.characterCount.title = [NSString stringWithFormat:@"%d", count > 0 ? count : -count];
		self.characterCount.tintColor = [UIColor redColor];
	}
}

#pragma mark - UITextField Delegate

- (void)textViewDidChange:(UITextView *)textView
{
	[self updateNavigationButtonsWithCount];
}

#pragma mark - Button Action Callbacks

- (void) onTweetButton:(id)sender
{
	Tweet *newTweet;
	
	if (self.tweet) {
		newTweet = [Tweet reply:self.tweetText.text toStatus:self.tweet.tweetId withSuccess:nil andFailure:nil];
	}
	else {
//		newTweet = [Tweet update:self.tweetText.text withSuccess:nil andFailure:nil];
        newTweet = [Tweet update:self.tweetText.text withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@" response ");
        } andFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
	}
	
	[self.delegate addTweet:newTweet];
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void) onCancelButton:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}


@end
