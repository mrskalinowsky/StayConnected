#import <Foundation/Foundation.h>

@class TwitterContactsProvider;

@interface TwitterRequestUtil : NSObject {
    @protected
    TwitterContactsProvider * mProvider;
    
    @private
    NSCondition * mLock;
    BOOL mIsBusy;
}

-( id )initWithProvider:( TwitterContactsProvider * )inProvider;
-( void )requestComplete;
-( void )setBusy:( BOOL )inBusy;
-( void )waitWhileBusy;

@end
