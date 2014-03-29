//
//  UINavigationBar+UINavigationBarAlert.m
//  ExampleApp
//
//  Created by Filip Stefansson on 13-10-23.
//  Copyright (c) 2013 Pixby Media AB. All rights reserved.
//

#import "UINavigationBar+UINavigationBarAlert.h"
#import "UINavigationBarAlert.h"

@implementation UINavigationBar (UINavigationBarAlert)

# pragma mark Init methods

-(UINavigationBarAlert *)createAlertViewWithTitle:(NSString *)title
{
    // Create the alert
    UINavigationBarAlert *alert = [[UINavigationBarAlert alloc] initWithTitle:title andTitleColor:[UIColor whiteColor]];
    
    // Get navigationBar frame, and use it to set the alert view frame
    CGRect frame = self.frame;
    
    // New height
    frame.size.height = 44;
    
    // Set the top position to the navBars height
    frame.origin.y = self.frame.size.height;
    
    // Assign the new frame to the alert
    alert.frame = frame;
    
    // Hide everything outside the alert
    alert.clipsToBounds = YES;
    
    // Default style
    alert.backgroundColor = [UIColor lightGrayColor];

    return alert;
}

# pragma mark Show alert methods

-(void)showAlertWithTitle:(NSString *)title
{
    UINavigationBarAlert *alert = [self createAlertViewWithTitle:title];
    
    // Get alert height
    float height = alert.frame.size.height;
    
    // Set height to 0 on alert so we can animate it back to the original
    CGRect frame = alert.frame;
    frame.size.height = 0;
    alert.frame = frame;
    
    // Add it to navbar
    [self addSubview:alert];
    
    // Animate back to original height.
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = alert.frame;
        frame.size.height = height;
        alert.frame = frame;
    }];
    
}

-(void)showAlertWithTitle:(NSString *)title hideAfter:(NSTimeInterval)timer
{
    [self showAlertWithTitle:title];
    [self performSelector:@selector(hideAlert) withObject:nil afterDelay:timer];
}

#pragma mark Hide alert methods

-(void)hideAlert
{
    // Get all alert views so we can hide them
    for (id subview in self.subviews)
    {
        if ([subview isKindOfClass:[UINavigationBarAlert class]])
        {
            // Get the alert
            UINavigationBarAlert *alert = subview;
            
            // Animate the alert and then remove it from navBar
            [UIView animateWithDuration:0.2 animations:^{
                CGRect frame = alert.frame;
                frame.size.height = 0;
                alert.frame = frame;
            } completion:^(BOOL finished) {
                // Remove when animation is completed
                [alert removeFromSuperview];
            }];
        }
    }
            
}


@end
