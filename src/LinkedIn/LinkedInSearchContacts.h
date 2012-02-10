
#import <Foundation/Foundation.h>
#import "LinkedInCommandBaseImpl.h"

@interface LinkedInSearchContacts : LinkedInCommandBaseImpl

-( NSArray * )searchContacts:( NSString * )inSearchString
                  attributes:( NSArray * )inAttributes
                       error:( NSError ** )outError;

@end
