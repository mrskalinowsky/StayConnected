    //
//  FacebookViewController.m
//  Project360
//
//  Created by D. Grobler on 11/11/10.
//  Copyright 2010 Sun. All rights reserved.
//

#import "WebViewController.h"
#import "DismissDelegate.h"
#import "Constants.h"
#import "ActivityLabel.h"

@implementation WebViewController

@synthesize delegate = _delegate;
@synthesize url = _url;
@synthesize webView = _webView;
@synthesize isConnecting = _isConnecting;

- (void) applicationWillResign {
    [_delegate dismiss:self];
}

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
    if ((self = [super initWithNibName:nibName bundle:nibBundle])) {
        _isConnecting = NO;
    }
    return self;
}

#pragma mark -
#pragma mark Load activity 

- (void) showActivityView {
	
    if (_activityLabel == nil) {
        
        _activityLabel = [[ActivityLabel alloc] initWithStyle:ActivityLabelStyleGray];        
        _activityLabel.text = NSLocalizedString(@"Loading ...", @"Loading ...");
        [_activityLabel sizeToFit];
    }
    _activityLabel.frame = CGRectMake(0, 0, 200, _activityLabel.frame.size.height);
    [self.view.superview insertSubview:_activityLabel aboveSubview:_webView];
    _activityLabel.center = CGPointMake(_webView.frame.size.width/2, _webView.frame.size.height/2);        
}

- (void) hideActivityView {
    [_activityLabel performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
}

- (IBAction) backAction:(id)sender forEvent:(UIEvent *)event {
	[_webView goBack];
}

- (IBAction) forwardAction:(id)sender forEvent:(UIEvent *)event {
	[_webView goForward];
}
	
- (IBAction) navigateAction:(id)sender forEvent:(UIEvent *)event {
	
	if (((UISegmentedControl*) sender).selectedSegmentIndex == 0) {
		[_webView goBack];
	}
	else {
		[_webView goForward];
	}
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Override the right button to show a Done button
    // which is used to dismiss the modal view
	if (_delegate) {		
		NSArray* items = [NSArray arrayWithObjects:[UIImage imageNamed:@"UIButtonBarArrowLeft.png"], 
						  [UIImage imageNamed:@"UIButtonBarArrowRight.png"], nil ];	
		
		_navControl = [[UISegmentedControl alloc] initWithItems:items];
		_navControl.momentary = YES;
		_navControl.segmentedControlStyle = UISegmentedControlStyleBar; 
		
		CGRect frame = _navControl.frame;
		frame.size.width = 100;
		_navControl.frame = frame;
		
		[_navControl setEnabled:NO forSegmentAtIndex:0];
		[_navControl setEnabled:NO forSegmentAtIndex:1];
		[_navControl addTarget:self action:@selector(navigateAction: forEvent:) forControlEvents:UIControlEventValueChanged];
		
		
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
												  initWithCustomView:_navControl] autorelease];
		
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
												   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
												   target:self
												   action:@selector(dismissView:)] autorelease];
		
	}
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

	_webView.scalesPageToFit = YES;
	[_webView loadRequest:[NSURLRequest requestWithURL:self.url]];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationWillResign)
												 name:@"UIApplicationWillResignActiveNotification"
											   object:nil]; 
}

- (void) viewWillAppear:(BOOL)animated {		
	[super viewWillAppear:animated];
    
	if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
	}
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // gets the view popped from the stack
    if (self.navigationController && ![self.navigationController.viewControllers containsObject:self]) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
	}
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    [self showActivityView];
    
    return YES;
}

/*- (void)webViewDidStartLoad:(UIWebView *)webView {
	[self showActivityView];
}*/

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[self hideActivityView];
	
	[_navControl setEnabled:webView.canGoBack forSegmentAtIndex:0];
	[_navControl setEnabled:webView.canGoForward forSegmentAtIndex:1];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[self hideActivityView];
	
	[_navControl setEnabled:webView.canGoBack forSegmentAtIndex:0];
	[_navControl setEnabled:webView.canGoForward forSegmentAtIndex:1];
    
    if (self.isConnecting) {
        _webView.delegate = nil;
        [((NSObject*)_delegate) performSelectorOnMainThread:@selector(dismiss:) withObject:self waitUntilDone:YES];
    }
}

// Done button clicked
- (void)dismissView:(id)sender {
	
    // Call the delegate to dismiss the modal view
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
}


- (void)dealloc {
	_webView.delegate = nil;
	
	[_activityLabel release];
	[_navControl release];
	[_url release];
	[_webView release];
    [super dealloc];
}


@end
