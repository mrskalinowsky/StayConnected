#import "TwitterConstants.h"
#import "ContactAttributes.h"

const NSString * const sTwitterProviderName        = @"Twitter";

const NSString * const sTwitterAttributeId         = @"id_str";
const NSString * const sTwitterAttributeLocation   = @"location";
const NSString * const sTwitterAttributeName       = @"name";
const NSString * const sTwitterAttributePicture    = @"profile_image_url";
const NSString * const sTwitterAttributeWebsite    = @"url";

static const NSDictionary * sMapping = nil;

@interface TwitterConstants ( PrivateMethods )

+( void )initMapping;

@end

@implementation TwitterConstants

+( NSDictionary * )getMapping {
    [ self initMapping ];
    return ( NSDictionary * )sMapping;
}

@end

@implementation TwitterConstants ( PrivateMethods )

+( void )initMapping {
    if ( sMapping == nil ) {
        sMapping = [ [ NSDictionary dictionaryWithObjectsAndKeys:
                      ( NSString * )CONTACT_ATTR_ID,          sTwitterAttributeId,
                      ( NSString * )CONTACT_ATTR_LOCATION,    sTwitterAttributeLocation,
                      ( NSString * )CONTACT_ATTR_NAME,        sTwitterAttributeName,
                      ( NSString * )CONTACT_ATTR_PICTURE,     sTwitterAttributePicture,
                      ( NSString * )CONTACT_ATTR_WEBSITE,     sTwitterAttributeWebsite,
                                 nil ] retain ];
    }
}

@end
