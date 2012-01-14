#import <Foundation/Foundation.h>

#import "TwitterRequestUtil.h"

@class TwitterContactsProvider;
@protocol ContactsCallback;

@interface TwitterSearchContacts : TwitterRequestUtil {
    @private
    NSString * mSearchString;
    NSArray * mAttributes;
    id< ContactsCallback > mCallback;
    NSMutableDictionary * mResults;
}

-( id )initWithProvider:( TwitterContactsProvider * )inProvider
           searchString:( NSString * )inSearchString
             attributes:( NSArray * )inAttributes
               callback:( id< ContactsCallback > )inCallback;

-( void )searchContacts;

@end
