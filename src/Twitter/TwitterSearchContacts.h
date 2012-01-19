#import <Foundation/Foundation.h>

#import "OAuthRequestor.h"

@class TwitterContactsProvider;

@interface TwitterSearchContacts : NSObject< OAuthRequestCallback > {
    @private
    TwitterContactsProvider * mProvider;
    NSString * mSearchString;
    NSArray * mAttributes;
    id< ContactsCallback > mCallback;
}

-( id )initWithProvider:( TwitterContactsProvider * )inProvider
           searchString:( NSString * )inSearchString
             attributes:( NSArray * )inAttributes
               callback:( id< ContactsCallback > )inCallback;

-( void )searchContacts;

@end
