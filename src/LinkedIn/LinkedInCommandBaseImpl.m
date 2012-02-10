
#import "LinkedInCommandBaseImpl.h"

@implementation LinkedInCommandBaseImpl

-( void )dealloc {
    [ mRequestor release ];
    [ super dealloc ];
}

-( id )initWithRequestor:( OAuthRequestor * )inRequestor {
    self = [ super init ];
    if ( self != nil ) {
        mRequestor = [ inRequestor retain ];
    }
    return self;
}

@end
