#import "TwitterConstants.h"
#import "TwitterContact.h"
#import "TwitterContactsProvider.h"
#import "TwitterRequestExecutor.h"
#import "TwitterSearchContacts.h"

@interface TwitterSearchContacts ( PrivateMethods )

-( void )addContactFromResult:( NSDictionary * )inResult
                     contacts:( NSMutableDictionary * )inContacts;

@end

@implementation TwitterSearchContacts

static NSString * const sURLSearch = @"http://api.twitter.com/1/users/search.json";
static NSString * const sKeyQ      = @"q";


-( void )dealloc {
    [ mCallback release ];
    [ mAttributes release ];
    [ mSearchString release ];
    [ mProvider release ];
    [ super dealloc ];
}

-( id )initWithProvider:( TwitterContactsProvider * )inProvider
           searchString:( NSString * )inSearchString
             attributes:( NSArray * )inAttributes
               callback:( id< ContactsCallback > )inCallback {
    self = [ super init ];
    if ( self != nil ) {
        mProvider = [ inProvider retain ];
        mSearchString = [ inSearchString retain ];
        mAttributes = [ inAttributes retain ];
        mCallback = [ inCallback retain ];
    }
    return self;
}

-( void )searchContacts {
    [ [ mProvider getOAuthRequestor ]
        httpGet:sURLSearch
     parameters:[ NSArray arrayWithObjects:sKeyQ, mSearchString, nil ]
       callback:self ];
}

// OAuthRequestCallback implementation
-( void )requestComplete:( NSDictionary * )inResult error:( NSError * )inError {
    if ( inError == nil ) {
        NSMutableDictionary * theResults = [ [ NSMutableDictionary alloc ] init ];
        for ( NSDictionary * theResult in inResult ) {
            [ self addContactFromResult:theResult contacts:theResults ];
        }
        [ mCallback onContactsFound:[ theResults allValues ] error:nil ];
        [ theResults autorelease ];
    } else {
        [ mCallback onContactsFound:nil error:inError ];
    }
    [ mProvider requestComplete:self ];
}

@end

@implementation TwitterSearchContacts ( PrivateMethods )

-( void )addContactFromResult:( NSDictionary * )inResult
                     contacts:( NSMutableDictionary * )inContacts {
    NSString * theId = [ inResult valueForKey:( NSString * )sTwitterAttributeId ];
    if ( [ inContacts valueForKey:theId ] == nil ) {
        TwitterContact * theContact =
        [ [ TwitterContact alloc ] initWithId:theId attributes:inResult ];
        [ inContacts setValue:theContact forKey:theId ];
        [ theContact release];
    }
}

@end
