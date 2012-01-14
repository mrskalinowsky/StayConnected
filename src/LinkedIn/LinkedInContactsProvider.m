#import "LinkedInContactsProvider.h"
#import "LinkedInConstants.h"

@implementation LinkedInContactsProvider

-( NSString * )getName {
    return ( NSString * )sLinkedInProviderName;
}

-( void )requestComplete:( id )inRequestObject {
    [ inRequestObject release ];
}

// ContactsProvider Implementation
-( void )createNewContacts:( NSArray * )inContacts
                   message:( NSString * )inMessage
                  callback:( id< NewContactsCallback > )inCallback {
    NSLog(@"LinkedInContactsProvider.createNewContacts not implemented");
}

-( void )getContacts:( NSArray * )inContactIds
          attributes:( NSArray * )inAttributes
            callback:( id< ContactsCallback > )inCallback {
    NSLog(@"LinkedInContactsProvider.getContacts not implemented");
}

-( BOOL )openURL:( NSURL * )inURL {
    return FALSE;
}

-( void )searchForContacts:( NSString * )inSearchString
                attributes:( NSArray * )inAttributes
                  callback:( id< ContactsCallback > )inCallback {
    NSLog(@"LinkedInContactsProvider.searchForContacts not implemented");
}

-( void )sendMessage:( NSArray * )inContacts
             message:( NSString * )inMessage
            callback:( id< SendMessageCallback > )inCallback {
    NSLog(@"LinkedInContactsProvider.sendMessage not implemented");
}

@end
