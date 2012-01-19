//
//  AppViewController.m
//  2go2
//
//  Created by Dirk Grobler on 12/21/11.
//  Copyright (c) 2011 Sun. All rights reserved.
//

#import "StayConnectedStackController.h"
#import "StayConnectedAppDelegate.h"
#import "PSStackedViewGlobal.h"
#import "UIViewController+PSStackedView.h"
#import "PSStackedViewController.h"
#import "PSStackedView.h"

@interface StayConnectedStackController()

@property (nonatomic, strong) ADBannerView*  bannerView;

@end


@implementation StayConnectedStackController
@synthesize bannerView = mBannerView;

#pragma mark - AD stuff
- (NSString*) getBannerIdentifier:(UIDeviceOrientation)orientation {
    static NSString *kTabnavADBannerContentSizeIdentifierPortrait = nil;
    static NSString *kTabnavADBannerContentSizeIdentifierLandscape = nil;
    
    if (kTabnavADBannerContentSizeIdentifierPortrait == nil) {
        
        Class cls = NSClassFromString(@"ADBannerView");    
        if (cls) {        
            if (&ADBannerContentSizeIdentifierPortrait != nil) {
                kTabnavADBannerContentSizeIdentifierPortrait = ADBannerContentSizeIdentifierPortrait;            
            } 
            else {            
                kTabnavADBannerContentSizeIdentifierPortrait =  ADBannerContentSizeIdentifier320x50;            
            }		
            
            if (&ADBannerContentSizeIdentifierLandscape != nil) {            
                kTabnavADBannerContentSizeIdentifierLandscape = ADBannerContentSizeIdentifierLandscape;            
            } 
            else {            
                kTabnavADBannerContentSizeIdentifierLandscape = ADBannerContentSizeIdentifier480x32;            
            }
        }
    }    
    return (UIInterfaceOrientationIsLandscape(orientation)) ? kTabnavADBannerContentSizeIdentifierLandscape :kTabnavADBannerContentSizeIdentifierPortrait;
}

- (CGSize) getBannerSize:(UIDeviceOrientation)orientation {    
    return [ADBannerView sizeFromBannerContentSizeIdentifier:[self getBannerIdentifier:orientation]];
}

- (CGSize) getBannerSize {
    return [self getBannerSize:[UIDevice currentDevice].orientation];
}

- (int) getControllerFrameHeight {
    CGRect frame = self.view.bounds;
    return mBannerViewIsVisible ? frame.size.height - self.getBannerSize.height : frame.size.height;
}

- (void) layoutView: (BOOL) animated {
    
    BOOL showBanner = mBannerViewIsVisible;
    CGRect frame = self.view.bounds;
    
    CGFloat animationDuration = animated ? 1.0f : 0.0f;
    int controllerheight = [self getControllerFrameHeight];        
    // And finally animate the changes, running layout for the content view if required.
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         self.bannerView.hidden = !showBanner;                                                           
                         self.bannerView.frame = CGRectMake(0, frame.size.height - self.getBannerSize.height, self.getBannerSize.width, self.getBannerSize.height); 
                         for (UIViewController* controller in self.viewControllers) {
                             controller.containerView.height = controllerheight;
                             controller.view.height = controllerheight;
                             [controller.view layoutSubviews];
                         }
                         self.rootViewController.view.height = controllerheight;
                     }];           
}

- (void)pushViewController:(UIViewController *)viewController fromViewController:(UIViewController *)baseViewController animated:(BOOL)animated; {    
    
    [super pushViewController:viewController fromViewController:baseViewController animated:animated];
    viewController.containerView.height = self.getControllerFrameHeight;
    [viewController.view layoutIfNeeded];
}


#pragma mark - ADBannerViewDelegate
- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    if (!mBannerViewIsVisible) {                
        mBannerViewIsVisible = YES;
        [self layoutView:YES];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    if (mBannerViewIsVisible) {        
        mBannerViewIsVisible = NO;
        [self layoutView:YES];
    }
}

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        
    if (!self.bannerView) {
        self.bannerView = [[[ADBannerView alloc] initWithFrame:CGRectZero] autorelease];
        [self.bannerView setRequiredContentSizeIdentifiers:[NSSet setWithObjects: 
                                                            [self getBannerIdentifier:UIDeviceOrientationPortrait ] , 
                                                            [self getBannerIdentifier:UIDeviceOrientationLandscapeLeft ] ,  nil]];
        self.bannerView.delegate = self;
        mBannerViewIsVisible = NO;
        self.bannerView.hidden = YES;
        
        [self.bannerView setCurrentContentSizeIdentifier:[self getBannerIdentifier:[UIDevice currentDevice].orientation]];        
        [self.view addSubview:self.bannerView];
        [self.view bringSubviewToFront:self.bannerView];
    }    
    [self layoutView:animated];
}

- (void)viewDidUnload {    
    if (self.bannerView) {
        self.bannerView.delegate = nil;
        [self.bannerView removeFromSuperview];
        self.bannerView = nil;
    }
    [super viewDidUnload];    
}

#pragma mark - Rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {    
    return YES;
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {        
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    if ([self.bannerView.currentContentSizeIdentifier compare:[self getBannerIdentifier:[UIDevice currentDevice].orientation]] != NSOrderedSame ) {
        [self.bannerView setCurrentContentSizeIdentifier:[self getBannerIdentifier:[UIDevice currentDevice].orientation]];        
        [self layoutView:YES];    
    }
}

@end
