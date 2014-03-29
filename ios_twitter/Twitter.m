//
//  Twitter.m
//  ios_twitter
//
//  Created by Arpan Nanavati on 3/28/14.
//  Copyright (c) 2014 Arpan Nanavati. All rights reserved.
//

#import "Twitter.h"

#define TWITTER_BASE_URL [NSURL URLWithString:@"https://api.twitter.com/"]
#define TWITTER_CONSUMER_KEY @"cTfqsGSY9MnZOEqrl01WQ"
#define TWITTER_CONSUMER_SECRET @"jv0l0i1TcydOgVDS8RjjhS530WDEw85Q94lfFepe8"

@interface Twitter ()

@property (nonatomic, readwrite) BDBOAuth1RequestOperationManager *requestManager;

@end

@implementation Twitter

+ (Twitter *) instance
{
    static dispatch_once_t once;
    static Twitter *instance = nil;
    
    dispatch_once(&once, ^{
        instance = [[Twitter alloc] init];
    });
    
    return instance;
}

+ (BOOL)isAuthorized
{
	return [[[Twitter instance] requestManager] isAuthorized];
}

#pragma mark - init
- (id)init
{
    self = [super init];
    if (self) {
        self.requestManager = [[BDBOAuth1RequestOperationManager alloc] initWithBaseURL:TWITTER_BASE_URL
                                                                            consumerKey:TWITTER_CONSUMER_KEY
                                                                         consumerSecret:TWITTER_CONSUMER_SECRET];
    }
    
    return self;
}


#pragma mark - oauth login

- (void) login
{
    [self.requestManager.requestSerializer removeAccessToken];
    [self.requestManager fetchRequestTokenWithPath:@"/oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:@"codepath-twitter://request"] scope:nil success:^(BDBOAuthToken *requestToken) {
        NSLog(@"got requestToken");

        
        NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }];
}

- (BOOL)authorizationCallbackURL:(NSURL *)url onSuccess:(void (^)(void))completion
{
	if ([url.scheme isEqualToString:@"codepath-twitter"]) {
		if ([url.host isEqualToString:@"request"])	{
			NSDictionary *parameters = [NSDictionary dictionaryFromQueryString:url.query];
			if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]) {
				[self.requestManager fetchAccessTokenWithPath:@"/oauth/access_token"
													   method:@"POST"
												 requestToken:[BDBOAuthToken tokenWithQueryString:url.query]
													  success:^(BDBOAuthToken *accessToken) {
														  NSLog(@"access token %@", accessToken);
														  [self.requestManager.requestSerializer saveAccessToken:accessToken];
														  [User currentUser];
                                                          
														  if (completion) {
															  dispatch_async(dispatch_get_main_queue(), ^{
                                                                  completion();
															  });
														  }
													  }
													  failure:^(NSError *error) {
														  NSLog(@"Error: %@", error.localizedDescription);
														  dispatch_async(dispatch_get_main_queue(), ^{
															  [[[UIAlertView alloc] initWithTitle:@"Error"
																						  message:@"!!Could not acquire OAuth access token. Please try again later."
																						 delegate:self
																				cancelButtonTitle:@"Dismiss"
																				otherButtonTitles:nil] show];
														  });
													  }];
			}
		}
        
		return YES;
	}
    
	return NO;
}


@end
