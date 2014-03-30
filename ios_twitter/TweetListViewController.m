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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    
    // register the table view cell with the table view
    static NSString *cellIdentifier = @"TweetTableViewCell";
    
    UINib *tweetTableViewCellNib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tweetListTableView registerNib:tweetTableViewCellNib forCellReuseIdentifier:cellIdentifier];
    
    [self.navigationController showSGProgressWithDuration:6];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector( onRefresh:forState: ) forControlEvents:UIControlEventValueChanged];
    [self.tweetListTableView addSubview:self.refreshControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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
	UITextView *textView = [[UITextView alloc] init];
	
	CGFloat textViewHeight = [self heightForTextView:textView withItem:tweet];
	CGFloat heightPadding = tweet.isRetweet ? 20 : 0;
	heightPadding += 25 + 27 + 25; // phew magic numbers lol
	
	return textViewHeight + heightPadding;
}

- (CGFloat)heightForTextView:(UITextView *)textView withItem:(Tweet *)item
{
	if (item) {
		[textView setAttributedText:[[NSAttributedString alloc] initWithString:item.text]];
	}
	
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGFloat width = screenRect.size.width;
	width -= 84; // magic number
	
	textView.dataDetectorTypes = UIDataDetectorTypeLink;
	CGRect textRect = [textView.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
												  options:NSStringDrawingUsesLineFragmentOrigin
											   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
												  context:nil];
	
	return textRect.size.height;
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

- (void)appendTweets:(id)rawTweets
{
	for (NSDictionary *data in rawTweets) {
		[self.tweets addObject:[Tweet tweetFromJSON:data]];
	}
}

@end
