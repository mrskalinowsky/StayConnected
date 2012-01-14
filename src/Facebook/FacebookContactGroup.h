#import <Foundation/Foundation.h>

#import "ContactGroupBaseImpl.h"

@interface FacebookContactGroup : ContactGroupBaseImpl

-( id )initWithId:( NSString * )inId
           fields:( NSDictionary * )inFields
 fieldsAreColumns:( BOOL )inFieldsAreColumns;

@end