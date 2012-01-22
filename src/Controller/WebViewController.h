//
//  FacebookViewController.h
//  Project360
//
//  Created by D. Grobler on 11/11/10.
//  Copyright 2010 Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActivityLabel;
@protocol DismissDelegate;

@interface WebViewController : UIViewController <UIWebViewDelegate> {
	id<DismissDelegate>             _delegate;
	ActivityLabel*                  _activityLabel;
    UISegmentedControl*				_navControl;
	UIWebView*						_webView;
	NSURL*							_url;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, assign) id<DismissDelegate> delegate;
@property (nonatomic, retain) NSURL*						  url;
@property (nonatomic, assign) BOOL                           isConnecting;

- (IBAction) backAction:(id)sender forEvent:(UIEvent *)event;
- (IBAction) forwardAction:(id)sender forEvent:(UIEvent *)event;

@end
