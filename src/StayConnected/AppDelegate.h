//
//  StayConnectedAppDelegate.h
//  StayConnected
//
//  Created by Christian Smith on 10/01/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DismissDelegate.h"

@class StayConnectedViewController;
@class PSStackedViewController;

#define XAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface AppDelegate : NSObject <UIApplicationDelegate, DismissDelegate> {
@private    
    UIWindow						*mWindow;	
    PSStackedViewController         *mStackController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, strong, readonly) PSStackedViewController *stackController;

-( BOOL )handleProviderURL:( NSURL * )inURL;

// general available access to the datastore
+ (NSManagedObjectContext*) managedObjectContext;
+ (NSManagedObjectContext*) managedObjectContext:(NSPersistentStoreCoordinator*)inCoordinator;
+ (NSPersistentStoreCoordinator*) persistentStoreCoordinator:(NSString *)inName;

@end
