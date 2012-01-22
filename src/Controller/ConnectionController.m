    //
//  FacebookViewController.m
//  Project360
//
//  Created by D. Grobler on 11/11/10.
//  Copyright 2010 Sun. All rights reserved.
//

#import "ConnectionController.h"
#import "DismissDelegate.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "ActivityLabel.h"

@implementation ConnectionController

@synthesize delegate = _delegate;
@synthesize url = _url;
@synthesize webView = _webView;

- (void) applicationWillResign {
    [_delegate dismiss:self];
}

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
    if ((self = [super initWithNibName:nibName bundle:nibBundle])) {
        _webView = [[UIWebView alloc] init];
    }
    return self;
}

#pragma mark -
#pragma mark Load activity 

- (void) showActivityView {
	        
    _activityLabel = [[ActivityLabel alloc] initWithStyle:ActivityLabelStyleGray];        
    _activityLabel.text = NSLocalizedString(@"Connecting ...", @"Connecting ...");
    _activityLabel.alpha = 0.7;
    _activityLabel.frame = CGRectMake(0, 0, 200, 60);
    
    [self.view.superview insertSubview:_activityLabel aboveSubview:_webView];
    _activityLabel.center = CGPointMake(_webView.frame.size.width/2, _webView.frame.size.height/2);            
}

- (void) hideActivityView {
    [_activityLabel removeFromSuperview];
    [_activityLabel release];
    _activityLabel = nil;    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = _webView;
	_webView.scalesPageToFit = YES;
    _webView.delegate = self;
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationWillResign)
												 name:@"UIApplicationWillResignActiveNotification"
											   object:nil]; 
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                               target:self
                                               action:@selector(dismissView:)] autorelease];
    
    self.navigationItem.title = NSLocalizedString(@"Connection problem", @"Connection problem");
    self.navigationController.navigationBarHidden = YES;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:TRUE];    
    [_webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[self showActivityView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[self hideActivityView];	
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	
    NSLog(@"Facebook error %@, %@", error, [error userInfo]);

    [_activityLabel removeFromSuperview];
    [_activityLabel release];
    _activityLabel = nil;
    
    UIAlertView *alert = [[[UIAlertView alloc]
                           initWithTitle:NSLocalizedString(@"Login failed", @"Login failed")
                           message:NSLocalizedString(@"The connection to facebook can not be estabilished. Please try again later.", @"Connection failure")
                           delegate:self
                           cancelButtonTitle:nil
                           otherButtonTitles:NSLocalizedString(@"Ok",@"Ok"),nil] autorelease];
    
    [alert show];
}

// UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    // Call the delegate to dismiss the modal view
    _webView.delegate = nil;
    
	//[[AppDelegate appEnv] fbDidNotLogin:YES];
    [_delegate dismiss:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}     

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _webView.delegate = nil;	
}

- (void)dealloc {
	_webView.delegate = nil;	
	[_activityLabel release];
    [_errorView release];
	[_url release];
	[_webView release];
    [super dealloc];
}


@end
