#import "ContactsProvider.h"
#import "TwitterConstants.h"
#import "TwitterContact.h"
#import "TwitterContactsProvider.h"
#import "TwitterGetContacts.h"
#import "TwitterRequestExecutor.h"

@interface TwitterGetContacts ( PrivateMethods )

-( void )addContactFromResult:( NSDictionary * )inResult
                     contacts:( NSMutableDictionary * )inContacts;
-( NSArray * )contactIdsToLookupArray:( NSArray * )inContactIds;
-( void )get100Contacts:( NSString * )inContactIds error:( NSError ** )outError;
-( void )getContactIds:( NSError ** )outError;
-( void )requestComplete:( NSError * )inError;

@end

@implementation TwitterGetContacts

static const NSString * const sURLFriendsIds   = @"http://api.twitter.com/1/friends/ids.json";
static const NSString * const sURLUsersLookup  = @"http://api.twitter.com/1/users/lookup.json";

static const NSString * const sKeyIds          = @"ids";
static const NSString * const sKeyStringifyIds = @"stringify_ids";
static const NSString * const sKeyUserId       = @"user_id";

static const NSString * const sValueStringifyIds = @"true";

-( void )dealloc {
    [ mResults release ];
    [ mCallback release ];
    [ mAttributes release ];
    [ mContactIds release ];
    [ super dealloc ];
}

-( void )getContacts {
    NSError * theError = nil;
    if ( mContactIds == nil ) {
        [ self getContactIds:&theError ];
        if ( theError != nil ) {
            [ self requestComplete:theError ];
            return;
        }
    }
    for ( NSString * theContactIds in mContactIds ) {
        [ self get100Contacts:theContactIds error:&theError ];
        if ( theError != nil ) {
            break;
        }
    }
    [ self requestComplete:theError ];
}

-( id )initWithProvider:( TwitterContactsProvider * )inProvider
             contactIds:( NSArray * )inContactIds
               attributes:( NSArray * )inAttributes
                 callback:( id< ContactsCallback > )inCallback {
    self = [ super initWithProvider:inProvider ];
    if ( self != nil ) {
        mContactIds = [ inContactIds retain ];
        mContactIds = [ [ self contactIdsToLookupArray:inContactIds ] retain ];
        mAttributes = [ inAttributes retain ];
        mCallback = [ inCallback retain ];
        mResults = [ [ NSMutableDictionary alloc ] init ];
    }
    return self;
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

-( void )get100Contacts:( NSString * )inContactIds error:( NSError ** )outError {
    TwitterRequestExecutor * theRequest = [ [ TwitterRequestExecutor alloc ] init ];
    [ self setBusy:TRUE ];
    [ theRequest
     execute:( NSString * )sURLUsersLookup
     parameters:[ NSDictionary dictionaryWithObject:inContactIds
                                             forKey:( NSString * )sKeyUserId ]
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

-( void )getContactIds:( NSError ** )outError {
    TwitterRequestExecutor * theRequest = [ [ TwitterRequestExecutor alloc ] init ];
    [ self setBusy:TRUE ];
    [ theRequest
        execute:( NSString * )sURLFriendsIds
     parameters:[ NSDictionary dictionaryWithObject:( NSString * )sValueStringifyIds
                                             forKey:( NSString * )sKeyStringifyIds ]
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
                   mContactIds =
                       [ self contactIdsToLookupArray:
                          [ theResults valueForKey:( NSString * )sKeyIds ] ];
                   if ( mContactIds != nil ) {
                       [ mContactIds retain ];
                   }
               }
           }
           [ self setBusy:FALSE ];
       } ];
    [ self waitWhileBusy ];
    [ theRequest release ];
}

-( void )requestComplete:inError {
    [ mCallback onContactsFound:inError == nil ? [ mResults allValues ] : nil
                          error:inError ];
    [ self requestComplete ];
}

@end
