#import <Foundation/Foundation.h>

#import "TwitterRequestUtil.h"

@class TwitterContactsProvider;
@protocol ContactsCallback;

@interface TwitterGetContacts : TwitterRequestUtil {
    @private
    NSArray * mContactIds;
    NSArray * mAttributes;
    id< ContactsCallback > mCallback;
    NSMutableDictionary * mResults;
}

-( void )getContacts;

-( id )initWithProvider:( TwitterContactsProvider * )inProvider
             contactIds:( NSArray * )inContactIds
               attributes:( NSArray * )inAttributes
                 callback:( id< ContactsCallback > )inCallback;

@end