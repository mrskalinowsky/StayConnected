#import "AppDelegate.h"
#import "FacebookContactsProvider.h"
#import "FacebookConstants.h"
#import "FacebookGetContacts.h"
#import "FacebookSearchContacts.h"
#import "FBConnect.h"

static NSString * const sURLPrefixFBAuth  = @"fbauth://authorize";
static NSString * const sURLPrefixFBOAuth = @"https://m.facebook.com/dialog/oauth";
static NSString * const sURLPrefixFBAppId = @"fb100188760104407://authorize";

@implementation FacebookContactsProvider

-( void )dealloc {
    [ mFacebook release ];
    [ super dealloc ];
}

-( NSString * )getName {
    return ( NSString * )sFacebookProviderName;
}

-( id )init {
    self = [ super init ];
    if ( self != nil ) {
        mFacebook =
            [ [ Facebook alloc ] initWithAppId:( NSString * )sFacebookAppId
                                   andDelegate:nil ];
        NSUserDefaults * theDefaults = [ NSUserDefaults standardUserDefaults ];
        if ( [ theDefaults objectForKey:( NSString * )sFacebookKeyFBAccess ] != nil &&
             [ theDefaults objectForKey:( NSString * )sFacebookKeyFBExpirationDate] != nil ) {
            mFacebook.accessToken =
                [ theDefaults objectForKey:( NSString * )sFacebookKeyFBAccess ];
            mFacebook.expirationDate =
                [ theDefaults objectForKey:( NSString * )sFacebookKeyFBExpirationDate ];
        }
    }
    return self;
}

-( void )requestComplete:( id )inRequestObject {
    [ inRequestObject release ];
}

// ContactsProvider Implementation
-( BOOL )canOpenURL:( NSURL * )inURL {
    NSString * thePrefix = [ inURL absoluteString ];
    return [ thePrefix hasPrefix:sURLPrefixFBAuth ]  ||
           [ thePrefix hasPrefix:sURLPrefixFBOAuth ] ||
           [ thePrefix hasPrefix:sURLPrefixFBAppId ];
}

-( void )createNewContacts:( NSArray * )inContacts
                   message:( NSString * )inMessage
                  callback:( id< NewContactsCallback > )inCallback {
    NSLog(@"FacebookContactsProvider.createNewContacts not implemented");
}

-( void )getContacts:( NSArray * )inContactIds
          attributes:( NSArray * )inAttributes
            callback:( id< ContactsCallback > )inCallback {
    FacebookGetContacts * theGetContacts =
    [ [ FacebookGetContacts alloc ] initWithProvider:self
                                             facebook:mFacebook
                                           contactIds:inContactIds
                                           attributes:inAttributes
                                             callback:inCallback ];
    [ theGetContacts getContacts ];
    // theGetContacts is released in requestComplete once the request is complete
}

-( BOOL )openURL:( NSURL * )inURL {
    BOOL theRC = [ [ inURL absoluteString ] hasPrefix:sURLPrefixFBOAuth ] ?
        [ XAppDelegate handleProviderURL:inURL ] :
        [ mFacebook handleOpenURL:inURL ];
    [ XAppDelegate.stackController dismissModalViewControllerAnimated:YES ];
    return theRC;
}

-( void )searchForContacts:( NSString * )inSearchString
                attributes:( NSArray * )inAttributes
                  callback:( id< ContactsCallback > )inCallback {
    FacebookSearchContacts * theSearchContacts =
    [ [ FacebookSearchContacts alloc ] initWithProvider:self
                                               facebook:mFacebook
                                           searchString:inSearchString
                                             attributes:inAttributes
                                               callback:inCallback ];
    [ theSearchContacts searchContacts ];
    // theSearchContacts is released in requestComplete once the request is complete
}

-( void )sendMessage:( NSArray * )inContacts
             message:( NSString * )inMessage
            callback:( id< SendMessageCallback > )inCallback {
    NSLog(@"FacebookContactsProvider.sendMessage not implemented");
}

@end