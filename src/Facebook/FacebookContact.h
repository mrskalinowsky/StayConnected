#import <Foundation/Foundation.h>

#import "ContactBaseImpl.h"

@interface FacebookContact : ContactBaseImpl

-( id )initWithId:( NSString * )inId
           fields:( NSDictionary * )inFields
 fieldsAreColumns:( BOOL )inFieldsAreColumns;

@end
