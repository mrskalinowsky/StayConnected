#import "TwitterConstants.h"
#import "TwitterContactGroup.h"

@implementation TwitterContactGroup

-( id )initWithId:( NSString * )inId attributes:( NSDictionary * )inAttributes {
    return [ super initWithId:inId
                   attributes:inAttributes
                      mapping:[ TwitterConstants getMapping ] ];
}

@end
