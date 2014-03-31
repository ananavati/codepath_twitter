//
//  Tweet.h
//  ios_twitter
//
//  Created by Arpan Nanavati on 3/29/14.
//  Copyright (c) 2014 Arpan Nanavati. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Twitter.h"
#import "User.h"
#import "MHPrettyDate.h"

@interface Tweet : NSObject
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *elapsedTime;
@property (strong, nonatomic) User *author;
@property (strong, nonatomic) User *retweeter;

- (NSString *)tweetId;
- (BOOL)isRetweet;
- (NSString *)displayCreatedAt;

+ (void)fetchLast:(int)limit withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success andFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (Tweet *)reply:(NSString *)status toStatus:(NSString *)originalStatusId withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success andFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+ (Tweet *)update:(NSString *)status withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success andFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (Tweet *)tweetFromJSON:(NSDictionary *)data;

@end
