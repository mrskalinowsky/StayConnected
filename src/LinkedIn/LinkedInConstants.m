#import "LinkedInConstants.h"
#import "ContactAttributes.h"

const NSString * const sLinkedInProviderName            = @"LinkedIn";

const NSString * const sLinkedInAttributeId             = @"id";
const NSString * const sLinkedInAttributeLocation       = @"location";
const NSString * const sLinkedInAttributeLocationName   = @"name";
const NSString * const sLinkedInAttributeFormattedName  = @"formattedName";
const NSString * const sLinkedInAttributeFirstName      = @"firstName";
const NSString * const sLinkedInAttributeLastName       = @"lastName";
const NSString * const sLinkedInAttributePicture        = @"pictureUrl";
const NSString * const sLinkedInAttributeWebsite        = @"publicProfileUrl";

const NSString * const sKeyFormat = @"format";
const NSString * const sValueJSON = @"json";

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
    if ( sMapping == nil ) {
        sMapping = [ [ NSDictionary dictionaryWithObjectsAndKeys:
                      ( NSString * )CONTACT_ATTR_ID,          sLinkedInAttributeId,
                      ( NSString * )CONTACT_ATTR_LOCATION,    sLinkedInAttributeLocation,
                      ( NSString * )CONTACT_ATTR_NAME,        sLinkedInAttributeFormattedName,
                      ( NSString * )CONTACT_ATTR_PICTURE,     sLinkedInAttributePicture,
                      ( NSString * )CONTACT_ATTR_WEBSITE,     sLinkedInAttributeWebsite,
                      nil ] retain ];
    }
}

@end
