//
//  MasterController.h
//  2go2
//
//  Created by Dirk Grobler on 12/19/11.
//  Copyright (c) 2011 Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate> {
@private
    UITableView*                mMenuTable;
    UIViewController*           mCurrentViewController;
    CGPoint                     mLastTapLocation; 
}

@property (nonatomic, assign, readonly) UITableView* menuView;

@end
