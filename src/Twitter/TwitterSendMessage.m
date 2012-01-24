#import "Contact.h"
#import "TwitterSendMessage.h"

@implementation TwitterSendMessage

static NSString * const sURLSendMessage = @"http://api.twitter.com/1/direct_messages/new.json";
static NSString * const sKeyUserId      = @"user_id";
static NSString * const sKeyText        = @"text";

-( void )sendMessage:( NSArray * )inContacts
             message:( NSString * )inMessage
               error:( NSError ** )outError {
    // Todo: Can only send direct message to followers ??
    for ( id< Contact > theContact in inContacts ) {
        [ mRequestor httpPost:sURLSendMessage
                   parameters:[ NSArray arrayWithObjects:sKeyUserId, [ theContact getId ], sKeyText, inMessage, nil ] error:outError ];
        if ( outError[ 0 ] != nil ) {
            break;
        }
    }
}

@end