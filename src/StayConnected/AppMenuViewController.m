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
#import "SettingsController.h"
#import "ProviderContactsController.h"
#import "LocalContactsController.h"

typedef enum {
    SectionMenuContacts = 0,
	SectionMenuAccounts = 1,
	SectionMenuSettings = 2,
} SectionMenu;

@interface AppMenuViewController (PrivateMethods)

- (void) allContactsClicked:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (void) addProviderClicked:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end

@interface AppMenuViewController ()

@property (nonatomic, retain) IBOutlet UIPopoverController*	popoverController;

@end

@implementation AppMenuViewController

@synthesize popoverController = mPopoverController;
@synthesize menuView = mMenuTable;

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
}

- (void)viewDidUnload {
    
    [mCurrentViewController release];
    mCurrentViewController = nil;
    [mAllContactsViewController release];
    self.popoverController = nil;
            
    [mMenuTable release];
    mMenuTable = nil;
    
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
            return 6; 
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
                case 1:
                    cell.textLabel.text = [NSString stringWithFormat:@"┖► %@", NSLocalizedString(@"Facebook", @"Facebook")];
                    cell.imageView.image = [UIImage imageNamed:@"symb-fb"];
                    break;
                case 2:
                    cell.textLabel.text = [NSString stringWithFormat:@"┖► %@", NSLocalizedString(@"Twitter", @"Twitter")];
                    cell.imageView.image = [UIImage imageNamed:@"symb-star"];
                    break;
                case 3:
                    cell.textLabel.text = [NSString stringWithFormat:@"┖► %@", NSLocalizedString(@"Google", @"Google")];
                    cell.imageView.image = [UIImage imageNamed:@"symb-star"];
                    break;
                case 4:
                    cell.textLabel.text = [NSString stringWithFormat:@"┖► %@", NSLocalizedString(@"LinkedIn", @"LinkedIn")];
                    cell.imageView.image = [UIImage imageNamed:@"symb-flag"];
                    break;
                default:
                    cell.textLabel.text = NSLocalizedString(@"Xing", @"Xing");
                    cell.imageView.image = [UIImage imageNamed:@"symb-trash"];
                    break;
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
    
    PSStackedViewController * stackController = XAppDelegate.stackController;
    
    switch (indexPath.section) {
        case SectionMenuContacts: {
            switch (indexPath.row) {
                case 0: {
                    //[ self allContactsClicked:<#(UITableView *)#> indexPath:<#(NSIndexPath *)#> ];
                    UIViewController * topController = stackController.topViewController;
                    if (![topController isKindOfClass:[LocalContactsController class]]) {
                        NSLog(@"no LocalContactsController");
                        ((LocalContactsController * ) mAllContactsViewController).indexNumber = [ stackController.viewControllers count ];
                        [ stackController pushViewController:mAllContactsViewController fromViewController:stackController.rootViewController animated:NO];
                    } else {
                        NSLog(@"is LocalContactsController");
                    }
                    break;
                }
            }
            break;
        }
        case SectionMenuAccounts: {
            switch (indexPath.row) {
                case 0: {
                    SettingsController * viewController = 
                    [ [ [ SettingsController alloc ] initWithStyle:UITableViewStyleGrouped ] retain ];
                    viewController.indexNumber = [ stackController.viewControllers count ];
                    viewController.delegate = self;
                    [ stackController pushViewController:viewController fromViewController:nil animated:YES ];
                    break;
                }
                case 1: {
                    [XAppDelegate.fbProvider getContacts:nil attributes:nil callback:nil];
                }   break;
                case 4: {
                    LinkedInContactsProvider * linkedInProvider = [ [ LinkedInContactsProvider alloc ] init ];
                    ProviderContactsController * controller = [[[ProviderContactsController alloc] initWithStyle:UITableViewStylePlain provider:linkedInProvider ] autorelease ];
                    controller.delegate = self;
                    controller.indexNumber = [ stackController.viewControllers count ];
                    [ stackController pushViewController:controller fromViewController:nil animated:YES];
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
    
}

- (void) addProviderClicked:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    
}

@end
