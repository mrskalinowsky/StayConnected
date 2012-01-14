#import "TwitterConstants.h"
#import "TwitterContact.h"

@implementation TwitterContact

-( id )initWithId:( NSString * )inId attributes:( NSDictionary * )inAttributes {
    return [ super initWithId:inId
                   attributes:inAttributes
                      mapping:[ TwitterConstants getMapping ] ];
}

@end