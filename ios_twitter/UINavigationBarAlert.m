//
//  UINavigationBarAlert.m
//  ExampleApp
//
//  Created by Filip Stefansson on 13-10-22.
//  Copyright (c) 2013 Pixby Media AB. All rights reserved.
//

#import "UINavigationBarAlert.h"

@implementation UINavigationBarAlert

@synthesize titleColor, titleText;

-(id)initWithTitle:(NSString *)title andTitleColor:(UIColor *)color
{
    self = [super init];
    if (self) {
        
        // Set title and color
        self.titleText = title;
        self.titleColor = color;

        // Lower alpha to make it transparant
        self.alpha = 0.8;
        
        // Set autoresizing
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        
    }
    return self;
}

-(UILabel *)createLabelWithText:(NSString *)text
{
    // Create a frame for the label
    CGRect frame = self.frame;
    frame.size.width -= 20;
    frame.size.height -= 10;
    frame.origin.x = 10;
    frame.origin.y = 5;
    
    // Create new label with the frame
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    
    // Add text to the label
    label.text = [@"\u26A0  " stringByAppendingString:text];
    
    // Style the label
    label.minimumScaleFactor = 0.5;
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = self.titleColor;
    label.textAlignment = NSTextAlignmentCenter;
    
    // Set autoresizing
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    return label;
}

- (void)drawRect:(CGRect)rect
{
    // Create label
    UILabel *label = [self createLabelWithText:self.titleText];
    
    // Add the label to the alert
    [self addSubview:label];
}

@end
