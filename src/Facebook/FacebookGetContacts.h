#import <Foundation/Foundation.h>

#import "FacebookAuthoriser.h"
#import "FBConnect.h"

@class FacebookContactsProvider;
@protocol ContactsCallback;

@interface FacebookGetContacts : NSObject< FacebookAuthoriserCallback, FBRequestDelegate > {
    @private
    FacebookAuthoriser * mAuthoriser;
    FacebookContactsProvider * mProvider;
    Facebook * mFacebook;
    NSArray * mContactIds;
    NSString * mColumns;
    id< ContactsCallback > mCallback;
}

-( void )getContacts;

-( id )initWithProvider:( FacebookContactsProvider * )inProvider
               facebook:( Facebook * )inFacebook
             contactIds:( NSArray * )inContactIds
             attributes:( NSArray * )inAttributes
               callback:( id< ContactsCallback > )inCallback;

@end