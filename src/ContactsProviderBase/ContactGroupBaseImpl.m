#import "ContactGroupBaseImpl.h"

@implementation ContactGroupBaseImpl

-( void )addContact:( id< Contact > )inContact {
    [ mContacts setValue:inContact forKey:[ inContact getId ] ];
}

-( void )dealloc {
    [ mContacts release ];
    [ super dealloc ];
}

-( NSArray * )getContacts {
    return [ mContacts allValues ];
}

-( id )initWithId:( NSString * )inId
       attributes:( NSDictionary * )inAttributes
          mapping:( NSDictionary * )inMapping {
    self = [ super initWithId:inId attributes:inAttributes mapping:inMapping ];
    if ( self != nil ) {
        mContacts = [ [ NSMutableDictionary alloc ] init ];
    }
    return self;
}

@end
