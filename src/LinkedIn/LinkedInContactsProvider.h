
#import <Foundation/Foundation.h>
#import "ContactsProviderBaseImpl.h"

@class OAuthRequestor;

@interface LinkedInContactsProvider : ContactsProviderBaseImpl {
    @private
    OAuthRequestor * mOAuthRequestor;
}

@end
