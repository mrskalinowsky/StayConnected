#import "TwitterCreateNewContacts.h"

@implementation TwitterCreateNewContacts

static NSString * const sURLCreateNewContact = @"http://api.twitter.com/1/friendships/create.json";
static NSString * const sKeyUserId           = @"user_id";

-( void )createNewContacts:( NSArray * )inContactIds error:( NSError ** )outError {
    for ( NSString * theContactId in inContactIds ) {
        [ mRequestor httpPost:sURLCreateNewContact
                   parameters:[ NSArray arrayWithObjects:sKeyUserId, theContactId, nil ]
                        error:outError ];
        if ( outError[ 0 ] != nil ) {
            break;
        }
    }
}

@end