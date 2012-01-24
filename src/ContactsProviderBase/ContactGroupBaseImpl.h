#import <Foundation/Foundation.h>

#import "ContactBaseImpl.h"
#import "ContactGroup.h"

@interface ContactGroupBaseImpl : ContactBaseImpl< ContactGroup > {
    @protected
    NSMutableDictionary * mContacts;
}

-( void )addContact:( id< Contact > )inContact;

@end
