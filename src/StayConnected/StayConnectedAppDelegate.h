//
//  StayConnectedAppDelegate.h
//  StayConnected
//
//  Created by Christian Smith on 10/01/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StayConnectedViewController;
@class PSStackedViewController;

#define XAppDelegate ((StayConnectedAppDelegate *)[[UIApplication sharedApplication] delegate])

@interface StayConnectedAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow						*mWindow;	
    PSStackedViewController         *mStackController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, strong, readonly) PSStackedViewController *stackController;


@end
