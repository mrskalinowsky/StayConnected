#import "AppDelegate.h"
#import "OAuthRequestor.h"
#import "LinkedInContactsProvider.h"
#import "LinkedInConstants.h"
#import "LinkedInGetContacts.h"
#import "LinkedInCreateNewContacts.h"
#import "LinkedInSearchContacts.h"

@implementation LinkedInContactsProvider

static NSString * sKey             = @"i9s4txurb0ai";
static NSString * sSecret          = @"R3tINaKaA960En9Q";
static NSString * sRequestTokenURL = @"https://api.linkedin.com/uas/oauth/requestToken";
static NSString * sAuthoriseURL    = @"https://api.linkedin.com/uas/oauth/authorize";
static NSString * sAccessTokenURL  = @"https://api.linkedin.com/uas/oauth/accessToken";
static NSString * sCallbackSuffix  = @"linkedIn";

static NSString * sQueryUserURL = @"https://api.linkedin.com/query";
static NSString * sQueryParamKey = @"userid";

-( BOOL )canOpenURL:( NSURL * )inURL {
    NSString * thePrefix = [ inURL absoluteString ];
    return [ thePrefix hasPrefix:sAuthoriseURL ] ||
           [ mOAuthRequestor canOpenURL:inURL ];
}

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
    LinkedInCreateNewContacts * theCreateNewContacts =
    [ [ LinkedInCreateNewContacts alloc ] initWithRequestor:mOAuthRequestor ];
    NSError * theError = nil;
    [ theCreateNewContacts createNewContacts:inArgs.contacts error:&theError ];
    [ inArgs.callback onContactsRequested:theError ];
    [ theCreateNewContacts release ];
}

-( void )backgroundGetContacts:( GetContactsArgs * )inArgs {
    
    LinkedInGetContacts * theGetContacts =
    [ [ LinkedInGetContacts alloc ] initWithRequestor:mOAuthRequestor ];
    NSError * theError = nil;
    NSArray * theContacts = [ theGetContacts getContacts:inArgs.contactIds
                                              attributes:inArgs.attributes
                                                   error:&theError ];
    [ inArgs.callback onContactsFound:theContacts error:theError ];
    [ theGetContacts release ];
}

-( void )backgroundSearchForContacts:( SearchForContactsArgs * )inArgs {
    LinkedInSearchContacts * theSearchContacts =
    [ [ LinkedInSearchContacts alloc ] initWithRequestor:mOAuthRequestor ];
    NSError * theError = nil;
    NSArray * theContacts = [ theSearchContacts searchContacts:inArgs.searchString
                                                    attributes:inArgs.attributes
                                                         error:&theError ];
    [ inArgs.callback onContactsFound:theContacts error:theError ];     
    [ theSearchContacts release ];
}

-( void )backgroundSendMessage:( SendMessageArgs * )inArgs {
    NSLog(@"backgroundSendMessage not implemented.");
}

-( NSString * )getName {
    return ( NSString * )sLinkedInProviderName;
}

-( BOOL )openURL:( NSURL * )inURL {
    BOOL theRC;
    if ( [ [ inURL absoluteString ] hasPrefix:sAuthoriseURL ] ) {
        [ XAppDelegate performSelectorOnMainThread:@selector(handleProviderURL:)
                                        withObject:inURL
                                     waitUntilDone:FALSE ];
        theRC = TRUE;
    } else {
        theRC = [ mOAuthRequestor openURL:inURL ];
    }
    [ XAppDelegate.stackController dismissModalViewControllerAnimated:YES ];
    return theRC;
}

@end
