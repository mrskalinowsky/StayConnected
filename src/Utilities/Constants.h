#import <Foundation/Foundation.h>

extern NSString * const COMPANY_NAME;
extern NSString * const APP_NAME;
extern NSString * const PRODUCT_NAME;

extern NSString * const ACCOUNT_TYPE_LINKEDIN;
extern NSString * const ACCOUNT_TYPE_FACEBOOK;
extern NSString * const ACCOUNT_TYPE_TWITTER;

// Error Codes
enum {
    ErrUnknown = 1,
    ErrAllocInit,

    ErrFacebookLoginFailed,
    ErrFacebookLoginCanceled,
    
    ErrTwitterNoAccount,
    ErrTwitterSendMessageFailed,
    ErrTwitterCreateNewContactsFailed,
    
    ErrOauthFailed
};

// Table Cell Identifier 
extern NSString *const UI_KEY_TITLE;
extern NSString *const UI_KEY_FIRST_VALUE;
extern NSString *const UI_KEY_SECOND_VALUE;
extern NSString *const UI_KEY_THIRD_VALUE;
extern NSString *const UI_KEY_LAST_VALUE;


#define RGB(r, g, b) colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1
#define RGBA(r, g, b, a) colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a
#define HTML(rgbValue) \
    colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
    green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
    blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0

#define sectionColor            HTML(0x3371A3)


#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }
#define INVALIDATE_TIMER(__TIMER) { [__TIMER invalidate]; __TIMER = nil; }
