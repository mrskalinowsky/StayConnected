#import <Foundation/Foundation.h>

#import "TwitterCommandBaseImpl.h"

@interface TwitterCreateNewContacts : TwitterCommandBaseImpl

-( void )createNewContacts:( NSArray * )inContactIds error:( NSError ** )outError;

@end

