//
//  Twitter.h
//  ios_twitter
//
//  Created by Arpan Nanavati on 3/28/14.
//  Copyright (c) 2014 Arpan Nanavati. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDBOAuth1RequestOperationManager.h"

@interface Twitter : BDBOAuth1RequestOperationManager

+ (Twitter *)instance;

@end
