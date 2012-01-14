#import "LinkedInContact.h"
#import "LinkedInConstants.h"

@implementation LinkedInContact

-( id )initWithId:( NSString * )inId
           attributes:( NSDictionary * )inAttributes {
    return [ super initWithId:inId
                   attributes:inAttributes
                      mapping:[ LinkedInConstants getMapping ] ];
}

@end
