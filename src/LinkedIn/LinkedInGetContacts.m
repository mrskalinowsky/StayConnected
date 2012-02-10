
#import "LinkedInConstants.h"
#import "LinkedInGetContacts.h"
#import "LinkedInContact.h"

@interface LinkedInGetContacts (PrivateMethods)

-( void )addContactFromResult:( NSDictionary * )inResult
                    contacts:( NSMutableDictionary * )inContacts;
-( void )getContacts:( NSArray * )inContactIds
            contacts:( NSMutableDictionary * )outContacts
               error:( NSError ** )outError;
-( NSArray * )getAllContactIds:( NSError ** )outError;
-( NSArray * )contactIdsToLookupArray:( NSArray * )inContactIds;

@end


@implementation LinkedInGetContacts

static NSString * const sURLConnections   = @"http://api.linkedin.com/v1/people/~/connections";
static NSString * const sURLConnectionIds   = @"http://api.linkedin.com/v1/people/~/connections:(id)";
static NSString * const sURLPeople = @"https://api.linkedin.com/v1/people::(%@):(id,first-name,last-name,formatted-name,location:(name),picture-url,public-profile-url)";

-( NSArray * )getContacts:( NSArray * )inContactIds
               attributes:( NSArray * )inAttributes
                    error:( NSError ** )outError {
    NSError * theError = nil;
    NSArray * theContactIdsAsArray = inContactIds == nil ?
    [ self getAllContactIds:outError ] : inContactIds;
    if ( outError[ 0 ] != nil ) {
        return nil;
    }
    
    NSMutableDictionary * theContacts = [ [ NSMutableDictionary alloc ] init ];
    [ self getContacts:theContactIdsAsArray contacts:theContacts error:&theError ];

    //[ self addContactGroups:theContacts error:outError ];
    NSArray * theResults = [ theContacts allValues ];
    [ theContacts release ];
    return theResults;
}

@end

@implementation LinkedInGetContacts (PrivateMethods)

-( NSArray * )getAllContactIds:( NSError ** )outError {
    NSDictionary * theResults =
    [ mRequestor httpGet:sURLConnectionIds
              parameters:[ NSArray arrayWithObjects:sKeyFormat, sValueJSON, nil ]
                   error:outError ];
    if ( outError[ 0 ] != nil ) {
        return nil;
    }

    return [ self contactIdsToLookupArray:
            [ theResults valueForKey:@"values" ] ];
}

-( NSArray * )contactIdsToLookupArray:( NSArray * )inContactIds {
    if ( inContactIds == nil || [ inContactIds count ] == 0 ) {
        return nil;
    }
    NSMutableArray * theContactIds = [ [ NSMutableArray alloc ] init ];
    for ( NSString * theContactId in inContactIds ) {
        [theContactIds addObject:[theContactId valueForKey:@"id"]];
    }
    return [ theContactIds autorelease ];
}

-( void )getContacts:( NSArray * )inContactIds
            contacts:( NSMutableDictionary * )outContacts
               error:( NSError ** )outError {
    
    int theIndex = 0;
    NSMutableString * theContactIds = [ [ NSMutableString alloc ] init ];
    for ( NSString * theContactId in inContactIds) {
        [ theContactIds appendFormat:@"%@%@",
         theIndex++ > 0 ? @"," : @"", theContactId ];
    }

    NSDictionary * theResults =
    [ mRequestor httpGet:[ NSString stringWithFormat:sURLPeople, theContactIds ]
              parameters:[ NSArray arrayWithObjects:sKeyFormat, sValueJSON, nil ]
                   error:outError ];
    
    for ( NSDictionary * theResult in [theResults valueForKey:@"values"] ) {
        [ self addContactFromResult:theResult contacts:outContacts ];
    }
}

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