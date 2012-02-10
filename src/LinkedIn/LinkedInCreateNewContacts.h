
#import <Foundation/Foundation.h>
#import "LinkedInCommandBaseImpl.h"

@interface LinkedInCreateNewContacts : LinkedInCommandBaseImpl

-( void )createNewContacts:( NSArray * )inContactIds error:( NSError ** )outError;

@end
