#import "ContactBaseImpl.h"
#import "ContactGroup.h"

@implementation ContactBaseImpl

-( void )addGroup:( id< ContactGroup > )inGroup {
    [ mGroups setValue:inGroup forKey:[ inGroup getId ] ];
}

-( void )dealloc {
    [ mGroups release ];
    [ mMapping release ];
    [ mAttributes release ];
    [ mId release ];
    [ super dealloc ];
}

-( NSString * )getAttributeValue:( NSString * )inAttributeName {
    NSString * theAttributeValue = nil;
    NSString * theAttributeName = [ mMapping valueForKey:inAttributeName ];
    if ( theAttributeName != nil ) {
        theAttributeValue = [ mAttributes valueForKey:theAttributeName ]; 
    }
    return theAttributeValue;
}

-( NSArray * )getGroups {
    return [ mGroups allValues ];
}

-( NSString * )getId {
    return mId;
}

-( id )initWithId:( NSString * )inId
       attributes:( NSDictionary * )inAttributes
          mapping:( NSDictionary * )inMapping {
    self = [ super init ];
    if ( self != nil ) {
        mId = [ inId retain ];
        mAttributes = [ inAttributes retain ];
        mMapping = [ inMapping retain ];
        mGroups = [ [ NSMutableDictionary alloc ] init ];
    }
    return self;
}

@end