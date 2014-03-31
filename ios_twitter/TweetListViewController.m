//
//  TweetListViewController.m
//  ios_twitter
//
//  Created by Arpan Nanavati on 3/29/14.
//  Copyright (c) 2014 Arpan Nanavati. All rights reserved.
//

#import "TweetListViewController.h"

@interface TweetListViewController ()

@property (strong, nonatomic) NSMutableArray *tweets;
@property (weak, nonatomic) IBOutlet UITableView *tweetListTableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation TweetListViewController

static NSString *cellIdentifier = @"TweetTableViewCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Tweets";
        [self initialize];
    }
    return self;
}

- (void) initialize
{
    self.tweets = [[NSMutableArray alloc] init];
    [self getTweets];
}

- (void)onRefresh:(id)sender forState:(UIControlState)state {
    [self.refreshControl endRefreshing];
    
    [self getTweets];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tweetListTableView.delegate = self;
    self.tweetListTableView.dataSource = self;
    
    [self.tweetListTableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
    [self.navigationController showSGProgressWithDuration:6];
    [self addRefreshControl];
    [self addComposeTweetButtonToNavBar];
    [self addLogoutButton];
}

- (void) addComposeTweetButtonToNavBar
{
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStyleDone target:self action:@selector(onComposeButton:)];
    self.navigationItem.rightBarButtonItem = composeButton;
}

- (void) addLogoutButton
{
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleDone target:self action:@selector(onLogoutButton:)];
    self.navigationItem.leftBarButtonItem = logoutButton;
}

- (void) onComposeButton:(id)sender
{
    ComposeTweetViewController *composeTweetViewController = [[ComposeTweetViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:composeTweetViewController];
    navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical; // Rises from below
    
    composeTweetViewController.delegate = self;
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void) onLogoutButton:(id)sender
{
    [[User currentUser] logout];
}

- (void)addRefreshControl
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector( onRefresh:forState: ) forControlEvents:UIControlEventValueChanged];
    [self.tweetListTableView addSubview:self.refreshControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view

// Tap on table Row
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    TweetDetailsViewController *detailsController = [[TweetDetailsViewController alloc] init];
    
    Tweet *tweet = self.tweets[indexPath.row];
    [detailsController setTweet:tweet];
    
    [self.navigationController pushViewController:detailsController animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	Tweet *tweet = self.tweets[indexPath.row];
    return [TweetTableViewCell displayHeightForTweet:tweet];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TweetTableViewCell";
    TweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
	Tweet *tweet = self.tweets[indexPath.row];
	[cell updateWithTweet:tweet indexPath:indexPath];
    
    return cell;
}

#pragma mark - twitter api calls


- (void) getTweets
{
    [self.navigationController showSGProgressWithDuration:6];
    
    [Tweet fetchLast:50
            withSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self.navigationController finishSGProgress];
                [self.refreshControl endRefreshing];
                
                [self appendTweets:responseObject];
                [self.tweetListTableView reloadData];
            }
             andFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 // throw the network error popup
                 [self.navigationController finishSGProgress];
                 [self.refreshControl endRefreshing];
                 
                 // show the network error in the navbar alert view
                 [self.navigationController.navigationBar showAlertWithTitle:@"Network Error"];
             }];

}

- (void) appendTweets:(id)rawTweets
{
	for (NSDictionary *data in rawTweets) {
		[self.tweets addObject:[Tweet tweetFromJSON:data]];
	}
}

- (void) prependTweet:(Tweet *)tweet
{
	[self.tweets insertObject:tweet atIndex:0];
    
    [self.tweetListTableView reloadData];
}

#pragma mark - ComposeTweetViewControllerDelegate

- (void) addTweet:(Tweet *)tweet
{
	[self prependTweet:tweet];
}


@end
