#import <Foundation/Foundation.h>

#import "OAuthRequestor.h"

@protocol SendMessageCallback;

@interface TwitterSendMessage : NSObject< OAuthRequestCallback > {
    @private
    TwitterContactsProvider * mProvider;
    NSArray * mContacts;
    NSString * mMessage;
    id< SendMessageCallback > mCallback;
    NSMutableString * mErrors;
    int mRemainingRequestCount;
}

-( id )initWithProvider:( TwitterContactsProvider * )inProvider
               contacts:( NSArray * )inContacts
                message:( NSString * )inMessage
               callback:( id< SendMessageCallback > )inCallback;

-( void )sendMessage;


@end

