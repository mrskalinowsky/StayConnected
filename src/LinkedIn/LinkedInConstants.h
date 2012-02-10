#import <Foundation/Foundation.h>

extern const NSString * const sLinkedInProviderName;

extern const NSString * const sLinkedInAttributeId;
extern const NSString * const sLinkedInAttributeLocation;
extern const NSString * const sLinkedInAttributeLocationName;
extern const NSString * const sLinkedInAttributeFormattedName;
extern const NSString * const sLinkedInAttributeFirstName;
extern const NSString * const sLinkedInAttributeLastName;
extern const NSString * const sLinkedInAttributePicture;
extern const NSString * const sLinkedInAttributeWebsite;

extern const NSString * const sKeyFormat;
extern const NSString * const sValueJSON;

@interface LinkedInConstants : NSObject

+( NSDictionary * )getMapping;

@end
