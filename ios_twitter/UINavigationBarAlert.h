//
//  UINavigationBarAlert.h
//  ExampleApp
//
//  Created by Filip Stefansson on 13-10-22.
//  Copyright (c) 2013 Pixby Media AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationBar+UINavigationBarAlert.h"

@interface UINavigationBarAlert : UIView

// Color of the title
@property (nonatomic, retain) UIColor *titleColor;

// The alert text
@property (nonatomic, retain) NSString *titleText;

// Initializer
-(id)initWithTitle:(NSString *)title andTitleColor:(UIColor *)color;
@end
