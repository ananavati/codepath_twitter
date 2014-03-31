//
//  TweetDetailsViewController.h
//  ios_twitter
//
//  Created by Arpan Nanavati on 3/30/14.
//  Copyright (c) 2014 Arpan Nanavati. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Tweet.h"
#import "ComposeTweetViewController.h"

@interface TweetDetailsViewController : UIViewController < ComposeTweetViewControllerDelegate>

@property (weak, nonatomic) id <ComposeTweetViewControllerDelegate> delegate;
@property (strong, nonatomic) Tweet *tweet;

@end
