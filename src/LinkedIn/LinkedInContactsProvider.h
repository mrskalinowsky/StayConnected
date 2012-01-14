#import <Foundation/Foundation.h>

#import "ContactsProvider.h"

@class LinkedIn;

@interface LinkedInContactsProvider : NSObject< ContactsProvider >

-( void )requestComplete:( id )inRequestObject;

@end
