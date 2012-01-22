//
//  StayConnectedAppDelegate.m
//  StayConnected
//
//  Created by Christian Smith on 10/01/2012.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "AppMenuViewController.h"
#import "AppStackController.h"
#import "FacebookContactsProvider.h"
#import <objc/runtime.h>
#import "ConnectionController.h"
#import "WebViewController.h"
#import "FacebookConstants.h"

@interface AppDelegate ()
@property (nonatomic, strong) PSStackedViewController *stackController;
@property (nonatomic, strong) ContactProvider *fbProvider;

- (void) swapOpenURLImplementation;
- (void) handleFBLogin:(NSURL*)url;
- (void) handleURL:(NSURL *)url;
@end


// this implementation handles the open of URLs app wide. Typically they are opened in Safari, but our up should
// keep URL requests inside the app, see also: http://52apps.net/post/879106231/method-swizzling-uitextview-and-safari
@implementation UIApplication (Private)

-(BOOL) customOpenURL:(NSURL*)url {
	
    if ([[url absoluteString] hasPrefix:@"fbauth://"]) {
        return [XAppDelegate.fbProvider openURL:url];
    }
    else if ([[url absoluteString] hasPrefix:@"https://m.facebook.com/dialog/oauth"]) {
			// fb login dialog
        [XAppDelegate handleFBLogin:url];
        return YES;
    }
    else if ([[url absoluteString] hasPrefix:[NSString stringWithFormat:@"fb%@://authorize", sFacebookAppId]]) {
        [XAppDelegate.stackController dismissModalViewControllerAnimated:YES];	
        return [XAppDelegate.fbProvider openURL:url];
		}
    else {
        [XAppDelegate handleURL:url];
        return YES;
    }
}
@end

@implementation AppDelegate

@synthesize stackController = mStackController;
@synthesize window=mWindow;
@synthesize fbProvider = mFBProvider;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // use our own URL Handler
    [self swapOpenURLImplementation];
    
    // set the fbProvider, just for testing purposes
    self.fbProvider = [(ContactProvider*)[[FacebookContactsProvider alloc] init] autorelease];
    
    // set root controller as stack controller
    AppMenuViewController *masterController = [[AppMenuViewController alloc] init];
    self.stackController = [[AppStackController alloc] initWithRootViewController:masterController];
    
    self.window.rootViewController = self.stackController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc {
    self.fbProvider = nil;
    self.window = nil;
    self.stackController = nil;
    [super dealloc];
}

#pragma mark - URL handling 
- (void) dismiss:(UIViewController *)controller {	
    // Dismiss the modal view controller
    if (self.stackController.modalViewController.modalViewController ) {
        [self.stackController.modalViewController dismissModalViewControllerAnimated:NO];
    }
    else
        [self.stackController dismissModalViewControllerAnimated:NO];	
}

#pragma mark - URL handling 
- (void) swapOpenURLImplementation {
    
    Method customOpenUrl = class_getInstanceMethod([UIApplication class], @selector(customOpenURL:));
    Method openUrl = class_getInstanceMethod([UIApplication class], @selector(openURL:));
    method_exchangeImplementations(customOpenUrl, openUrl);
}

- (void) handleURL:(NSURL*)url {
	
	// Create the modal view controller
	WebViewController *webViewController = [[[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil] autorelease];
	
	// We are the delegate responsible for dismissing the modal view 
	webViewController.delegate = self;
	webViewController.url = url;
	webViewController.modalPresentationStyle = UIModalPresentationFormSheet;
	
	// Create a Navigation controller
	UINavigationController *navController = [[[UINavigationController alloc]
											  initWithRootViewController:webViewController] autorelease];
	
//    navController.navigationBar.tintColor = [UIColor baGrayColor];	
	
	// show the navigation controller modally
	[self.window.rootViewController presentModalViewController:navController animated:YES]; 
}

- (void) handleFBLogin:(NSURL*)url {
	
	// Create the modal view controller
	ConnectionController *controller = [[[ConnectionController alloc] initWithNibName:nil bundle:nil] autorelease];
	
	// We are the delegate responsible for dismissing the modal view 
	controller.delegate = self;
	controller.url = url;
    
    // Create a Navigation controller
	UINavigationController *navController = [[[UINavigationController alloc]
											  initWithRootViewController:controller] autorelease];
	
  //  navController.navigationBar.tintColor = [UIColor baGrayColor];	
	
	// show the navigation controller modally
	navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    if (self.stackController.modalViewController) 
        [self.stackController.modalViewController presentModalViewController:navController animated:YES];
    else
        [self.stackController presentModalViewController:navController animated:YES]; 
}

@end
