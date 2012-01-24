#import "TwitterConstants.h"
#import "TwitterContact.h"
#import "TwitterSearchContacts.h"

@interface TwitterSearchContacts ( PrivateMethods )

-( void )addContactFromResult:( NSDictionary * )inResult
                     contacts:( NSMutableDictionary * )inContacts;

@end

@implementation TwitterSearchContacts

static NSString * const sURLSearch = @"http://api.twitter.com/1/users/search.json";
static NSString * const sKeyQ      = @"q";

-( NSArray * )searchContacts:( NSString * )inSearchString
                  attributes:( NSArray * )inAttributes
                       error:( NSError ** )outError {
    NSDictionary * theResults =
    [ mRequestor httpGet:sURLSearch
              parameters:[ NSArray arrayWithObjects:sKeyQ, inSearchString, nil ]
                   error:outError ];
    if ( outError[ 0 ] != nil ) {
        return nil;
    }
    NSMutableDictionary * theContacts = [ [ NSMutableDictionary alloc ] init ];
    for ( NSDictionary * theResult in theResults ) {
        [ self addContactFromResult:theResult contacts:theContacts ];
    }
    NSArray * theFinalContacts = [ theContacts allValues ];
    [ theContacts release ];
    return theFinalContacts;
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
