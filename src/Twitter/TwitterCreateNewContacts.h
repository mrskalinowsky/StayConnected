#import <Foundation/Foundation.h>

#import "OAuthRequestor.h"

@protocol NewContactsCallback;

@interface TwitterCreateNewContacts : NSObject< OAuthRequestCallback > {
    @private
    TwitterContactsProvider * mProvider;
    NSArray * mContactIds;
    id< NewContactsCallback > mCallback;
    NSMutableString * mErrors;
    int mRemainingRequestCount;
}

-( void )createNewContacts;

-( id )initWithProvider:( TwitterContactsProvider * )inProvider
             contactIds:( NSArray * )inContactIds
               callback:( id< NewContactsCallback > )inCallback;

@end

