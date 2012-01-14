#import "ContactsProvider.h"
#import "FacebookContact.h"
#import "FacebookContactsProvider.h"
#import "FacebookConstants.h"
#import "FacebookSearchContacts.h"
#import "FBConnect.h"

static const NSString * const sGraphPath = @"search";

static const NSString * const sKeyData   = @"data";
static const NSString * const sKeyFields = @"fields";
static const NSString * const sKeyLimit  = @"limit";
static const NSString * const sKeyNext   = @"next";
static const NSString * const sKeyOffset = @"offset";
static const NSString * const sKeyPaging = @"paging";
static const NSString * const sKeyQ      = @"q";
static const NSString * const sKeyType   = @"type";

static const NSString * sValueLimit = @"500";
static const NSString * const sValueUser = @"user";

static const NSString * const sPagingSep = @"&";

@interface FacebookSearchContacts ( PrivateMethods )

-( NSString * )offsetFromResults:( NSDictionary * )inResults;
-( void )requestComplete:( NSArray * )inResults error:( NSError * )inError;
-( void )requestWithGraphPath:( NSString * )inOffset;
-( NSArray * )resultsToContacts;

@end

@implementation FacebookSearchContacts

-( void )dealloc {
    [ mResults release ];
    [ mCallback release ];
    [ mFields release ];
    [ mSearchString release ];
    [ mFacebook release ];
    [ mProvider release ];
    [ super dealloc ];
}

-( id )initWithProvider:( FacebookContactsProvider * )inProvider
               facebook:( Facebook * )inFacebook
           searchString:( NSString * )inSearchString
             attributes:( NSArray * )inAttributes
               callback:( id< ContactsCallback > )inCallback {
    self = [ super init ];
    if ( self != nil ) {
        mProvider = [ inProvider retain ];
        mFacebook = [ inFacebook retain ];
        mSearchString = [ inSearchString retain ];
        mFields = [ [ FacebookConstants attributesToFields:inAttributes ] retain ];
        [ mFields retain ];
        mCallback = [ inCallback retain ];
        mResults = [ [ NSMutableArray alloc ] init ];
    }
    return self;
}

-( void )searchContacts {
    mAuthoriser =
    [ [ FacebookAuthoriser alloc ] initWithFacebook:mFacebook
                                        andCallback:self ];
    [ mAuthoriser authorise ];
}

-( void )onAuthorise:( BOOL )isAuthorised error:( NSError * )inError {
    [ mAuthoriser release ];
    if ( inError == nil ) {
        [ self requestWithGraphPath:@"0" ];
    } else {
        [ self requestComplete:nil error:inError ];
    }
}

// FBRequestDelegate Implementation
- (void)request:( FBRequest * )inRequest didFailWithError:( NSError * )inError {
    [ self requestComplete:nil error:inError ];
}

- (void)request:( FBRequest * )inRequest didLoad:( id )inResult {
    NSDictionary * theResults = ( NSDictionary * )inResult;
    NSArray * theData = [ theResults valueForKey:( NSString * )sKeyData ];
    [ mResults addObjectsFromArray:theData ];
    if ( [ theData count ] != 0 ) {
        NSString * theOffset = [ self offsetFromResults:theResults ];
        if ( theOffset != nil ) {
            [ self requestWithGraphPath:theOffset ];
        }
    } else {
        NSArray * theContacts = [ [ self resultsToContacts ] retain ];
        [ self requestComplete:theContacts error:nil ];
        [ theContacts release ];
    }
}
@end

@implementation FacebookSearchContacts ( PrivateMethods )

-( NSString * )offsetFromResults:( NSDictionary * )inResults {
    NSDictionary * thePagingData = [ inResults valueForKey:( NSString * )sKeyPaging ];
    if ( thePagingData == nil ) {
        return nil;
    }
    NSString * theNextData = [ thePagingData valueForKey:( NSString * )sKeyNext ];
    if ( theNextData == nil ) {
        return nil;
    }
    NSRange theRange = [ theNextData rangeOfString:( NSString * )sKeyOffset ];
    if ( theRange.location == NSNotFound ) {
        return nil;
    }
    NSString * theOffset = [ theNextData substringFromIndex:theRange.location + theRange.length + 1 ];
    theRange = [ theOffset rangeOfString:( NSString * )sPagingSep ];
    if ( theRange.location != NSNotFound ) {
        theOffset = [ theOffset substringToIndex:theRange.location ];
    }
    return theOffset;
}

-( void )requestComplete:( NSArray * )inResults error:( NSError * )inError {
    [ mCallback onContactsFound:inResults error:inError ];
    [ mProvider requestComplete:self ];
}

-( void )requestWithGraphPath:( NSString * )inOffset {
    NSMutableDictionary * theParams = [ [ NSMutableDictionary alloc ] init ];
    [ theParams setValue:mSearchString forKey:( NSString * )sKeyQ ];
    [ theParams setValue:( NSString * )sValueUser forKey:( NSString * )sKeyType ];
    [ theParams setValue:inOffset forKey:( NSString * )sKeyOffset ];
    [ theParams setValue:( NSString * )sValueLimit forKey:( NSString * )sKeyLimit ];
    [ theParams setValue:mFields forKey:( NSString * )sKeyFields ];
    [ mFacebook requestWithGraphPath:( NSString * )sGraphPath
                           andParams:theParams
                         andDelegate:self ];
    [ theParams release ];
}

-( NSArray * )resultsToContacts {
    NSMutableArray * theContacts = [ [ NSMutableArray alloc ] init ];
    for ( NSDictionary * theResult in mResults ) {
        FacebookContact * theContact =
        [ [ FacebookContact alloc ] initWithId:[ theResult valueForKey:( NSString * )sFacebookFieldId ]
                                        fields:theResult
                              fieldsAreColumns:FALSE ];
        [ theContacts addObject:theContact ];
        [ theContact release ];
    }
    return [ theContacts autorelease ];
}

@end
