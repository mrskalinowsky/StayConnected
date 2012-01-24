#import <Foundation/Foundation.h>

#import "TwitterCommandBaseImpl.h"

@interface TwitterSearchContacts : TwitterCommandBaseImpl 

-( NSArray * )searchContacts:( NSString * )inSearchString
                  attributes:( NSArray * )inAttributes
                       error:( NSError ** )outError;

@end