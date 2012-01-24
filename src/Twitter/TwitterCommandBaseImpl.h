#import <Foundation/Foundation.h>

#import "OAuthRequestor.h"

@interface TwitterCommandBaseImpl : NSObject {
    @protected
    OAuthRequestor * mRequestor;
}

-( id )initWithRequestor:( OAuthRequestor * )inRequestor;

@end