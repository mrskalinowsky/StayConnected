//
//  StayConnectedAppDelegate.h
//  StayConnected
//
//  Created by Christian Smith on 10/01/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StayConnectedViewController;

@interface StayConnectedAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet StayConnectedViewController *viewController;

@end
