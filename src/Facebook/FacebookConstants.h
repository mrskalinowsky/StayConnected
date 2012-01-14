#import <Foundation/Foundation.h>

extern const NSString * const sFacebookProviderName;
extern const NSString * const sFacebookAppId;
extern const NSString * const sFacebookKeyFBAccess;
extern const NSString * const sFacebookKeyFBExpirationDate;

extern const NSString * const sFacebookPermissionEmail;
extern const NSString * const sFacebookPermissionReadStream;
extern const NSString * const sFacebookPermissionBirthday;
extern const NSString * const sFacebookPermissionGroups;
extern const NSString * const sFacebookPermissionsHometown;
extern const NSString * const sFacebookPermissionWebsite;
extern const NSString * const sFacebookPermissionWork;

extern const NSString * const sFacebookFieldBirthday;
extern const NSString * const sFacebookFieldEmail;
extern const NSString * const sFacebookFieldId;
extern const NSString * const sFacebookFieldFirstName;
extern const NSString * const sFacebookFieldLastName;
extern const NSString * const sFacebookFieldLocation;
extern const NSString * const sFacebookFieldMiddleName;
extern const NSString * const sFacebookFieldName;
extern const NSString * const sFacebookFieldPicture;
extern const NSString * const sFacebookFieldWebsite;
extern const NSString * const sFacebookFieldWork;

extern const NSString * const sFacebookColumnBirthday;
extern const NSString * const sFacebookColumnEmail;
extern const NSString * const sFacebookColumnGid;
extern const NSString * const sFacebookColumnId;
extern const NSString * const sFacebookColumnFirstName;
extern const NSString * const sFacebookColumnLastName;
extern const NSString * const sFacebookColumnLocation;
extern const NSString * const sFacebookColumnMiddleName;
extern const NSString * const sFacebookColumnName;
extern const NSString * const sFacebookColumnPicture;
extern const NSString * const sFacebookColumnWebsite;
extern const NSString * const sFacebookColumnWork;

@interface FacebookConstants : NSObject

+( NSString * ) attributeToColumn:( NSString * )inAttribute;
+( NSString * ) attributesToColumns:( NSArray * )inAttributes;
+( NSString * ) attributeToField:( NSString * )inAttribute;
+( NSString * ) attributesToFields:( NSArray * )inAttributes;
+( NSDictionary * ) getAttributesToColumns;
+( NSDictionary * ) getAttributesToFields;

@end