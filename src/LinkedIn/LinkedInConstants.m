#import "LinkedInConstants.h"
#import "ContactAttributes.h"

const NSString * const sLinkedInProviderName        = @"LinkedIn";

static const NSDictionary * sMapping = nil;

@interface LinkedInConstants ( PrivateMethods )

+( void )initMapping;

@end

@implementation LinkedInConstants

+( NSDictionary * )getMapping {
    [ self initMapping ];
    return ( NSDictionary * )sMapping;
}

@end

@implementation LinkedInConstants ( PrivateMethods )

+( void )initMapping {
    sMapping = [ [ NSDictionary alloc ] init ];
}

@end
