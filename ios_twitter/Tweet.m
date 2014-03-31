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

@property NSString *_displayCreatedAt;

@end

@implementation Tweet

#pragma mark - class methods

+ (Tweet *)tweetFromJSON:(NSDictionary *)data
{
	return [[Tweet alloc] initFromJSON:data];
}

+ (void)fetchLast:(int)limit withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success andFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	[[Twitter instance] GET:@"1.1/statuses/home_timeline.json"
                 parameters:@{@"count": @(limit), @"include_my_retweet": @(YES)}
                    success:success
                    failure:failure];
}

+ (Tweet *)reply:(NSString *)status toStatus:(NSString *)originalStatusId withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success andFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	[[Twitter instance] POST:@"1.1/statuses/update.json"
                  parameters:@{@"status": status, @"in_reply_to_status_id": originalStatusId}
                     success:success
                     failure:failure];
	
	return [[Tweet alloc] initWithStatus:status author:[User currentUser]];
}

+ (Tweet *)update:(NSString *)status withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success andFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	[[Twitter instance] POST:@"1.1/statuses/update.json"
                  parameters:@{@"status": status}
                     success:success
                     failure:failure];
    
	return [[Tweet alloc] initWithStatus:status author:[User currentUser]];
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

- (Tweet *)initWithStatus:(NSString *)status author:(User *)author
{
	self = [super init];
	if (self) {
		self.author = author;
		self.text = status;
		self.createdAt = [NSDate date];
	}
	
	return self;
}

- (NSDate *)dateFromString:(NSString *)string
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
	return [formatter dateFromString:string];
}

- (NSString *)displayCreatedAt
{
	if (!self._displayCreatedAt) {
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"M/d/yy, h:mm a"];
		self._displayCreatedAt = [formatter stringFromDate:self.createdAt];
	}
	
	return self._displayCreatedAt;
}

- (BOOL)isRetweet
{
	return !!self.retweeter;
}

- (NSString *)tweetId
{
	return self.rawData[@"id_str"];
}

- (void)addToFavorites
{
	if (!self.isFavorite) {
		self.isFavorite = YES;
		self.favoriteCount += 1;
        
		[[Twitter instance] POST:@"1.1/favorites/create.json"
												parameters:@{@"id": self.tweetId}
												   success:nil
												   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
													   self.favoriteCount -= 1;
													   self.isFavorite = NO;
												   }];
	}
}

- (void)removeFromFavorites
{
	if (self.isFavorite) {
		self.isFavorite = NO;
		self.favoriteCount -= 1;
        
		[[Twitter instance] POST:@"1.1/favorites/destroy.json"
												parameters:@{@"id": self.tweetId}
												   success:nil
												   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
													   self.favoriteCount += 1;
													   self.isFavorite = YES;
												   }];
	}
}

- (void)retweet
{
	if (!self.isRetweeted) {
		self.isRetweeted = YES;
		self.retweetCount += 1;
		
		NSString *url = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", self.tweetId];
		[[Twitter instance] POST:url
												parameters:nil
												   success:^(AFHTTPRequestOperation *operation, id responseObject) {
													   self.retweetId = responseObject[@"id_str"];
												   }
												   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
													   self.isRetweeted = NO;
													   self.retweetCount -= 1;
												   }];
	}
}

- (void)unretweet
{
	if (self.isRetweeted) {
		self.isRetweeted = NO;
		self.retweetCount -= 1;
		
		NSString *url = [NSString stringWithFormat:@"1.1/statuses/destroy/%@.json", self.retweetId];
		[[Twitter instance] POST:url
												parameters:nil
												   success:^(AFHTTPRequestOperation *operation, id responseObject) {
													   self.retweetId = nil;
												   }
												   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
													   NSLog(@"unretweet error: %@", error);
													   self.isRetweeted = YES;
													   self.retweetCount += 1;
												   }];
	}
}

@end
