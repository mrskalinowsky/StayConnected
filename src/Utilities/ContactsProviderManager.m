#import "ContactsProviderManager.h"
#import "FacebookContactsProvider.h"
#import "LinkedInContactsProvider.h"
#import "TwitterContactsProvider.h"

static ContactsProviderManager * sInstance = nil;

@implementation ContactsProviderManager

+ ( id )allocWithZone:( NSZone * )inZone { return [ sInstance retain ]; }

+ ( id )copyWithZone:( NSZone * )inZone { return self; }

+ ( id )instance {
    @synchronized( self ) {
        if ( sInstance == nil ) {
            sInstance = [ [ super allocWithZone:nil ] init ];
        }
    }
    return sInstance;
}

- ( id )autorelease { return self; }

-( BOOL )canOpenURL:( NSURL * )inURL {
    BOOL canOpenURL = FALSE;
    for ( id< ContactsProvider > theProvider in [ mProviders allValues ] ) {
        if ( [ theProvider canOpenURL:inURL ] ) {
            canOpenURL = TRUE;
            break;
        }
    }
    return canOpenURL;
}

- ( void )dealloc {
    [ mProviders release ];
    [ super dealloc ];
}

- ( id< ContactsProvider > )getProvider:( NSString * )inName {
    return [ mProviders valueForKey:inName ];
}

- ( id )init {
    self = [ super init ];
    if ( self != nil ) {
        mProviders = [ [ NSMutableDictionary alloc ] init ];
        id< ContactsProvider > theProvider = [ [ FacebookContactsProvider alloc ] init ];
        [ mProviders setObject:theProvider forKey:[ theProvider getName ] ];
        [ theProvider release ];
        theProvider = [ [ LinkedInContactsProvider alloc ] init ];
        [ mProviders setObject:theProvider forKey:[ theProvider getName ] ];
        [ theProvider release ];
        theProvider = [ [ TwitterContactsProvider alloc ] init ];
        [ mProviders setObject:theProvider forKey:[ theProvider getName ] ];
        [ theProvider release ];
    }
    return self;
}

-( BOOL )openURL:( NSURL * )inURL {
    BOOL theRC = FALSE;
    for ( id< ContactsProvider > theProvider in [ mProviders allValues ] ) {
        if ( [ theProvider canOpenURL:inURL ] ) {
            theRC = [ theProvider openURL:inURL ];
            break;
        }
    }
    return theRC;
}

- ( oneway void )release {}

- ( id )retain {
    return self;
}

- ( unsigned )retainCount {
    return UINT_MAX;
}

@end
