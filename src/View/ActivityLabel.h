//
//  ActivityLabel.h
//  StayConnected
//
//  Created by Dirk Grobler on 1/22/12.
//  Copyright (c) 2012 Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    ActivityLabelStyleWhite,
    ActivityLabelStyleGray,
    ActivityLabelStyleBlackBox,
    ActivityLabelStyleBlackBezel,
    ActivityLabelStyleBlackBanner,
    ActivityLabelStyleWhiteBezel,
    ActivityLabelStyleWhiteBox
} ActivityLabelStyle;

@interface ActivityLabel : UIView {
    ActivityLabelStyle        _style;
    
    UIView*                   _bezelView;
    UIProgressView*           _progressView;
    UIActivityIndicatorView*  _activityIndicator;
    UILabel*                  _label;
    
    float                     _progress;
    BOOL                      _smoothesProgress;
    NSTimer*                  _smoothTimer;
}

@property (nonatomic, readonly) ActivityLabelStyle style;

@property (nonatomic, copy)     NSString* text;
@property (nonatomic, retain)   UIFont*   font;

@property (nonatomic)           float     progress;
@property (nonatomic)           BOOL      isAnimating;
@property (nonatomic)           BOOL      smoothesProgress;

- (id)initWithFrame:(CGRect)frame style:(ActivityLabelStyle)style;
- (id)initWithFrame:(CGRect)frame style:(ActivityLabelStyle)style text:(NSString*)text;
- (id)initWithStyle:(ActivityLabelStyle)style;

@end