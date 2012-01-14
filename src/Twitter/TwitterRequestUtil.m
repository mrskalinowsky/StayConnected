#import "TwitterContactsProvider.h"
#import "TwitterRequestUtil.h"

@implementation TwitterRequestUtil

-( void )dealloc {
    [ mLock release ];
    [ mProvider release ];
    [ super dealloc ];
}

-( id )initWithProvider:( TwitterContactsProvider * )inProvider {
    self = [ super init ];
    if ( self != nil ) {
        mProvider = [ inProvider retain ];
        mLock = [ [ NSCondition alloc ] init ];
        mIsBusy = FALSE;
    }
    return self;
}

-( void )requestComplete {
    [ mProvider requestComplete:self ];
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
