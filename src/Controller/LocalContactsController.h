//
//  LocalContactsController.h
//  StayConnected
//
//  Created by Christian Smith on 14/02/2012.
//  Copyright (c) 2012 Oracle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DismissDelegate.h"

@interface LocalContactsController : UITableViewController {
    NSArray                     * _contactList;
    id<DismissDelegate>         _delegate;
}

@property (nonatomic, assign) id<DismissDelegate> delegate;
@property (nonatomic, assign) NSArray * contactList;
@property (nonatomic, strong) IBOutlet UILabel * indexNumberLabel;
@property (nonatomic, assign) NSUInteger indexNumber;

@end
