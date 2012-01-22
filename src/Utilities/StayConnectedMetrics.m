//
//  StayConnectedMetrics.m
//  StayConnected
//
//  Created by Dirk Grobler on 1/22/12.
//  Copyright (c) 2012 Sun. All rights reserved.
//

#import "StayConnectedMetrics.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
CGRect SCScreenBounds() {
    CGRect bounds = [UIScreen mainScreen].bounds;
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        CGFloat width = bounds.size.width;
        bounds.size.width = bounds.size.height;
        bounds.size.height = width;
    }
    return bounds;
}
