//
//  ComposeTweetViewController.h
//  ios_twitter
//
//  Created by Arpan Nanavati on 3/30/14.
//  Copyright (c) 2014 Arpan Nanavati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+AFNetworking.h>

#import "User.h"
#import "Tweet.h"

@class ComposeTweetViewController;

@protocol ComposeTweetViewControllerDelegate <NSObject>

- (void)addTweet:(Tweet *)tweet;

@end

@interface ComposeTweetViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, weak) id <ComposeTweetViewControllerDelegate> delegate;

@end

