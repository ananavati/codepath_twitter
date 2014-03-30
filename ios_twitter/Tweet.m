//
//  Tweet.m
//  ios_twitter
//
//  Created by Arpan Nanavati on 3/29/14.
//  Copyright (c) 2014 Arpan Nanavati. All rights reserved.
//

#import "Tweet.h"

@interface Tweet ()

@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSDictionary *rawData;
@property (strong, nonatomic) NSString *retweetId;

@property int favoriteCount;
@property BOOL isFavorite;
@property int retweetCount;
@property BOOL isRetweeted;

@end

@implementation Tweet

#pragma mark - class methods

+ (Tweet *)tweetFromJSON:(NSDictionary *)data
{
	return [[Tweet alloc] initFromJSON:data];
}

+ (void)fetchLast:(int)limit withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success andFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	[[[Twitter instance] requestManager] GET:@"1.1/statuses/home_timeline.json"
                                  parameters:@{@"count": @(limit), @"include_my_retweet": @(YES)}
                                     success:success
                                     failure:failure];
}

#pragma mark - instance methods

- (Tweet *)initFromJSON:(NSDictionary *)data
{
	self = [super init];
	if (self) {
        //		NSLog(@"new tweet with: %@", data);
		self.rawData = data;
		NSDictionary *retweet = self.rawData[@"retweeted_status"];
        
        if (retweet) {
			self.retweeter = [User userFromJSON:data[@"user"]];
			self.author = [User userFromJSON:retweet[@"user"]];
			self.text = retweet[@"text"];
			self.createdAt = [self dateFromString:retweet[@"created_at"]];
		}
        else
        {
            self.author = [User userFromJSON:data[@"user"]];
            self.text = self.rawData[@"text"];
            self.createdAt = [self dateFromString:self.rawData[@"created_at"]];
        }
        
        self.elapsedTime = [MHPrettyDate prettyDateFromDate:self.createdAt withFormat:MHPrettyDateShortRelativeTime];
        
        self.favoriteCount = (int)[self.rawData[@"favorite_count"] integerValue];
		self.isFavorite = [self.rawData[@"favorited"] boolValue];
		
		self.retweetCount = (int)[self.rawData[@"retweet_count"] integerValue];
		self.isRetweeted = [self.rawData[@"retweeted"] boolValue];
		
		if (self.rawData[@"current_user_retweet"]) {
			self.retweetId = self.rawData[@"current_user_retweet"][@"id_str"];
		}
	}
	
	return self;
}

- (NSDate *)dateFromString:(NSString *)string
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
	return [formatter dateFromString:string];
}

- (BOOL)isRetweet
{
	return !!self.retweeter;
}

@end
