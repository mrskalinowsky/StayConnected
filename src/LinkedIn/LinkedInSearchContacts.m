
#import "LinkedInSearchContacts.h"
#import "LinkedInContact.h"
#import "LinkedInConstants.h"

@interface LinkedInSearchContacts (PrivateMethods)

-( void )addContactFromResult:( NSDictionary * )inResult
                     contacts:( NSMutableDictionary * )inContacts;

@end

@implementation LinkedInSearchContacts

static NSString * const sURLSearch = @"https://api.linkedin.com/v1/people-search:(people:(id,first-name,last-name,formatted-name,location:(name),picture-url,public-profile-url,api-standard-profile-request))";

-( NSArray * )searchContacts:( NSString * )inSearchString
                  attributes:( NSArray * )inAttributes
                       error:( NSError ** )outError {
    
    NSDictionary * theResults =
    [ mRequestor httpGet:sURLSearch
              parameters:[ NSArray arrayWithObjects:sKeyFormat, sValueJSON, @"keywords", inSearchString, nil ]
                   error:outError ];
    if ( outError[ 0 ] != nil ) {
        return nil;
    }

    NSMutableDictionary * theContacts = [ [ NSMutableDictionary alloc ] init ];
    for ( NSDictionary * theResult in [[theResults valueForKey:@"people"] valueForKey:@"values"] ) {
        [ self addContactFromResult:theResult contacts:theContacts ];
    }
    NSArray * theFinalContacts = [ theContacts allValues ];
    [ theContacts release ];
    return theFinalContacts;
}

@end

@implementation LinkedInSearchContacts (PrivateMethods)

-( void )addContactFromResult:( NSDictionary * )inResult
                     contacts:( NSMutableDictionary * )inContacts {
    
    NSString * theId = [ inResult valueForKey:( NSString * )sLinkedInAttributeId ];
    if ( [ inContacts valueForKey:theId ] == nil ) {
        LinkedInContact * theContact =
        [ [ LinkedInContact alloc ] initWithId:theId attributes:inResult ];
        [ inContacts setValue:theContact forKey:theId ];
        [ theContact release];
    }
}

@end
