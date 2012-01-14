#import "TwitterConstants.h"
#import "TwitterContact.h"
#import "TwitterContactsProvider.h"
#import "TwitterRequestExecutor.h"
#import "TwitterSearchContacts.h"

@interface TwitterSearchContacts ( PrivateMethods )

-( void )addContactFromResult:( NSDictionary * )inResult
                     contacts:( NSMutableDictionary * )inContacts;
-( void )requestComplete:( NSError * )inError;
-( void )searchContacts:( NSError ** )outError;

@end

@implementation TwitterSearchContacts

static const NSString * const sURLSearch = @"http://api.twitter.com/1/users/search.json";
static const NSString * const sKeyQ = @"q";


-( void )dealloc {
    [ mResults release ];
    [ mCallback release ];
    [ mAttributes release ];
    [ mSearchString release ];
    [ super dealloc ];
}

-( id )initWithProvider:( TwitterContactsProvider * )inProvider
           searchString:( NSString * )inSearchString
             attributes:( NSArray * )inAttributes
               callback:( id< ContactsCallback > )inCallback {
    self = [ super initWithProvider:inProvider ];
    if ( self != nil ) {
        mSearchString = [ inSearchString retain ];
        mAttributes = [ inAttributes retain ];
        mCallback = [ inCallback retain ];
        mResults = [ [ NSMutableDictionary alloc ] init ];
    }
    return self;
}

-( void )searchContacts {
    NSError * theError = nil;
    [ self searchContacts:&theError ];
    [ self requestComplete:theError ];
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

-( void )requestComplete:inError {
    [ mCallback onContactsFound:inError == nil ? [ mResults allValues ] : nil
                          error:inError ];
    [ self requestComplete ];
}

-( void )searchContacts:( NSError ** )outError {
    TwitterRequestExecutor * theRequest = [ [ TwitterRequestExecutor alloc ] init ];
    [ self setBusy:TRUE ];
    [ theRequest
     execute:( NSString * )sURLSearch
     parameters:[ NSDictionary dictionaryWithObject:mSearchString
                                             forKey:( NSString * )sKeyQ ]
     method:TWRequestMethodGET
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
             } else {
                 for ( NSDictionary * theResult in theResults ) {
                     [ self addContactFromResult:theResult contacts:mResults ];
                 }
             }
         }
         [ self setBusy:FALSE ];
     } ];
    [ self waitWhileBusy ];
    [ theRequest release ];
}

@end
