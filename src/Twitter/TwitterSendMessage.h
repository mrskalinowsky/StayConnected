#import <Foundation/Foundation.h>

#import "TwitterCommandBaseImpl.h"

@interface TwitterSendMessage : TwitterCommandBaseImpl

-( void )sendMessage:( NSArray * )inContacts
             message:( NSString * )inMessage
               error:( NSError ** )outError;


@end