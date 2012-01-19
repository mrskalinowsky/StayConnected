#import "Constants.h"
#import "Contact.h"
#import "ContactsProvider.h"
#import "StayConnectedError.h"
#import "TwitterContactsProvider.h"
#import "TwitterRequestExecutor.h"
#import "TwitterSendMessage.h"

@interface TwitterSendMessage ( PrivateMethods )

-( void )requestComplete;

@end

@implementation TwitterSendMessage

static NSString * const sURLSendMessage = @"http://api.twitter.com/1/direct_messages/new.json";
static NSString * const sKeyUserId      = @"user_id";
static NSString * const sKeyText        = @"text";

-( void )dealloc {
    [ mErrors release ];
    [ mCallback release ];
    [ mMessage release ];
    [ mContacts release ];
    [ mProvider release ];
    [ super dealloc ];
}

-( id )initWithProvider:( TwitterContactsProvider * )inProvider
               contacts:( NSArray * )inContacts
                message:( NSString * )inMessage
               callback:( id< SendMessageCallback > )inCallback {
    self = [ super init ];
    if ( self != nil ) {
        mProvider = [ inProvider retain ];
        mContacts = [ inContacts retain ];
        mMessage = [ inMessage retain ];
        mCallback = [ inCallback retain ];
        mErrors = [ [ NSMutableString alloc ] init ];
        mRemainingRequestCount = 0;
    }
    return self;
}

-( void )sendMessage {
    // Todo: Can only send direct message to followers
    mRemainingRequestCount = [ mContacts count ];
    for ( id< Contact > theContact in mContacts ) {
        [ [ mProvider getOAuthRequestor ] httpPost:sURLSendMessage parameters:[ NSArray arrayWithObjects:sKeyUserId, [ theContact getId ], sKeyText, mMessage, nil ] callback:self ];
    }
}

// OAuthRequestCallback implementation
-( void )requestComplete:( NSDictionary * )inResult error:( NSError * )inError {
    @synchronized( self ) {
        if ( inError != nil ) {
            [ mErrors appendFormat:@"%@\n%@\n\n",
             [ inError localizedDescription ],
             [ inError localizedFailureReason ] ];
        }
        -- mRemainingRequestCount;
        if ( mRemainingRequestCount == 0 ) {
            [ self requestComplete ];
        }
    }
}

@end

@implementation TwitterSendMessage ( PrivateMethods )

-( void )requestComplete {
    NSError * theError = nil;
    if ( [ mErrors length ] > 0 ) {
        theError =
        [ [ NSError alloc ] initWithCode:ErrTwitterSendMessageFailed
                             description:@"err_twitter_send_failed"
                                  reason:mErrors ];
    }
    [ mCallback onMessageSent:[ theError autorelease ] ];
}

@end