//
//  TweetTableViewCell.m
//  
//
//  Created by Arpan Nanavati on 3/29/14.
//
//

#import "TweetTableViewCell.h"
#import <UIImageView+AFNetworking.h>

@interface TweetTableViewCell ()

@property (strong, nonatomic) Tweet *tweet;

@end

@implementation TweetTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithTweet:(Tweet *)tweet indexPath:(NSIndexPath *)indexPath
{
    [self setTweet:tweet];
    [self setTag:indexPath.row];
    [self.tweetTextLabel setText:tweet.text];
    [self.timeStampLabel setText:tweet.elapsedTime];
    [self.authorNameLabel setText:tweet.author.name];
    [self.userNameLabel setText:tweet.author.screenName];
    [self.tweetImageView setImageWithURL:[NSURL URLWithString:tweet.author.profileUrl]];
    
    if (tweet.isRetweet) {
        [self.retweetLabel setText:[NSString stringWithFormat:@"%@ retweeted", tweet.retweeter.name]];
    } else {
//        [self.retweetLabel removeFromSuperview];
    }
}


@end
