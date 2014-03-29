//
//  TwitterAppDelegate.h
//  ios_twitter
//
//  Created by Arpan Nanavati on 3/28/14.
//  Copyright (c) 2014 Arpan Nanavati. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
