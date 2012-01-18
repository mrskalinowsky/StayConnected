#import <Foundation/Foundation.h>

extern NSString * const COMPANY_NAME;
extern NSString * const APP_NAME;
extern NSString * const PRODUCT_NAME;

// Error Codes
enum {
    ErrUnknown = 1,
    ErrAllocInit,

    ErrFacebookLoginFailed,
    ErrFacebookLoginCanceled,
    
    ErrTwitterNoAccount,
    
    ErrOauthFailed
};
