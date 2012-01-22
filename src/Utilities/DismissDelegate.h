//
//  DismissDelegate.h
//  2GO2
//
//  Created by D. Grobler on 12/29/10.
//  Copyright 2010 Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DismissDelegate <NSObject>

- (void) dismiss:(UIViewController*) controller;

@end
