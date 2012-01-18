#import "OAuthRequestor.h"
#import "TwitterConstants.h"
#import "TwitterContactsProvider.h"
#import "TwitterCreateNewContacts.h"
#import "TwitterGetContacts.h"
#import "TwitterSearchContacts.h"
#import "TwitterSendMessage.h"

@implementation TwitterContactsProvider

static NSString * sKey             = @"tXgnFM29DuKawZXbr1FfiA";
static NSString * sSecret          = @"KX2nKmTNz1Rc0mV6FDFB5i7vjUBYupGEjcZn1gguvw";
static NSString * sTokenRequestURL = @"https://twitter.com/oauth/request_token";
static NSString * sAuthoriseURL    = @"https://twitter.com/oauth/authorize";
static NSString * sTokenAccessURL  = @"https://twitter.com/oauth/access_token";
static NSString * sCallbackSuffix  = @"twitter";

-( void )dealloc {
    [ mOAuthRequestor release ];
    [ super dealloc ];
}

-( OAuthRequestor * )getOAuthRequestor {
    return mOAuthRequestor;
}

-( id )init {
    self = [ super init ];
    if ( self != nil ) {
        mOAuthRequestor =
        [ [ OAuthRequestor alloc ] initWithKey:sKey
                                        secret:sSecret
                               tokenRequestURL:sTokenRequestURL
                                  authoriseURL:sAuthoriseURL
                                tokenaccessURL:sTokenAccessURL
                                callbackSuffix:sCallbackSuffix ];
    }
    return self;
}

// ContactsProvider Implementation
-( void )createNewContacts:( NSArray * )inContacts
                   message:( NSString * )inMessage
                  callback:( id< NewContactsCallback > )inCallback {
    TwitterCreateNewContacts * theCreateNewContacts =
    [ [ TwitterCreateNewContacts alloc ] initWithProvider:self
                                               contactIds:inContacts
                                                 callback:inCallback ];
    [ theCreateNewContacts createNewContacts ];
    // theCreateNewContacts is released later in requestComplete
}

-( void )getContacts:( NSArray * )inContactIds
          attributes:( NSArray * )inAttributes
            callback:( id< ContactsCallback > )inCallback {
    TwitterGetContacts * theGetContacts =
    [ [ TwitterGetContacts alloc ] initWithProvider:self
                                         contactIds:inContactIds
                                         attributes:inAttributes
                                           callback:inCallback ];
    [ theGetContacts getContacts ];
    // theGetContacts is released later in requestComlete
}

-( NSString * )getName {
    return ( NSString * )sTwitterProviderName;
}

-( BOOL )openURL:( NSURL * )inURL {
    return FALSE;
}

-( void )requestComplete:( id )inRequestObject {
    [ inRequestObject release ];
}

-( void )searchForContacts:( NSString * )inSearchString
                attributes:( NSArray * )inAttributes
                  callback:( id< ContactsCallback > )inCallback {
    TwitterSearchContacts * theSearchContacts =
    [ [ TwitterSearchContacts alloc ] initWithProvider:self
                                         searchString:inSearchString
                                         attributes:inAttributes
                                           callback:inCallback ];
    [ theSearchContacts searchContacts ];
    // theSearchContacts is released later in requestComlete
}

-( void )sendMessage:( NSArray * )inContacts
             message:( NSString * )inMessage
            callback:( id< SendMessageCallback > )inCallback {
    TwitterSendMessage * theSendMessage =
    [ [ TwitterSendMessage alloc ] initWithProvider:self
                                           contacts:inContacts
                                            message:inMessage
                                           callback:inCallback ];
    [ theSendMessage sendMessage ];
    // theSendMessage is released later in requestComlete
}
@end
