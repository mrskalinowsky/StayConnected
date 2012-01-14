#import "ContactsProvider.h"
#import "TwitterContactsProvider.h"
#import "TwitterRequestExecutor.h"
#import "TwitterCreateNewContacts.h"

@interface TwitterCreateNewContacts ( PrivateMethods )

-( void )createNewContact:( NSString * )inContactId
                    error:( NSError ** )outError;
-( void )requestComplete:( NSError * )inError;

@end

@implementation TwitterCreateNewContacts

static const NSString * const sURLCreateNewContact = @"http://api.twitter.com/1/friendships/create.json";
static const NSString * const sKeyUserId = @"user_id";

-( void )dealloc {
    [ mCallback release ];
    [ mContactIds release ];
    [ super dealloc ];
}

-( id )initWithProvider:( TwitterContactsProvider * )inProvider
             contactIds:( NSArray * )inContactIds
               callback:( id< NewContactsCallback > )inCallback {
    self = [ super initWithProvider:inProvider ];
    if ( self != nil ) {
        mContactIds = [ inContactIds retain ];
        mCallback = [ inCallback retain ];
    }
    return self;
}

-( void )createNewContacts {
    NSError * theError = nil;
    for ( NSString * theContactId in mContactIds ) {
        [ self createNewContact:theContactId error:&theError ];
        if ( theError != nil ) {
            break;
        }
    }
    [ self requestComplete:theError ];
}

@end

@implementation TwitterCreateNewContacts ( PrivateMethods )

-( void )createNewContact:( NSString * )inContactId
                    error:( NSError ** )outError {
    TwitterRequestExecutor * theRequest = [ [ TwitterRequestExecutor alloc ] init ];
    [ self setBusy:TRUE ];
    [ theRequest
     execute:( NSString * )sURLCreateNewContact
     parameters:[ NSDictionary dictionaryWithObject:inContactId
                                             forKey:( NSString * )sKeyUserId ]
     method:TWRequestMethodPOST
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
             }
         }
         [ self setBusy:FALSE ];
     } ];
    [ self waitWhileBusy ];
    [ theRequest release ];
}

-( void )requestComplete:inError {
    [ mCallback onContactsRequested:inError ];
    [ self requestComplete ];
}

@end