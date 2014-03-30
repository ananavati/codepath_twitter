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

@interface Tweet : NSObject

@property (strong, nonatomic) User *author;
@property (strong, nonatomic) NSString *text;

- (BOOL)isRetweet;

+ (void)fetchLast:(int)limit withSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success andFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (Tweet *)tweetFromJSON:(NSDictionary *)data;

@end
