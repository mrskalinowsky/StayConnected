#import <Foundation/Foundation.h>

#import "ContactsProvider.h"

@class CreateNewContactsArgs;
@class GetContactsArgs;
@class SearchForContactsArgs;
@class SendMessageArgs;

@interface ContactsProviderBaseImpl : NSObject < ContactsProvider >

// "Concrete" provides should extend this class and provide their own getName, 
// openURL and the following methods
-( void )backgroundCreateNewContacts:( CreateNewContactsArgs * )inArgs;
-( void )backgroundGetContacts:( GetContactsArgs * )inArgs;
-( void )backgroundSearchForContacts:( SearchForContactsArgs * )inArgs;
-( void )backgroundSendMessage:( SendMessageArgs * )inArgs;

@end

@interface CreateNewContactsArgs : NSObject {
    @private
    NSArray *                 mContacts;
    NSString *                mMessage;
    id< NewContactsCallback > mCallback;
}

@property ( retain ) NSArray *                 contacts;
@property ( retain ) NSString *                message;
@property ( retain ) id< NewContactsCallback > callback;

@end

@interface GetContactsArgs : NSObject {
    @private
    NSArray *              mContactIds;
    NSArray *              mAttributes;
    id< ContactsCallback > mCallback;
}

@property ( retain ) NSArray *              contactIds;
@property ( retain ) NSArray *              attributes;
@property ( retain ) id< ContactsCallback > callback;

@end

@interface SearchForContactsArgs : NSObject {
    @private
    NSString *             mSearchString;
    NSArray *              mAttributes;
    id< ContactsCallback > mCallback;
}

@property ( retain ) NSString *             searchString;
@property ( retain ) NSArray *              attributes;
@property ( retain ) id< ContactsCallback > callback;

@end

@interface SendMessageArgs : NSObject {
    @private
    NSArray *                 mContacts;
    NSString *                mMessage;
    id< SendMessageCallback > mCallback;
}

@property ( retain ) NSArray *                 contacts;
@property ( retain ) NSString *                message;
@property ( retain ) id< SendMessageCallback > callback;
@end