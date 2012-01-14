#import <Foundation/Foundation.h>

#import "TwitterRequestUtil.h"

@class TwitterContactsProvider;
@protocol NewContactsCallback;

@interface TwitterCreateNewContacts : TwitterRequestUtil {
    @private
    NSArray * mContactIds;
    id< NewContactsCallback > mCallback;
}

-( void )createNewContacts;

-( id )initWithProvider:( TwitterContactsProvider * )inProvider
             contactIds:( NSArray * )inContactIds
               callback:( id< NewContactsCallback > )inCallback;

@end

