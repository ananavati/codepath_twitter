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

static NSString * const accessTokenKey = @"accessTokenKey";

@interface Twitter ()

@property (nonatomic, readwrite) BDBOAuth1RequestOperationManager *requestManager;
@property (nonatomic, strong) BDBOAuthToken *accessToken;

@end

@implementation Twitter

+ (Twitter *) instance
{
    static dispatch_once_t once;
    static Twitter *instance = nil;
    
    dispatch_once(&once, ^{
        instance = [[Twitter alloc] initWithBaseURL:TWITTER_BASE_URL consumerKey:TWITTER_CONSUMER_KEY consumerSecret:TWITTER_CONSUMER_SECRET];
    });
    
    return instance;
}

- (BOOL) isAuthorizedWithAccessToken
{
    return !![[NSUserDefaults standardUserDefaults] objectForKey:accessTokenKey];
}

#pragma mark - init
- (instancetype)initWithBaseURL:(NSURL *)url consumerKey:(NSString *)key consumerSecret:(NSString *)secret {
    self = [super initWithBaseURL:TWITTER_BASE_URL consumerKey:TWITTER_CONSUMER_KEY consumerSecret:TWITTER_CONSUMER_SECRET];
    if (self != nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:accessTokenKey];
        if (data) {
            self.accessToken = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    return self;
}

#pragma mark - oauth login

- (void) login
{
    if ([self isAuthorizedWithAccessToken]) {
        NSLog(@"already authorized");
        [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLoginNotification object:nil];
        [User currentUser];
    } else {
        [super fetchRequestTokenWithPath:@"/oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:@"codepath-twitter://request"] scope:nil success:^(BDBOAuthToken *requestToken) {
            NSLog(@"got requestToken");
            NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
        } failure:^(NSError *error) {
            NSLog(@"Error: %@", error.localizedDescription);
        }];
    }
    
    
}

- (BOOL)authorizationCallbackURL:(NSURL *)url onSuccess:(void (^)(void))completion
{
	if ([url.scheme isEqualToString:@"codepath-twitter"]) {
		if ([url.host isEqualToString:@"request"])	{
			NSDictionary *parameters = [NSDictionary dictionaryFromQueryString:url.query];
			if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]) {
				[[Twitter instance] fetchAccessTokenWithPath:@"/oauth/access_token"
													   method:@"POST"
												 requestToken:[BDBOAuthToken tokenWithQueryString:url.query]
													  success:^(BDBOAuthToken *accessToken) {
														  NSLog(@"access token %@", accessToken);
                                                          [self setAccessToken:accessToken];
//                                                          [self saveAccessToken:accessToken];
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
                                                              [[NSNotificationCenter defaultCenter]
                                                               postNotificationName:@"UserAuthErrorNotification"
                                                               object:self];
														  });
													  }];
			}
		}
        
		return YES;
	}
    
	return NO;
}

- (void)setAccessToken:(BDBOAuthToken *)accessToken {
    if (accessToken) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:accessToken];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:accessTokenKey];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:accessTokenKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
