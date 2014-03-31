//
//  User.m
//  ios_twitter
//
//  Created by Arpan Nanavati on 3/29/14.
//  Copyright (c) 2014 Arpan Nanavati. All rights reserved.
//

#import "User.h"

NSString * const UserDidLoginNotification = @"UserDidLoginNotification";
NSString * const UserDidLogoutNotification = @"UserDidLogoutNotification";
NSString * const UserAuthErrorNotification = @"UserAuthErrorNotification";

@implementation User

+ (User *)userFromJSON:(NSDictionary *)data
{
	static dispatch_once_t once;
    static NSMutableDictionary *users;
    
    dispatch_once(&once, ^{
        users = [[NSMutableDictionary alloc] init];
    });
    
	User *user = [users objectForKey:data[@"id"]];
    
	if (!user) {
		user = [[User alloc] init:data];
		[users setObject:user forKey:@(user.userId)];
	}
    
	return user;
}

+ (User *)currentUser
{
	static dispatch_once_t once;
	static User *user;
    
	dispatch_once(&once, ^{
        user = [[User alloc] init];
    });
    
	if (!user.userId) {
        [[Twitter instance] GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [user setCurrentUser:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed to get user: %@", error.localizedDescription);
        }];
	}
    
	return user;
}

#pragma mark - Instance Methods

- (User *)init:(NSDictionary *)data
{
	self = [super init];
	if (self) {
		[self setCurrentUser:data];
	}
	
	return self;
}

- (void)setCurrentUser:(NSDictionary *)data
{
	[self setUserId:(int)data[@"id"]];
    [self setProfileUrl:data[@"profile_image_url"]];
    [self setScreenName:[NSString stringWithFormat:@"@%@", data[@"screen_name"]]];
    [self setName:data[@"name"]];
    [self setProfileUrl:data[@"profile_image_url"]];
    [self setIsLoggedIn:true];
}

- (void)logout
{
    self.isLoggedIn = false;
	[[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
}

@end
