
#import <objc/runtime.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "AppMenuViewController.h"
#import "AppStackController.h"
#import "FacebookContactsProvider.h"
#import "LinkedInContactsProvider.h"
#import "ConnectionController.h"
#import "WebViewController.h"
#import "FacebookConstants.h"
#import "LinkedInConstants.h"
#import "TwitterContactsProvider.h"
#import "ContactAttributes.h"
#import "LocalContactsController.h"
#import "Constants.h"


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

static NSManagedObjectContext			*sManagedObjectContext;
static NSManagedObjectModel             *sManagedObjectModel;
static NSPersistentStoreCoordinator     *sPersistentStoreCoordinator;	

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
+ (NSManagedObjectModel *)managedObjectModel {
    
    if (sManagedObjectModel != nil) {
        return sManagedObjectModel;
    }	
	@try {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:APP_NAME ofType:@"momd"];
        NSURL *momURL = [NSURL fileURLWithPath:path];
        NSLog(@"db model path: %@", path);
        NSLog(@"momURL: %@", momURL);
        sManagedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
	}
	@catch (NSException *exception) {
		NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
	}
    return sManagedObjectModel;
}

/**
 Returns the path to the application's documents directory.
 */
+ (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator:(NSString *)inName {
	
	NSMutableString* fileName = [[NSMutableString alloc ] initWithString:inName];
	[fileName appendString:@".sqlite"];
    NSString *storePath = [[AppDelegate applicationDocumentsDirectory] stringByAppendingPathComponent:fileName];
    [ fileName release ];
    /*
     Set up the store.
     Create the store, if it doesn't exists
     */
    NSFileManager *fileManager = [NSFileManager defaultManager];    
	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
    NSError *error;
    NSPersistentStoreCoordinator *coordinator;
	@try {
        coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    }
    @catch (NSException *exception) {
		NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);        
        if (!coordinator) {            
            // try to remove the file
            [fileManager removeItemAtPath:storePath error:&error];
        }
	}
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible
         * The schema for the persistent store is incompatible with current managed object model
         Check the error message to determine what the actual problem was.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
        // file exits and is very likely not compatible - so nuke it
        if (![fileManager removeItemAtPath:storePath error:&error] || 
            ![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }            
    return coordinator;
}

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (sPersistentStoreCoordinator == nil) {
        sPersistentStoreCoordinator = [AppDelegate persistentStoreCoordinator:APP_NAME];
    }
    return sPersistentStoreCoordinator;
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
+ (NSManagedObjectContext *) managedObjectContext:(NSPersistentStoreCoordinator *)inCoordinator {
    
    @synchronized( self ) {
        NSManagedObjectContext *context = nil;
        if (inCoordinator != nil) {
            context = [NSManagedObjectContext new];
            [context setPersistentStoreCoordinator:inCoordinator];
            [context setUndoManager:nil];
            [context autorelease];
        }
        return context;
    }
    
}

+ (NSManagedObjectContext *) managedObjectContext {
    @synchronized( self ) {
        if (sManagedObjectContext == nil) {
            sManagedObjectContext = [[AppDelegate managedObjectContext:[AppDelegate persistentStoreCoordinator]] retain ];
        }
        return sManagedObjectContext;
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // use our own URL Handler
    //[self swapOpenURLImplementation];
    
    // set the fbProvider, just for testing purposes
    self.fbProvider = [(ContactProvider*)[[FacebookContactsProvider alloc] init] autorelease];
    
    // set root controller as stack controller
    AppMenuViewController *masterController = [[AppMenuViewController alloc] init];
    self.stackController = [[AppStackController alloc] initWithRootViewController:masterController];
    
    self.window.rootViewController = self.stackController;
    [self.window makeKeyAndVisible];
    
    LocalContactsController * controller = [[[LocalContactsController alloc] initWithStyle:UITableViewStylePlain ] autorelease ];
    controller.delegate = self;
    controller.indexNumber = [ XAppDelegate.stackController.viewControllers count ];
    [ XAppDelegate.stackController pushViewController:controller fromViewController:nil animated:YES];
    
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

- ( BOOL )handleProviderURL:( NSURL * )url {
	ConnectionController *controller = [[[ConnectionController alloc] initWithNibName:nil bundle:nil] autorelease];
	controller.delegate = self;
	controller.url = url;
	UINavigationController *navController = [[[UINavigationController alloc]
											  initWithRootViewController:controller] autorelease];
	navController.modalPresentationStyle = UIModalPresentationFormSheet;
    if (self.stackController.modalViewController) 
        [self.stackController.modalViewController presentModalViewController:navController animated:YES];
    else
        [self.stackController presentModalViewController:navController animated:YES];
    return TRUE;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([ [ url host ] hasSuffix:@"linkedIn" ]) {
        return [[[[LinkedInContactsProvider alloc] init] autorelease] openURL:url];
    } else if ([ [ url host ] hasSuffix:@"twitter" ]) {
        return [[[[TwitterContactsProvider alloc] init] autorelease] openURL:url];
    } else if ([ [ url absoluteString ] hasPrefix:@"fb" ]) {
        return [[[[FacebookContactsProvider alloc] init] autorelease] openURL:url];
    } else {
        return NO;
    }
}

@end
