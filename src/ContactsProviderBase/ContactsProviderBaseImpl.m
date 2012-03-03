#import "ContactsProviderBaseImpl.h"

@interface ContactsProviderBaseImpl ( PrivateMethds )

-( void )releasingCreateNewContacts:( CreateNewContactsArgs * )inArgs;
-( void )releasingGetContacts:( GetContactsArgs * )inArgs;
-( void )releasingSearchForContacts:( SearchForContactsArgs * )inArgs;
-( void )releasingSendMessage:( SendMessageArgs * )inArgs;

@end

@implementation ContactsProviderBaseImpl

-( BOOL )canOpenURL:( NSURL * )inURL {
    NSLog(@"ContactsProviderBaseImpl.canOpenURL:%@ not implemented", inURL);
    return FALSE;
}

-( void )createNewContacts:( NSArray * )inContacts
                   message:( NSString * )inMessage
                  callback:( id< NewContactsCallback > )inCallback {
    CreateNewContactsArgs * theArgs = [ [ CreateNewContactsArgs alloc ] init ];
    theArgs.contacts = inContacts;
    theArgs.message  = inMessage;
    theArgs.callback = inCallback;
    [ self performSelectorInBackground:@selector( releasingCreateNewContacts: )
                            withObject:theArgs ];
    // theArgs is released by the "releaseingXXX" selector below
}

-( void )getContacts:( NSArray * )inContactIds
          attributes:( NSArray * )inAttributes
            callback:( id< ContactsCallback > )inCallback {
    GetContactsArgs * theArgs = [ [ GetContactsArgs alloc ] init ];
    theArgs.contactIds = inContactIds;
    theArgs.attributes = inAttributes;
    theArgs.callback   = inCallback;
    [ self performSelectorInBackground:@selector( releasingGetContacts: )
                            withObject:theArgs ];
    // theArgs is released by the "releaseingXXX" selector below
}

-( void )searchForContacts:( NSString * )inSearchString
                attributes:( NSArray * )inAttributes
                  callback:( id< ContactsCallback > )inCallback {
    SearchForContactsArgs * theArgs = [ [ SearchForContactsArgs alloc ] init ];
    theArgs.searchString = inSearchString;
    theArgs.attributes   = inAttributes;
    theArgs.callback     = inCallback;
    [ self performSelectorInBackground:@selector( releasingSearchForContacts: )
                            withObject:theArgs ];
    // theArgs is released by the "releaseingXXX" selector below
}

-( void )sendMessage:( NSArray * )inContacts
             message:( NSString * )inMessage
            callback:( id< SendMessageCallback > )inCallback {
    SendMessageArgs * theArgs = [ [ SendMessageArgs alloc ] init ];
    theArgs.contacts = inContacts;
    theArgs.message  = inMessage;
    theArgs.callback = inCallback;
    [ self performSelectorInBackground:@selector( releasingSendMessage: )
                            withObject:theArgs ];
    // theArgs is released by the "releaseingXXX" selector below
}

-( NSString * )getName {
    NSLog( @"getName not implemented" );
    return nil;
}

-( BOOL )openURL:( NSURL * )inURL {
    NSLog( @"openURL not implemented" );
    return FALSE;
}

-( void )backgroundCreateNewContacts:( CreateNewContactsArgs * )inArgs {
    NSLog( @"backgroundCreateNewContacts not implemented" );
    [ inArgs release ];
}

-( void )backgroundGetContacts:( GetContactsArgs * )inArgs {
    NSLog( @"backgroundGetContacts not implemented" );
    [ inArgs release ];
}

-( void )backgroundSearchForContacts:( SearchForContactsArgs * )inArgs {
    NSLog( @"backgroundSearchForContacts not implemented" );
    [ inArgs release ];
}

-( void )backgroundSendMessage:( SendMessageArgs * )inArgs {
    NSLog( @"backgroundSendMessage not implemented" );
    [ inArgs release ];
}

@end

@implementation ContactsProviderBaseImpl ( PrivateMethds )

-( void )releasingCreateNewContacts:( CreateNewContactsArgs * )inArgs {
    [ self backgroundCreateNewContacts:inArgs ];
    [ inArgs release ];
}

-( void )releasingGetContacts:( GetContactsArgs * )inArgs {
    [ self backgroundGetContacts:inArgs ];
    [ inArgs release ];
}

-( void )releasingSearchForContacts:( SearchForContactsArgs * )inArgs {
    [ self backgroundSearchForContacts:inArgs ];
    [ inArgs release ];
}

-( void )releasingSendMessage:( SendMessageArgs * )inArgs {
    [ self backgroundSendMessage:inArgs ] ;
    [ inArgs release ];
}

@end

@implementation CreateNewContactsArgs
@synthesize contacts = mContacts;
@synthesize message  = mMessage;
@synthesize callback = mCallback;
@end

@implementation GetContactsArgs
@synthesize contactIds = mContactIds;
@synthesize attributes = mAttributes;
@synthesize callback   = mCallback;
@end

@implementation SearchForContactsArgs
@synthesize searchString = mSearchString;
@synthesize attributes   = mAttributes;
@synthesize callback     = mCallback;
@end

@implementation SendMessageArgs
@synthesize contacts = mContacts;
@synthesize message  = mMessage;
@synthesize callback = mCallback;
@end