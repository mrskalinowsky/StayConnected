#import <Foundation/Foundation.h>

@protocol ContactsProvider;

@interface ContactsProviderManager : NSObject {
    @private
    NSMutableDictionary * mProviders;
}

+( id )instance;

-( BOOL )canOpenURL:( NSURL * )inURL;

-( id< ContactsProvider > )getProvider:( NSString * )inName;

-( BOOL )openURL:( NSURL * )inURL;

@end
