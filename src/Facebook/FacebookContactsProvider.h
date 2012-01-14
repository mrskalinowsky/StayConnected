#import <Foundation/Foundation.h>

#import "ContactsProvider.h"

@class Facebook;

@interface FacebookContactsProvider : NSObject< ContactsProvider > {
    @private
    Facebook * mFacebook;
}

-( void )requestComplete:( id )inRequestObject;

@end