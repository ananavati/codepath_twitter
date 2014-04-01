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

+ (NSInteger)displayHeightForTweet:(Tweet *)tweet
{
    UITextView *textView = [[UITextView alloc] init];
	
	CGFloat textViewHeight = [self heightForTextView:textView withItem:tweet];
	CGFloat heightPadding = tweet.isRetweet ? 20 : 0;
	heightPadding += 22 + 15 + 25; // phew magic numbers lol
	
	return textViewHeight + heightPadding;
}

+ (CGFloat)heightForTextView:(UITextView *)textView withItem:(Tweet *)item
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
        self.retweetLabel.hidden = true;
    }
}

@end
