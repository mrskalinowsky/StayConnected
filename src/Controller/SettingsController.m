//
//  SettingsController.m
//  StayConnected
//
//  Created by Christian Smith on 13/02/2012.
//  Copyright (c) 2012 Oracle. All rights reserved.
//

#import "SettingsController.h"
#import "DismissDelegate.h"
#import "Constants.h"
#import "ContactsProviderBaseImpl.h"
#import "FacebookContactsProvider.h"
#import "TwitterContactsProvider.h"
#import "LinkedInContactsProvider.h"
#import "ContactAttributes.h"

@implementation SettingsController

@synthesize delegate = _delegate;
@synthesize indexNumber, indexNumberLabel;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = NSLocalizedString(@"accnt_settings", @"accnt_settings");
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    _menuList = [ [ NSArray arrayWithObjects:
                   [NSDictionary dictionaryWithObjectsAndKeys:
				   NSLocalizedString(@"facebook", @"facebook"), UI_KEY_TITLE,
				   NSLocalizedString(@"facebook", @"facebook"), UI_KEY_FIRST_VALUE,
				   nil ],
                   [NSDictionary dictionaryWithObjectsAndKeys:
                           NSLocalizedString(@"linkedin", @"linkedin"), UI_KEY_TITLE,
                           NSLocalizedString(@"linkedin", @"linkedin"), UI_KEY_FIRST_VALUE, 
                    nil], 
                   [NSDictionary dictionaryWithObjectsAndKeys:
                    NSLocalizedString(@"twitter", @"twitter"), UI_KEY_TITLE,
                    NSLocalizedString(@"twitter", @"twitter"), UI_KEY_FIRST_VALUE, 
                    nil], 
                   nil] retain];
	
//	// only when used standalone
//	if (_delegate) {
//		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
//                                                  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
//                                                  target:self
//                                                  action:@selector(dismiss:)] autorelease];
//        
//        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
//												   initWithBarButtonSystemItem:UIBarButtonSystemItemSave
//												   target:self
//												   action:@selector(save:)] autorelease];
//	}
    
	self.editing = NO;
	self.tableView.allowsSelectionDuringEditing = YES;
	self.contentSizeForViewInPopover = CGSizeMake(320.0,460.0);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ _menuList count ];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    switch (indexPath.row) {
        case 0: {
            cell.textLabel.text = NSLocalizedString(@"Facebook", @"Facebook");
            break;
        }
        case 1: {
            cell.textLabel.text = NSLocalizedString(@"LinkedIn", @"LinkedIn");
            break;
        }
        case 2: {
            cell.textLabel.text = NSLocalizedString(@"Twitter", @"Twitter");
            break;
        }
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ContactsProviderBaseImpl * theProvider = nil;
    
    NSArray * theAttrs =
    [ NSArray arrayWithObjects:CONTACT_ATTR_BIRTHDAY, CONTACT_ATTR_EMAIL,
     CONTACT_ATTR_FIRST_NAME, CONTACT_ATTR_LAST_NAME,
     CONTACT_ATTR_LOCATION, CONTACT_ATTR_MIDDLE_NAME, CONTACT_ATTR_NAME,
     CONTACT_ATTR_PICTURE, CONTACT_ATTR_WEBSITE, CONTACT_ATTR_WORK,
     nil ];
    
    switch (indexPath.row) {
        case 0: {
            //theProvider =  [ [ [ FacebookContactsProvider alloc ] init ] autorelease ];
            break;
        }
        case 1: {
            theProvider =  [ [ [ LinkedInContactsProvider alloc ] init ] autorelease ];
            break;
        }
        case 2: {
            theProvider =  [ [ [ TwitterContactsProvider alloc ] init ] autorelease ];
            break;
        }
    }

    if (theProvider) {
        [ theProvider getContacts:nil attributes:theAttrs callback:self ];
    }
    
}

#pragma mark -
#pragma mark ContactsCallback
-( void )onContactsFound:(NSArray *)inContacts error:(NSError *)inError {
    NSLog(@"onContactsFound");
    if (inError != nil) {
        NSLog(@"Error authenticating... %@", inError);
        // Show UIAlert
        [ _delegate dismiss:self ];
    } else {
        // Save provider to DB
        [ _delegate dismiss:self ];
        
    }
}

@end
