#import <Foundation/Foundation.h>

@interface BusyLocker : NSObject {
    @protected
    NSCondition * mLock;
    BOOL          mIsBusy;
}

-( void )setBusy:( BOOL )inIsBusy;

-( void )waitWhileBusy;

@end
