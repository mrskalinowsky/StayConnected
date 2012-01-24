#import <Foundation/Foundation.h>

#import "TwitterCommandBaseImpl.h"

@interface TwitterGetContacts : TwitterCommandBaseImpl

-( NSArray * )getContacts:( NSArray * )inContactIds
               attributes:( NSArray * )inAttributes
                    error:( NSError ** )outError;

@end