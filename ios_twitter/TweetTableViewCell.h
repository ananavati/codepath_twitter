//
//  TweetTableViewCell.h
//  
//
//  Created by Arpan Nanavati on 3/29/14.
//
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;

- (void)updateWithTweet:(Tweet *)tweet indexPath:(NSIndexPath *)indexPath;

@end
