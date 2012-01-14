#import "TwitterConstants.h"
#import "TwitterContactsProvider.h"
#import "TwitterCreateNewContacts.h"
#import "TwitterGetContacts.h"
#import "TwitterSearchContacts.h"
#import "TwitterSendMessage.h"

@implementation TwitterContactsProvider

// ContactsProvider Implementation
-( void )createNewContacts:( NSArray * )inContacts
                   message:( NSString * )inMessage
                  callback:( id< NewContactsCallback > )inCallback {
    TwitterCreateNewContacts * theCreateNewContacts =
    [ [ TwitterCreateNewContacts alloc ] initWithProvider:self
                                               contactIds:inContacts
                                                 callback:inCallback ];
    [ theCreateNewContacts createNewContacts ];
    // theCreateNewContacts is released later in requestComplete
}

-( void )getContacts:( NSArray * )inContactIds
          attributes:( NSArray * )inAttributes
            callback:( id< ContactsCallback > )inCallback {
    TwitterGetContacts * theGetContacts =
    [ [ TwitterGetContacts alloc ] initWithProvider:self
                                         contactIds:inContactIds
                                         attributes:inAttributes
                                           callback:inCallback ];
    [ theGetContacts getContacts ];
    // theGetContacts is released later in requestComlete
}

-( NSString * )getName {
    return ( NSString * )sTwitterProviderName;
}

-( BOOL )openURL:( NSURL * )inURL {
    return FALSE;
}

-( void )requestComplete:( id )inRequestObject {
    [ inRequestObject release ];
}

-( void )searchForContacts:( NSString * )inSearchString
                attributes:( NSArray * )inAttributes
                  callback:( id< ContactsCallback > )inCallback {
    TwitterSearchContacts * theSearchContacts =
    [ [ TwitterSearchContacts alloc ] initWithProvider:self
                                         searchString:inSearchString
                                         attributes:inAttributes
                                           callback:inCallback ];
    [ theSearchContacts searchContacts ];
    // theSearchContacts is released later in requestComlete
}

-( void )sendMessage:( NSArray * )inContacts
             message:( NSString * )inMessage
            callback:( id< SendMessageCallback > )inCallback {
    TwitterSendMessage * theSendMessage =
    [ [ TwitterSendMessage alloc ] initWithProvider:self
                                           contacts:inContacts
                                            message:inMessage
                                           callback:inCallback ];
    [ theSendMessage sendMessage ];
    // theSendMessage is released later in requestComlete
}
@end
