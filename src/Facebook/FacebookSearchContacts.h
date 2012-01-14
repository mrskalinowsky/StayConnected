#import <Foundation/Foundation.h>

#import "FacebookAuthoriser.h"
#import "FBConnect.h"

@class FacebookContactsProvider;
@class Facebook;
@protocol ContactsCallback;

@interface FacebookSearchContacts : NSObject< FacebookAuthoriserCallback, FBRequestDelegate > {
    @private
    FacebookAuthoriser * mAuthoriser;
    FacebookContactsProvider * mProvider;
    Facebook * mFacebook;
    NSString * mSearchString;
    NSString * mFields;
    id< ContactsCallback > mCallback;
    NSMutableArray * mResults;
}

-( void )searchContacts;

-( id )initWithProvider:( FacebookContactsProvider * )inProvider
               facebook:( Facebook * )inFacebook
           searchString:( NSString * )inSearchString
             attributes:( NSArray * )inAttributes
               callback:( id< ContactsCallback > )inCallback;

@end
