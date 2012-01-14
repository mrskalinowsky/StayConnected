#import <Foundation/Foundation.h>

#import "TwitterRequestUtil.h"

@class TwitterContactsProvider;
@protocol SendMessageCallback;

@interface TwitterSendMessage : TwitterRequestUtil {
    @private
    NSArray * mContacts;
    NSString * mMessage;
    id< SendMessageCallback > mCallback;
}

-( id )initWithProvider:( TwitterContactsProvider * )inProvider
               contacts:( NSArray * )inContacts
                message:( NSString * )inMessage
               callback:( id< SendMessageCallback > )inCallback;

-( void )sendMessage;


@end

