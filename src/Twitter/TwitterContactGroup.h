#import <Foundation/Foundation.h>

#import "ContactGroupBaseImpl.h"

@interface TwitterContactGroup : ContactGroupBaseImpl

-( id )initWithId:( NSString * )inId attributes:( NSDictionary * )inAttributes;

@end