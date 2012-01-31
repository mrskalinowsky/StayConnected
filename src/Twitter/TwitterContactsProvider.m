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
static NSString * sRequestTokenURL = @"https://twitter.com/oauth/request_token";
static NSString * sAuthoriseURL    = @"https://twitter.com/oauth/authorize";
static NSString * sAccessTokenURL  = @"https://twitter.com/oauth/access_token";
static NSString * sCallbackSuffix  = @"twitter";

-( void )dealloc {
    [ mOAuthRequestor release ];
    [ super dealloc ];
}

-( id )init {
    self = [ super init ];
    if ( self != nil ) {
        mOAuthRequestor =
        [ [ OAuthRequestor alloc ] initWithKey:sKey
                                        secret:sSecret
                               requestTokenURL:sRequestTokenURL
                                  authoriseURL:sAuthoriseURL
                                accessTokenURL:sAccessTokenURL
                                callbackSuffix:sCallbackSuffix ];
    }
    return self;
}

-( void )backgroundCreateNewContacts:( CreateNewContactsArgs * )inArgs {
    TwitterCreateNewContacts * theCreateNewContacts =
     [ [ TwitterCreateNewContacts alloc ] initWithRequestor:mOAuthRequestor ];
    NSError * theError = nil;
    [ theCreateNewContacts createNewContacts:inArgs.contacts error:&theError ];
    [ inArgs.callback onContactsRequested:theError ];
    [ theCreateNewContacts release ];
}

-( void )backgroundGetContacts:( GetContactsArgs * )inArgs {
    TwitterGetContacts * theGetContacts =
     [ [ TwitterGetContacts alloc ] initWithRequestor:mOAuthRequestor ];
    NSError * theError = nil;
    NSArray * theContacts = [ theGetContacts getContacts:inArgs.contactIds
                                              attributes:inArgs.attributes
                                                   error:&theError ];
    [ inArgs.callback onContactsFound:theContacts error:theError ];
    [ theGetContacts release ];
}

-( void )backgroundSearchForContacts:( SearchForContactsArgs * )inArgs {
    TwitterSearchContacts * theSearchContacts =
     [ [ TwitterSearchContacts alloc ] initWithRequestor:mOAuthRequestor ];
    NSError * theError = nil;
    NSArray * theContacts = [ theSearchContacts searchContacts:inArgs.searchString
                                                    attributes:inArgs.attributes
                                                         error:&theError ];
    [ inArgs.callback onContactsFound:theContacts error:theError ];     
    [ theSearchContacts release ];
}

-( void )backgroundSendMessage:( SendMessageArgs * )inArgs {
    TwitterSendMessage * theSendMessage =
     [ [ TwitterSendMessage alloc ] initWithRequestor:mOAuthRequestor ];
    NSError * theError = nil;
    [ theSendMessage sendMessage:inArgs.contacts message:inArgs.message error:&theError ];
    [ inArgs.callback onMessageSent:theError ];
    [ theSendMessage release ];
}

-( NSString * )getName {
    return ( NSString * )sTwitterProviderName;
}

-( BOOL )openURL:( NSURL * )inURL {
    return [ mOAuthRequestor openURL:inURL ];
}

@end
