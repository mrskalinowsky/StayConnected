//
//  SettingsController.h
//  StayConnected
//
//  Created by Christian Smith on 13/02/2012.
//  Copyright (c) 2012 Oracle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DismissDelegate.h"
#import "PSStackedViewDelegate.h"
#import "ContactsProvider.h"

@interface SettingsController : UITableViewController <PSStackedViewDelegate, ContactsCallback> {
    
	NSArray					*_menuList;
    id<DismissDelegate>		_delegate;
}

@property (nonatomic, assign) id<DismissDelegate> delegate;
@property (nonatomic, strong) IBOutlet UILabel * indexNumberLabel;
@property (nonatomic, assign) NSUInteger indexNumber;

@end