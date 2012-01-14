#import "FacebookGetContacts.h"
#import "FacebookContact.h"
#import "FacebookContactGroup.h"
#import "FacebookContactsProvider.h"
#import "FacebookConstants.h"
#import "ContactsProvider.h"

static const NSString * const sFacebookMethodMultiQuery = @"fql.multiquery";
static const NSString * const sHttpMethodPOST = @"POST";
static const NSString * const sQueries = @"queries";

static const NSString * const sSQLAllFriendsIds =
    @"select uid2 from friend where uid1 = me()";
static const NSString * const sSQLFriendsAttrs =
    @"select %@ from user where uid in ( %@ )";
static const NSString * const sQueryFriendsAttrs = @"friendsAttrs";

static const NSString * const sSQLGroupIds =
    @"select gid from group_member where uid = me()";
static const NSString * const sQueryGroupIds = @"groupIds";

static const NSString * const sSQLGroupAttrs =
    @"select gid, name from group where gid in ( select gid from #groupIds )";
static const NSString * const sQueryGroupAttrs = @"groupAttrs";

static const NSString * const sSQLGroupFriendIdsNotMe =
    @"select uid, gid from group_member where gid in ( select gid from #groupIds ) and uid != me()";
static const NSString * const sSQLGroupFriendIds =
    @"select uid, gid from group_member where gid in ( select gid from #groupIds ) and uid in ( %@ )";
static const NSString * const sQueryGroupFriendIds = @"groupFriendIds";

static const NSString * const sSQLGroupFriendAttrs =
    @"select %@ from user where uid in ( %@ )";
static const NSString * const sSQLAllGroupFriendIds =
    @"select uid from #groupFriendIds";
static const NSString * const sQueryGroupFriendAttrs = @"groupFriendAttrs";

static const NSString * const sKeyName = @"name";
static const NSString * const sKeyResult = @"fql_result_set";

@interface FacebookGetContacts ( PrivateMethods )

-( void )addContactsFromResult:( NSArray * )inResults
                      contacts:( NSMutableDictionary * )inContacts;
-( void )addContactGroupsFromResult:( NSArray * )inResults
                      contactGroups:( NSMutableDictionary * )inContactGroups;
-( void )connectUsersAndGroups:( NSDictionary * )inUsers
                        groups:( NSDictionary * )inGroups
                   connections:( NSArray * )inConnections;
-( NSString * )createQueries;
-( void )requestComplete:( NSArray * )inResults error:( NSError * )inError;
-( void )requestWithFQL;

@end

@implementation FacebookGetContacts

-( void )dealloc {
    [ mCallback release ];
    [ mColumns release ];
    [ mContactIds release ];
    [ mFacebook release ];
    [ mProvider release ];
    [ super dealloc ];
}

-( void )getContacts {
    mAuthoriser =
    [ [ FacebookAuthoriser alloc ] initWithFacebook:mFacebook
                                        andCallback:self ];
    [ mAuthoriser authorise ];
}

-( id )initWithProvider:( FacebookContactsProvider * )inProvider
               facebook:( Facebook * )inFacebook
             contactIds:( NSArray * )inContactIds
             attributes:( NSArray * )inAttributes
               callback:( id< ContactsCallback > )inCallback {
    self = [ super init ];
    if ( self != nil ) {
        mProvider = [ inProvider retain ];
        mFacebook = [ inFacebook retain ];
        mContactIds = [ inContactIds retain ];
        mColumns = [ [ FacebookConstants attributesToColumns:inAttributes ] retain ];
        mCallback = [ inCallback retain ];
    }
    return self;
}

-( void )onAuthorise:( BOOL )isAuthorised error:( NSError * )inError {
    [ mAuthoriser release ];
    if ( inError == nil ) {
        [ self requestWithFQL ];
    } else {
        [ self requestComplete:nil error:inError ];
    }
}

// FBRequestDelegate Implementation
-( void )request:( FBRequest * )inRequest didFailWithError:( NSError * )inError {
    [ self requestComplete:nil error:inError ];
}

-( void )request:( FBRequest * )inRequest didLoad:( id )inResult {
    NSMutableDictionary * theUsers = [ [ NSMutableDictionary alloc ] init ];
    NSMutableDictionary * theGroups = [ [ NSMutableDictionary alloc ] init ];
    NSArray * theUserGroupConnections = nil;
    NSArray * theResults = ( NSArray * )inResult;
    for ( NSDictionary * theResult in theResults ) {
        NSString * theQueryName = [ theResult valueForKey:( NSString * )sKeyName ];
        if ( [ sQueryFriendsAttrs isEqualToString:theQueryName ] ||
             [ sQueryGroupFriendAttrs isEqualToString:theQueryName ] ) {
            [ self addContactsFromResult:[ theResult valueForKey:( NSString * )sKeyResult ]
                                contacts:theUsers ];
        } else if ( [ sQueryGroupAttrs isEqualToString:theQueryName ] ) {
            [ self addContactGroupsFromResult:[ theResult valueForKey:( NSString * )sKeyResult ]
                                contactGroups:theGroups ];
        } else if ( [ sQueryGroupFriendIds isEqualToString:theQueryName ] ) {
            theUserGroupConnections = [ theResult valueForKey:( NSString * )sKeyResult ];
        }
    }
    if ( theUserGroupConnections != nil ) {
        [ self connectUsersAndGroups:theUsers
                              groups:theGroups
                         connections:theUserGroupConnections ];
    }
    for ( FacebookContactGroup * theGroup in [ theGroups allValues ] ) {
        NSArray * theContacts = [ theGroup getContacts ];
        if ( theContacts == nil || [ theContacts count ] == 0 ) {
            [ theGroups removeObjectForKey:[ theGroup getId ] ];
        }
    }
    NSMutableArray * theContacts = [ [ NSMutableArray alloc ] init ];
    [ theContacts addObjectsFromArray:[ theUsers allValues ] ];
    [ theUsers release ];
    [ theContacts addObjectsFromArray:[ theGroups allValues ] ];
    [ theGroups release ];
    [ self requestComplete:[ theContacts autorelease ] error:nil ];
}

@end

@implementation FacebookGetContacts ( PrivateMethods )

-( void )addContactGroupsFromResult:( NSArray * )inResults
                      contactGroups:( NSMutableDictionary * )inContactGroups {
    for ( NSDictionary * theResult in inResults ) {
        NSString * theId =
            [ NSString stringWithFormat:@"%@",
                [ theResult valueForKey:( NSString * )sFacebookColumnGid ] ];
        if ( [ inContactGroups valueForKey:theId ] == nil ) {
            FacebookContactGroup * theGroup =
                [ [ FacebookContactGroup alloc ] initWithId:theId
                                                     fields:theResult
                                           fieldsAreColumns:TRUE ];
            [ inContactGroups setValue:theGroup forKey:theId ];
            [ theGroup release ];
        }
    }
}

-( void )addContactsFromResult:( NSArray * )inResults
                      contacts:( NSMutableDictionary * )inContacts {
    for ( NSDictionary * theResult in inResults ) {
        NSString * theId = [ NSString stringWithFormat:@"%@", [ theResult valueForKey:( NSString * )sFacebookColumnId ] ];
        if ( [ inContacts valueForKey:theId ] == nil ) {
            FacebookContact * theContact =
                [ [ FacebookContact alloc ] initWithId:theId
                                                fields:theResult
                                      fieldsAreColumns:TRUE ];
            [ inContacts setValue:theContact forKey:theId ];
            [ theContact release ];
        }
    }
}

-( void )connectUsersAndGroups:( NSDictionary * )inUsers
                        groups:( NSDictionary * )inGroups
                   connections:( NSArray * )inConnections {
    for ( NSDictionary * theConnection in inConnections ) {
        NSString * theUID = [ theConnection valueForKey:( NSString * )sFacebookColumnId ];
        NSString * theGID = [ theConnection valueForKey:( NSString * )sFacebookColumnGid ];
        if ( theUID == nil || theGID == nil ) {
            return;
        }
        FacebookContact * theContact = [ inUsers valueForKey:theUID ];
        FacebookContactGroup * theGroup = [ inGroups valueForKey:theGID ];
        if ( theContact == nil || theGroup == nil ) {
            return;
        }
        [ theGroup addContact:theContact ];
        [ theContact addGroup:theGroup ];
    }
}

-( NSString * )createQueries {
    NSMutableString * theFriendIds = [ [ NSMutableString alloc ] init ];
    NSMutableString * theGroupFriendIds = [ [ NSMutableString alloc ] init ];
    NSMutableString * theSQLGroupFriendIds = [ [ NSMutableString alloc ] init ];
    if ( mContactIds == nil || [ mContactIds count ] == 0 ) {
        [ theFriendIds appendString:( NSString * )sSQLAllFriendsIds ];
        [ theGroupFriendIds appendString:( NSString * )sSQLAllGroupFriendIds ];
        [ theSQLGroupFriendIds appendString:( NSString * )sSQLGroupFriendIdsNotMe ];
    } else {
        BOOL isFirst = TRUE;
        for ( NSString * theId in mContactIds ) {
            [ theFriendIds appendFormat:@"%@%@",
             isFirst ? @"" : @",", theId ];
            isFirst = FALSE;
        }
        [ theGroupFriendIds appendString:theFriendIds ];
        [ theSQLGroupFriendIds appendFormat:( NSString * )sSQLGroupFriendIds, theFriendIds ];
    }
    return [ NSString stringWithFormat:@"{ '%@':'%@', '%@':'%@', '%@':'%@', '%@':'%@', '%@':'%@' }",
            ( NSString * )sQueryFriendsAttrs,
            [ NSString stringWithFormat:
             ( NSString * )sSQLFriendsAttrs, mColumns, [ theFriendIds autorelease ] ],
            
            ( NSString * )sQueryGroupIds, sSQLGroupIds,
            
            ( NSString * )sQueryGroupAttrs, sSQLGroupAttrs,
            
            ( NSString * )sQueryGroupFriendIds, [ theSQLGroupFriendIds autorelease ],
            
            ( NSString * )sQueryGroupFriendAttrs,
            [ NSString stringWithFormat:
             ( NSString * )sSQLGroupFriendAttrs, mColumns, [ theGroupFriendIds autorelease ] ] ];
}

-( void )requestComplete:( NSArray * )inResults error:( NSError * )inError {
    [ mCallback onContactsFound:inResults error:inError ];
    [ mProvider requestComplete:self ];
}

-( void )requestWithFQL {
    NSString * theQueries = [ self createQueries ];
    [ mFacebook requestWithMethodName:( NSString * )sFacebookMethodMultiQuery
                           andParams:[ NSMutableDictionary dictionaryWithObjectsAndKeys:theQueries, sQueries, nil ]
                       andHttpMethod:( NSString * )sHttpMethodPOST
                         andDelegate:self ];
}

@end
