//
//  User.h
//  ios_twitter
//
//  Created by Arpan Nanavati on 3/29/14.
//  Copyright (c) 2014 Arpan Nanavati. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Twitter.h"

extern NSString *const UserDidLoginNotification;
extern NSString *const UserDidLogoutNotification;
extern NSString *const UserAuthErrorNotification;

@interface User : NSObject

@property int userId;
@property (strong, nonatomic) NSString *profileUrl;
@property (strong, nonatomic) NSString *screenName;

+ (User *)userFromJSON:(NSDictionary *)data;
+ (User *)currentUser;
- (User *)init:(NSDictionary *)data;

@end
