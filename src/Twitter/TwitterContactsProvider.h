#import <Foundation/Foundation.h>

#import "ContactsProvider.h"

@interface TwitterContactsProvider : NSObject < ContactsProvider >

-( void )requestComplete:( id )inRequestObject;

@end
