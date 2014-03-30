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
		
        self.author = [User userFromJSON:data[@"user"]];
        self.text = self.rawData[@"text"];
        self.createdAt = [self dateFromString:self.rawData[@"created_at"]];
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
	return false;
}

@end
