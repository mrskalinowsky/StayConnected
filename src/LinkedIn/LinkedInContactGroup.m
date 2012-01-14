#import "LinkedInConstants.h"
#import "LinkedInContactGroup.h"

@implementation LinkedInContactGroup

-( id )initWithId:( NSString * )inId
       attributes:( NSDictionary * )inAttributes {
    return [ super initWithId:inId
                   attributes:inAttributes
                      mapping:[ LinkedInConstants getMapping ] ];
}

@end
