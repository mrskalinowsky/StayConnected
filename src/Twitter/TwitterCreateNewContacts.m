#import "Constants.h"
#import "ContactsProvider.h"
#import "StayConnectedError.h"
#import "TwitterContactsProvider.h"
#import "TwitterRequestExecutor.h"
#import "TwitterCreateNewContacts.h"

@interface TwitterCreateNewContacts ( PrivateMethods )

-( void )requestComplete;

@end

@implementation TwitterCreateNewContacts

static NSString * const sURLCreateNewContact = @"http://api.twitter.com/1/friendships/create.json";
static NSString * const sKeyUserId           = @"user_id";

-( void )dealloc {
    [ mErrors release ];
    [ mCallback release ];
    [ mContactIds release ];
    [ mProvider release ];
    [ super dealloc ];
}

-( id )initWithProvider:( TwitterContactsProvider * )inProvider
             contactIds:( NSArray * )inContactIds
               callback:( id< NewContactsCallback > )inCallback {
    self = [ super init ];
    if ( self != nil ) {
        mProvider = [ inProvider retain ];
        mContactIds = [ inContactIds retain ];
        mCallback = [ inCallback retain ];
        mErrors = [ [ NSMutableString alloc ] init ];
        mRemainingRequestCount = 0;
    }
    return self;
}

-( void )createNewContacts {
    mRemainingRequestCount = [ mContactIds count ];
    for ( NSString * theContactId in mContactIds ) {
        [ [ mProvider getOAuthRequestor ] httpPost:sURLCreateNewContact parameters:[ NSArray arrayWithObjects:sKeyUserId, theContactId, nil ] callback:self ];
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

@implementation TwitterCreateNewContacts ( PrivateMethods )

-( void )requestComplete {
    NSError * theError = nil;
    if ( [ mErrors length ] > 0 ) {
        theError =
        [ [ NSError alloc ] initWithCode:ErrTwitterCreateNewContactsFailed
                             description:@"err_twitter_create_new_contacts_failed"
                                  reason:mErrors ];
    }
    [ mCallback onContactsRequested:[ theError autorelease ] ];
}

@end