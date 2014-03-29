//
//  Twitter.m
//  ios_twitter
//
//  Created by Arpan Nanavati on 3/28/14.
//  Copyright (c) 2014 Arpan Nanavati. All rights reserved.
//

#import "Twitter.h"

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

@end
