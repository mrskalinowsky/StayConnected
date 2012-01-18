#import <Foundation/Foundation.h>

#import "ContactsProvider.h"

@class OAuthRequestor;

@interface TwitterContactsProvider : NSObject < ContactsProvider > {
    @private
    OAuthRequestor * mOAuthRequestor;
    
}

-( OAuthRequestor * )getOAuthRequestor;
-( void )requestComplete:( id )inRequestObject;

@end
