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

@interface ConnectionController : UIViewController <UIWebViewDelegate, UIAlertViewDelegate> {
	id<DismissDelegate>             _delegate;
	ActivityLabel*                  _activityLabel;
	UIWebView*						_webView;
    UILabel*                        _errorView;
    UIButton*                       _loginButton;
	NSURL*							_url;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, assign) id<DismissDelegate> delegate;
@property (nonatomic, retain) NSURL*  url;

@end
