#import "TwitterConstants.h"
#import "TwitterContact.h"
#import "TwitterContactGroup.h"
#import "TwitterGetContacts.h"

@interface TwitterGetContacts ( PrivateMethods )

-( void )addContactFromResult:( NSDictionary * )inResult
                     contacts:( NSMutableDictionary * )inContacts;
-( void )addContactGroups:( NSMutableDictionary * )inContacts
                    error:( NSError ** )outError;
-( NSArray * )contactIdsToLookupArray:( NSArray * )inContactIds;
-( void )get100Contacts:( NSString * )inContactIds
               contacts:( NSMutableDictionary * )outContacts
                  error:( NSError ** )outError;
-( NSArray * )getAllContactIds:( NSError ** )outError;
-( NSArray * )getContactGroupMembers:( TwitterContactGroup * )inGroupId
                               error:( NSError ** )outError;
-( NSArray * )getContactGroups:( NSError ** )outError;

@end

@implementation TwitterGetContacts

static NSString * const sURLFriendsIds   = @"http://api.twitter.com/1/friends/ids.json";
static NSString * const sURLListsAll     = @"http://api.twitter.com/1/lists/all.json";
static NSString * const sURLListsMembers = @"http://api.twitter.com/1/lists/members.json";
static NSString * const sURLUsersLookup  = @"http://api.twitter.com/1/users/lookup.json";
static NSString * const sKeyIdStr        = @"id_str";
static NSString * const sKeyIds          = @"ids";
static NSString * const sKeyListId       = @"list_id";
static NSString * const sKeyStringifyIds = @"stringify_ids";
static NSString * const sKeyUserId       = @"user_id";
static NSString * const sKeyUsers        = @"users";

static const NSString * const sValueStringifyIds = @"true";

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
    for ( NSString * theContactIds in theContactIdsAsArray ) {
        [ self get100Contacts:theContactIds contacts:theContacts error:&theError ];
        if ( theError != nil ) {
            break;
        }
    }
    [ self addContactGroups:theContacts error:outError ];
    NSArray * theResults = [ theContacts allValues ];
    [ theContacts release ];
     return theResults;
}

@end

@implementation TwitterGetContacts ( PrivateMethods )

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

-( void )addContactGroups:( NSMutableDictionary * )inContacts
                    error:( NSError ** )outError {
    NSArray * theContactGroups = [ self getContactGroups:outError ];
    if ( outError[ 0 ] != nil ) {
        return;
    }
    for ( TwitterContactGroup * theGroup in theContactGroups ) {
        [ inContacts setObject:theGroup forKey:[ theGroup getId ] ];
        NSArray * theContacts = [ self getContactGroupMembers:theGroup
                                                        error:outError ];
        if ( outError[ 0 ] != nil ) {
            break;
        }
        for ( TwitterContact * theContact in theContacts ) {
            [ inContacts removeObjectForKey:[ theContact getId ] ];
            [ theGroup addContact:theContact ];
            [ theContact addGroup:theGroup ];
        }
    }
}

-( NSArray * )contactIdsToLookupArray:( NSArray * )inContactIds {
    if ( inContactIds == nil || [ inContactIds count ] == 0 ) {
        return nil;
    }
    NSMutableArray * theContactIds = [ [ NSMutableArray alloc ] init ];
    NSMutableString * the100ContactIds;
    int theIndex = 0;
    int theCount = [ inContactIds count ];
    for ( NSString * theContactId in inContactIds ) {
        if ( theIndex == 0 ) {
            the100ContactIds = [ [ NSMutableString alloc ] init ];
        }
        [ the100ContactIds appendFormat:@"%@%@",
            theIndex > 0 ? @"," : @"", theContactId ];
        ++ theIndex;
        -- theCount;
        if ( theIndex == 100 || theCount == 0 ) {
            theIndex = 0;
            [ theContactIds addObject:[ the100ContactIds autorelease ] ];
        }
    }
    return [ theContactIds autorelease ];
}

-( void )get100Contacts:( NSString * )inContactIds
               contacts:( NSMutableDictionary * )outContacts
                  error:( NSError ** )outError {
    NSDictionary * theResults =
    [ mRequestor httpGet:sURLUsersLookup
              parameters:[ NSArray arrayWithObjects:sKeyUserId, inContactIds, nil ]
                   error:outError ];
    for ( NSDictionary * theResult in theResults ) {
        [ self addContactFromResult:theResult contacts:outContacts ];
    }
}

-( NSArray * )getAllContactIds:( NSError ** )outError {
    NSDictionary * theResults =
    [ mRequestor httpGet:sURLFriendsIds
              parameters:[ NSArray arrayWithObjects:sKeyStringifyIds, sValueStringifyIds, nil ]
                   error:outError ];
    if ( outError[ 0 ] != nil ) {
        return nil;
    }
    return [ self contactIdsToLookupArray:
            [ theResults valueForKey:( NSString * )sKeyIds ] ];
}

-( NSArray * )getContactGroupMembers:( TwitterContactGroup * )inGroup error:( NSError ** )outError {
    NSDictionary * theResults =
    ( NSDictionary * )[ mRequestor httpGet:sURLListsMembers
                                parameters:[ NSArray arrayWithObjects:sKeyListId, [ inGroup getId ], nil ]
                                     error:outError ];
    if ( outError[ 0 ] != nil ) {
        return nil;
    }
    NSMutableArray * theGroupMembers = [ [ NSMutableArray alloc ] init ];
    NSArray * theUsers = [ theResults valueForKey:sKeyUsers ];
    for ( NSDictionary * theUser in theUsers ) {
        TwitterContact * theContact =
        [ [ TwitterContact alloc ] initWithId:[ theUser valueForKey:sKeyIdStr ]
                                   attributes:theUser ];
        [ theGroupMembers addObject:theContact ];
        [ theContact release ];
    }
    return [ theGroupMembers autorelease ]; 
}

-( NSArray * )getContactGroups:( NSError ** )outError {
    NSArray * theResults =
    ( NSArray * )[ mRequestor httpGet:sURLListsAll parameters:nil error:outError ];
    if ( outError[ 0 ] != nil ) {
        return nil;
    }
    NSMutableArray * theLists = [ [ NSMutableArray alloc ] init ];
    for ( NSDictionary * theResult in theResults ) {
        TwitterContactGroup * theList =
        [ [ TwitterContactGroup alloc ] initWithId:[ theResult valueForKey:sKeyIdStr ]
                                        attributes:theResult ];
        [ theLists addObject:theList ];
        [ theList release ];
    }
    return [ theLists autorelease ];
}

@end
