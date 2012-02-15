//
//  MasterController.h
//  2go2
//
//  Created by Dirk Grobler on 12/19/11.
//  Copyright (c) 2011 Sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DismissDelegate.h"
#import "LinkedInContactsProvider.h"

@interface AppMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, DismissDelegate, ContactsCallback> {
@private
    UITableView *               mMenuTable;
    UIViewController *          mCurrentViewController;
    UIViewController *          mAllContactsViewController;
    CGPoint                     mLastTapLocation;
}

@property (nonatomic, assign, readonly) UITableView* menuView;

@end
