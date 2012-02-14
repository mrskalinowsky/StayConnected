//
//  ProviderContacts.h
//  StayConnected
//
//  Created by Christian Smith on 14/02/2012.
//  Copyright (c) 2012 Oracle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DismissDelegate.h"
#import "ContactsProviderBaseImpl.h"

@class ContactGroupBaseImpl;

@interface ProviderContactsController : UITableViewController <ContactsCallback> {
    
    NSArray                     * _contactList;
    id<DismissDelegate>         _delegate;
    ContactsProviderBaseImpl    * mProvider;
}

- (id)initWithStyle:(UITableViewStyle)style provider:(ContactsProviderBaseImpl * )inProvider;

@property (nonatomic, assign) id<DismissDelegate> delegate;
@property (nonatomic, assign) NSArray * contactList;
@property (nonatomic, strong) IBOutlet UILabel * indexNumberLabel;
@property (nonatomic, assign) NSUInteger indexNumber;

@end
