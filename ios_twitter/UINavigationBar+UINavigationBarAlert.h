//
//  UINavigationBar+UINavigationBarAlert.h
//  ExampleApp
//
//  Created by Filip Stefansson on 13-10-23.
//  Copyright (c) 2013 Pixby Media AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (UINavigationBarAlert)

// Shows an alert with a title
-(void)showAlertWithTitle:(NSString *)title;

// Hides the alert
-(void)hideAlert;

// Shows an alert with a title that hides in xx
-(void)showAlertWithTitle:(NSString *)title hideAfter:(NSTimeInterval)timer;


@end
