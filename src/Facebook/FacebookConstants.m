#import "FacebookConstants.h"
#import "ContactAttributes.h"

const NSString * const sFacebookProviderName         = @"Facebook";
const NSString * const sFacebookAppId                = @"100188760104407";
const NSString * const sFacebookKeyFBAccess          = @"FBAccessTokenKey";
const NSString * const sFacebookKeyFBExpirationDate  = @"FBExpirationDateKey";

const NSString * const sFacebookPermissionReadStream = @"read_stream";
const NSString * const sFacebookPermissionBirthday   = @"friends_birthday";
const NSString * const sFacebookPermissionGroups     = @"user_groups";
const NSString * const sFacebookPermissionsHometown  = @"friends_hometown";
const NSString * const sFacebookPermissionWebsite    = @"friends_website";
const NSString * const sFacebookPermissionWork       = @"friends_work_history";

const NSString * const sFacebookFieldBirthday   = @"birthday";
const NSString * const sFacebookFieldEmail      = @"email";
const NSString * const sFacebookFieldId         = @"id";
const NSString * const sFacebookFieldFirstName  = @"first_name";
const NSString * const sFacebookFieldLastName   = @"last_name";
const NSString * const sFacebookFieldLocation   = @"hometown";
const NSString * const sFacebookFieldMiddleName = @"middle_name";
const NSString * const sFacebookFieldName       = @"name";
const NSString * const sFacebookFieldPicture    = @"picture";
const NSString * const sFacebookFieldWebsite    = @"website";
const NSString * const sFacebookFieldWork       = @"work";

const NSString * const sFacebookColumnBirthday   = @"birthday";
const NSString * const sFacebookColumnEmail      = @"email";
const NSString * const sFacebookColumnGid        = @"gid";
const NSString * const sFacebookColumnId         = @"uid";
const NSString * const sFacebookColumnFirstName  = @"first_name";
const NSString * const sFacebookColumnLastName   = @"last_name";
const NSString * const sFacebookColumnLocation   = @"hometown_location";
const NSString * const sFacebookColumnMiddleName = @"middle_name";
const NSString * const sFacebookColumnName       = @"name";
const NSString * const sFacebookColumnPicture    = @"pic_small";
const NSString * const sFacebookColumnWebsite    = @"website";
const NSString * const sFacebookColumnWork       = @"work";


static const NSDictionary * sAttributesToFields = nil;
static const NSDictionary * sAttributesToColumns = nil;

@interface FacebookConstants ( PrivateMethods )

+( void )initMapping;

@end

@implementation FacebookConstants

+( NSString * )attributeToColumn:( NSString * )inAttribute {
    [ self initMapping ];
    return [ sAttributesToColumns valueForKey:inAttribute ];
}

+( NSString * )attributesToColumns:( NSArray * )inAttributes {
    [ self initMapping ];
    NSMutableString * theFacebookColumns = [ [ NSMutableString alloc ] init ];
    [ theFacebookColumns appendFormat:@"%@", sFacebookColumnId ];
    for ( NSString * theAttribute in inAttributes ) {
        NSString * theColumn = [ sAttributesToColumns valueForKey:theAttribute ];
        if ( theColumn != nil ) {
            [ theFacebookColumns appendFormat:@",%@", theColumn ];
        }
    }
    return [ theFacebookColumns autorelease ];
}

+( NSString * )attributeToField:( NSString * )inAttribute {
    [ self initMapping ];
    return [ sAttributesToFields valueForKey:inAttribute ];
}

+( NSString * )attributesToFields:( NSArray * )inAttributes {
    [ self initMapping ];
    NSMutableString * theFacebookFields = [ [ NSMutableString alloc ] init ];
    [ theFacebookFields appendFormat:@"%@", sFacebookFieldId ];
    for ( NSString * theAttribute in inAttributes ) {
        NSString * theField = [ sAttributesToFields valueForKey:theAttribute ];
        if ( theField != nil ) {
            [ theFacebookFields appendFormat:@",%@", theField ];
        }
    }
    return [ theFacebookFields autorelease ];
}

+( NSDictionary * )getAttributesToColumns {
    [ self initMapping ];
    return ( NSDictionary * )sAttributesToColumns;
}

+( NSDictionary * )getAttributesToFields {
    [ self initMapping ];
    return ( NSDictionary * )sAttributesToFields;
}

@end

@implementation FacebookConstants ( PrivateMethods )

+( void )initMapping {
    if ( sAttributesToFields == nil ) {
        sAttributesToFields = [ [ NSDictionary dictionaryWithObjectsAndKeys:
                    ( NSString * )CONTACT_ATTR_BIRTHDAY,    sFacebookFieldBirthday,
                    ( NSString * )CONTACT_ATTR_EMAIL,       sFacebookFieldEmail,
                    ( NSString * )CONTACT_ATTR_ID,          sFacebookFieldId,
                    ( NSString * )CONTACT_ATTR_FIRST_NAME,  sFacebookFieldFirstName,
                    ( NSString * )CONTACT_ATTR_LAST_NAME,   sFacebookFieldLastName,
                    ( NSString * )CONTACT_ATTR_LOCATION,    sFacebookFieldLocation,
                    ( NSString * )CONTACT_ATTR_MIDDLE_NAME, sFacebookFieldMiddleName,
                    ( NSString * )CONTACT_ATTR_NAME,        sFacebookFieldName,
                    ( NSString * )CONTACT_ATTR_PICTURE,     sFacebookFieldPicture,
                    ( NSString * )CONTACT_ATTR_WEBSITE,     sFacebookFieldWebsite,
                    ( NSString * )CONTACT_ATTR_WORK,        sFacebookFieldWork,
                                 nil ] retain ];
        sAttributesToColumns = [ [ NSDictionary dictionaryWithObjectsAndKeys:
                    ( NSString * )CONTACT_ATTR_BIRTHDAY,    sFacebookColumnBirthday,
                    ( NSString * )CONTACT_ATTR_EMAIL,       sFacebookColumnEmail,
                    ( NSString * )CONTACT_ATTR_ID,          sFacebookColumnId,
                    ( NSString * )CONTACT_ATTR_FIRST_NAME,  sFacebookColumnFirstName,
                    ( NSString * )CONTACT_ATTR_LAST_NAME,   sFacebookColumnLastName,
                    ( NSString * )CONTACT_ATTR_LOCATION,    sFacebookColumnLocation,
                    ( NSString * )CONTACT_ATTR_MIDDLE_NAME, sFacebookColumnMiddleName,
                    ( NSString * )CONTACT_ATTR_NAME,        sFacebookColumnName,
                    ( NSString * )CONTACT_ATTR_PICTURE,     sFacebookColumnPicture,
                    ( NSString * )CONTACT_ATTR_WEBSITE,     sFacebookColumnWebsite,
                    ( NSString * )CONTACT_ATTR_WORK,        sFacebookColumnWork,
                                 nil ] retain ];
    }
}

@end