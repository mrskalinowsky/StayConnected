#import <Foundation/Foundation.h>

extern const NSString * const sTwitterProviderName;

extern const NSString * const sTwitterAttributeBirthday;
extern const NSString * const sTwitterAttributeEmail;
extern const NSString * const sTwitterAttributeId;
extern const NSString * const sTwitterAttributeFirstName;
extern const NSString * const sTwitterAttributeLastName;
extern const NSString * const sTwitterAttributeLocation;
extern const NSString * const sTwitterAttributeMiddleName;
extern const NSString * const sTwitterAttributeName;
extern const NSString * const sTwitterAttributePicture;
extern const NSString * const sTwitterAttributeWebsite;
extern const NSString * const sTwitterAttributeWork;

@interface TwitterConstants : NSObject

+( NSDictionary * )getMapping;

@end
