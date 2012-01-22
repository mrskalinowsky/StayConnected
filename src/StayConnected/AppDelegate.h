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
@class ContactProvider;

#define XAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface AppDelegate : NSObject <UIApplicationDelegate, DismissDelegate> {
@private    
    UIWindow						*mWindow;	
    PSStackedViewController         *mStackController;
    ContactProvider                 *mFBProvider;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, strong, readonly) PSStackedViewController *stackController;
@property (nonatomic, strong, readonly) ContactProvider *fbProvider;

@end
