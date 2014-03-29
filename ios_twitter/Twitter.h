//
//  Twitter.h
//  ios_twitter
//
//  Created by Arpan Nanavati on 3/28/14.
//  Copyright (c) 2014 Arpan Nanavati. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDBOAuth1RequestOperationManager.h"
#import "NSDictionary+BDBOAuth1Manager.h"
#import "User.h"

@interface Twitter : BDBOAuth1RequestOperationManager

+ (Twitter *)instance;
+ (BOOL) isAuthorized;

#pragma mark - oauth

@property (nonatomic, readonly) BDBOAuth1RequestOperationManager *requestManager;

- (void) login;
- (BOOL) authorizationCallbackURL:(NSURL *)url onSuccess:(void (^)(void))completion;

@end
