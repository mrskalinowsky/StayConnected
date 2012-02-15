//
//  MasterController.m
//  2go2
//
//  Created by Dirk Grobler on 12/19/11.
//  Copyright (c) 2011 Sun. All rights reserved.
//

#import "AppMenuViewController.h"
#import "MenuTableViewCell.h"
#include <QuartzCore/QuartzCore.h>
#import "PSStackedView.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "UIImage+OverlayColor.h"
#import "FacebookContactsProvider.h"
#import "ContactAttributes.h"
#import "LinkedInContactsProvider.h"
#import "TwitterContactsProvider.h"
#import "ContactsProviderBaseImpl.h"
#import "SettingsController.h"
#import "ProviderContactsController.h"
#import "LocalContactsController.h"
#import "DataStore.h"
#import "Account.h"

typedef enum {
    SectionMenuContacts = 0,
	SectionMenuAccounts = 1,
	SectionMenuSettings = 2,
} SectionMenu;

@interface AppMenuViewController (PrivateMethods)

- (void) allContactsClicked:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (void) addProviderClicked:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (void) accountClicked:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end

@interface AppMenuViewController ()

@property (nonatomic, retain) IBOutlet UIPopoverController*	popoverController;

@end

@implementation AppMenuViewController

@synthesize popoverController = mPopoverController;
@synthesize menuView = mMenuTable;

- (id) init {
    self = [ super init ];
    if ( self != nil ) {
        NSMutableArray * accounts = [[NSMutableArray alloc] 
                                     initWithArray:[ DataStore 
                                                    fetchAccounts:[ AppDelegate managedObjectContext ] ] ];
        mAccounts = [ accounts retain ];
    }
    return self;
}

#pragma - Badge Handling
- (NSUInteger) badgeNumber {
    return[UIApplication sharedApplication].applicationIconBadgeNumber;
}

- (void) setBadgeNumber:(NSUInteger)badgeNumber {    
    [UIApplication sharedApplication].applicationIconBadgeNumber = badgeNumber;
}


#pragma mark -
#pragma mark Popover Handling
- (UIPopoverController*) popoverForContent:(UIViewController*) controller {
    self.popoverController = [[[UIPopoverController alloc] initWithContentViewController:controller] autorelease];     
    return self.popoverController;
}

- (BOOL) hidePopover {
	
    if (self.popoverController && self.popoverController.popoverVisible) {
        [self.popoverController dismissPopoverAnimated:YES];
        self.popoverController = nil;
        return YES;
    }
    
    return NO;
}

- (void) layoutViews {    
    if (!PSIsIpad()) 
        return;    
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    // add table menu
	UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 200, self.view.height) style:UITableViewStylePlain];
    mMenuTable = [tableView retain];
   
    self.menuView.backgroundColor = [UIColor clearColor];
    self.menuView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.menuView.delegate = self;
    self.menuView.dataSource = self;
    self.menuView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.menuView];
    
    UISearchBar *searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.menuView.width, 0)] autorelease]; 
    searchBar.tintColor = [UIColor sectionColor];
    searchBar.placeholder = NSLocalizedString(@"Find contact", @"Find contact");
    // make the search bar transparent
    //[[searchBar.subviews objectAtIndex:0] removeFromSuperview];
    //    searchBar.delegate = self;
	[searchBar sizeToFit];      
    UIGestureRecognizer *recognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]autorelease];
    recognizer.delegate = self;
    recognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:recognizer];
    
	self.menuView.tableHeaderView = searchBar;      
    [self.menuView setContentOffset:CGPointMake(0, 0) animated: NO];        
    [self.menuView reloadData];
    
    mAllContactsViewController = [[[LocalContactsController alloc] initWithStyle:UITableViewStylePlain ] retain ];
    ((LocalContactsController * ) mAllContactsViewController).delegate = self;
    
    mAccounts = [[NSArray alloc] initWithArray:[ DataStore fetchAccounts:[ AppDelegate managedObjectContext ] ] ];
    NSLog(@"Loaded %d accounts", [mAccounts count]);
}

- (void)viewDidUnload {
    
    [mCurrentViewController release];
    mCurrentViewController = nil;
    [mAllContactsViewController release];
    self.popoverController = nil;
            
    [mMenuTable release];
    mMenuTable = nil;
    [mAccounts release];
    [super viewDidUnload];    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];    
    [self layoutViews];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return YES;
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self layoutViews];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    switch (section) {
        case SectionMenuContacts:
            return NSLocalizedString(@"Contacts",@"Contacts");
        case SectionMenuAccounts:
            return NSLocalizedString(@"Accounts",@"Settings");
        case SectionMenuSettings:
            return NSLocalizedString(@"Settings",@"Settings");
    }
    return @"";    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        default:
            return 20; 
    }
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case SectionMenuContacts:
            return 3; 
        case SectionMenuAccounts:
            return [mAccounts count] + 1;
        case SectionMenuSettings:
            return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ExampleMenuCell";
    
    MenuTableViewCell *cell = (MenuTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }    
    switch (indexPath.section) {
        case SectionMenuContacts:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"Contacts",@"Contacts");  
                    cell.imageView.image = [UIImage imageNamed:@"symb-dates"]; 
                    break;
                case 1:
                    cell.textLabel.text = NSLocalizedString(@"Connect ...",@"Connect");  
                    cell.imageView.image = [UIImage imageNamed:@"symb-dates"];                    
                    break;
                case 2:
                    cell.textLabel.text = NSLocalizedString(@"Synchronize ...", @"Synchronize ...");
                    cell.imageView.image = [UIImage imageNamed:@"symb-plus"];
                    break;
        }    break;
        case SectionMenuAccounts: {
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"Add ...", @"Add ...");
                    cell.imageView.image = [UIImage imageNamed:@"symb-all"];
                    break;
                default: {
                    Account * theAccount = (Account *) [mAccounts objectAtIndex:indexPath.row - 1];
                    cell.textLabel.text = theAccount.type;
                    cell.imageView.image = [UIImage imageNamed:@"symb-star"];
                    break;
                }
            }
        }   break;
        case SectionMenuSettings: 
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"Options", @"Options");
                    cell.imageView.image = [UIImage imageNamed:@"symb-tipps"];
                    break;
                case 1:
                    cell.textLabel.text = NSLocalizedString(@"Store",@"Store");
                    cell.imageView.image = [UIImage imageNamed:@"symb-skull"];
                    break;
            }   break;
    }    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView	*sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)] autorelease];
	sectionView.backgroundColor = [UIColor sectionColor];
	
	UILabel *sectionText = [[[UILabel alloc] initWithFrame:CGRectMake(5, 2, tableView.bounds.size.width, 16)] autorelease];
	sectionText.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    sectionText.backgroundColor = [UIColor clearColor];
	sectionText.textColor = [UIColor whiteColor];
	sectionText.text = [self tableView:tableView titleForHeaderInSection:section];
	[sectionView addSubview:sectionText];
	return sectionView;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {    
    
    switch (indexPath.section) {
        case SectionMenuContacts: {
            switch (indexPath.row) {
                case 0: {
                    [ self allContactsClicked:tableView indexPath:indexPath ];
                    break;
                }
            }
            break;
        }
        case SectionMenuAccounts: {
            switch (indexPath.row) {
                case 0: {
                    [ self addProviderClicked:tableView indexPath:indexPath ];
                    break;
                }
                default: {
                    [ self accountClicked:tableView indexPath:indexPath ];
                    break;
                }
            }
        }
    }
}

#pragma mark -
#pragma mark ContactsCallback
-( void )onContactsFound:(NSArray *)inContacts error:(NSError *)inError {
    NSLog(@"onContactsFound");
}

#pragma mark -
#pragma mark UI Actions 
- (void)handleTap:(UITapGestureRecognizer *)sender {     
    if (sender.state == UIGestureRecognizerStateEnded)     {
        mLastTapLocation = [sender locationInView:self.view];
    }
    NSLog(@"handleTap");
}

#pragma mark -
#pragma mark DismissDelegate
- (void) dismiss:(UIViewController *)controller {
	NSLog(@"Dismiss");
    [ XAppDelegate.stackController popToRootViewControllerAnimated:YES ]; 
}

@end

@implementation AppMenuViewController (PrivateMethods)

- (void) allContactsClicked:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    
    PSStackedViewController * stackController = XAppDelegate.stackController;
    UIViewController * topController = stackController.topViewController;
    
    if (![topController isKindOfClass:[LocalContactsController class]]) {
        ((LocalContactsController * ) mAllContactsViewController).indexNumber = [ stackController.viewControllers count ];
        [ stackController pushViewController:mAllContactsViewController fromViewController:stackController.rootViewController animated:NO];
    }
}

- (void) addProviderClicked:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    
    PSStackedViewController * stackController = XAppDelegate.stackController;
    UIViewController * topController = stackController.topViewController;
    
    if (![topController isKindOfClass:[SettingsController class]]) {
        SettingsController * viewController = 
        [ [ [ SettingsController alloc ] initWithStyle:UITableViewStyleGrouped ] retain ];
        viewController.indexNumber = [ stackController.viewControllers count ];
        viewController.delegate = self;
        [ stackController pushViewController:viewController fromViewController:nil animated:YES ];
    }
}

- (void) accountClicked:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    
    PSStackedViewController * stackController = XAppDelegate.stackController;
    
    ContactsProviderBaseImpl * theProvider = nil;
    Account * theAccount = (Account *) [mAccounts objectAtIndex:indexPath.row - 1];
    NSString * theType = theAccount.type;
    
    if ([ theType isEqualToString:ACCOUNT_TYPE_FACEBOOK ]) {
        //theProvider = XAppDelegate.fbProvider;
    } else if ([ theType isEqualToString:ACCOUNT_TYPE_LINKEDIN ]) {
        theProvider = [ [ LinkedInContactsProvider alloc ] init ];
    } else if ([ theType isEqualToString:ACCOUNT_TYPE_TWITTER ]) {
        theProvider = [ [ TwitterContactsProvider alloc ] init ];
    }
    
    if (theProvider) {
        ProviderContactsController * controller = [ [ [ProviderContactsController alloc] 
                                                     initWithStyle:UITableViewStylePlain 
                                                     provider:theProvider ] 
                                                   autorelease ];
        controller.delegate = self;
        controller.indexNumber = [ stackController.viewControllers count ];
        [ stackController pushViewController:controller fromViewController:nil animated:YES];
    }
}

@end
