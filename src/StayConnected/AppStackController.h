//
//  AppViewController.h
//  2go2
//
//  Created by Dirk Grobler on 12/21/11.
//  Copyright (c) 2011 Sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAD/iAD.h>
#import "PSStackedViewController.h"

@interface AppStackController : PSStackedViewController <ADBannerViewDelegate> {
@private
    BOOL                        mBannerViewIsVisible;
    ADBannerView*               mBannerView;
}

@end
