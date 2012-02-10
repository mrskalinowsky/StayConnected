
#import <Foundation/Foundation.h>
#import "LinkedInCommandBaseImpl.h"

@interface LinkedInSendMessage : LinkedInCommandBaseImpl

-( void )sendMessage:( NSArray * )inContacts
             message:( NSString * )inMessage
               error:( NSError ** )outError;

@end
