#import <Foundation/Foundation.h>

#import "ContactsProviderBaseImpl.h"

@class OAuthRequestor;

@interface TwitterContactsProvider : ContactsProviderBaseImpl {
    @private
    OAuthRequestor * mOAuthRequestor;
}

@end