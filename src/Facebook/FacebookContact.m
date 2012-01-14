#import "FacebookContact.h"
#import "FacebookConstants.h"

@implementation FacebookContact

-( id )initWithId:( NSString * )inId
           fields:( NSDictionary * )inFields
 fieldsAreColumns:( BOOL )inFieldsAreColumns {
    return [ super initWithId:inId
                   attributes:inFields
                      mapping:inFieldsAreColumns ?
            [ FacebookConstants getAttributesToColumns ] :
            [ FacebookConstants getAttributesToFields ] ];
}

@end
