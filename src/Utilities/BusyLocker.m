#import "BusyLocker.h"

@implementation BusyLocker

-( void )dealloc {
    [ mLock release ];
    [ super dealloc ];
}

-( id )init {
    self = [ super init ];
    if ( self != nil ) {
        mLock = [ [ NSCondition alloc ] init ];
    }
    return self;
}

-( void )setBusy:( BOOL )inBusy {
    if ( inBusy ) {
        [ mLock lock ];
        mIsBusy = TRUE;
    } else {
        mIsBusy = FALSE;
        [ mLock signal ];
    }
}

-( void )waitWhileBusy {
    while ( mIsBusy ) {
        [ mLock waitUntilDate:[ NSDate dateWithTimeIntervalSinceNow:1 ] ];
    }
    [ mLock unlock ];
}

@end
