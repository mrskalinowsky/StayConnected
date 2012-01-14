#import "Contact.h"
#import "ContactsProvider.h"
#import "TwitterContactsProvider.h"
#import "TwitterRequestExecutor.h"
#import "TwitterSendMessage.h"

@interface TwitterSendMessage ( PrivateMethods )

-( void )requestComplete:( NSError * )inError;
-( void )sendMessage:( NSString * )inContactId
               error:( NSError ** )outError;

@end

@implementation TwitterSendMessage

static const NSString * const sURLSendMessage = @"http://api.twitter.com/1/direct_messages/new.json";
static const NSString * const sKeyUserId = @"user_id";
static const NSString * const sKeyText = @"text";

-( void )dealloc {
    [ mCallback release ];
    [ mMessage release ];
    [ mContacts release ];
    [ super dealloc ];
}

-( id )initWithProvider:( TwitterContactsProvider * )inProvider
               contacts:( NSArray * )inContacts
                message:( NSString * )inMessage
               callback:( id< SendMessageCallback > )inCallback {
    self = [ super initWithProvider:inProvider ];
    if ( self != nil ) {
        mContacts = [ inContacts retain ];
        mMessage = [ inMessage retain ];
        mCallback = [ inCallback retain ];
    }
    return self;
}

-( void )sendMessage {
    NSError * theError = nil;
    for ( id< Contact > theContact in mContacts ) {
        [ self sendMessage:[ theContact getId ] error:&theError ];
        if ( theError != nil ) {
            break;
        }
    }
    [ self requestComplete:theError ];
}

@end

@implementation TwitterSendMessage ( PrivateMethods )

-( void )requestComplete:inError {
    [ mCallback onMessageSent:inError ];
    [ self requestComplete ];
}

-( void )sendMessage:( NSString * )inContactId
               error:( NSError ** )outError {
    TwitterRequestExecutor * theRequest = [ [ TwitterRequestExecutor alloc ] init ];
    [ self setBusy:TRUE ];
    [ theRequest
     execute:( NSString * )sURLSendMessage
     parameters:[ NSDictionary dictionaryWithObjectsAndKeys:
                 inContactId, ( NSString * )sKeyUserId,
                 mMessage, ( NSString * )sKeyText, nil ]
     method:TWRequestMethodPOST
     handler:^( NSData * inResponseData, NSHTTPURLResponse * inURLResponse, NSError * inError ) {
         if ( inURLResponse == nil || [ inURLResponse statusCode ] != 200 ) {
             outError[ 0 ] = inError;
         } else {
             NSError * theError = nil;
             NSDictionary * theResults =
             [ NSJSONSerialization JSONObjectWithData:inResponseData
                                              options:0
                                                error:&theError ];
             if ( theResults == nil ) {
                 outError[ 0 ] = theError;
             }
         }
         [ self setBusy:FALSE ];
     } ];
    [ self waitWhileBusy ];
    [ theRequest release ];
}

@end