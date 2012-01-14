#import <Foundation/Foundation.h>

#import "FBConnect.h"

@protocol FacebookAuthoriserCallback;

@interface FacebookAuthoriser : NSObject < FBSessionDelegate > {
    @private
    Facebook * mFacebook;
    id< FacebookAuthoriserCallback > mCallback;
}

-( void )authorise;
-( id )initWithFacebook:( Facebook * )inFacebook
            andCallback:( id< FacebookAuthoriserCallback > )inCallback;

@end

@protocol FacebookAuthoriserCallback < NSObject >

-( void )onAuthorise:( BOOL )isAuthorised error:( NSError * )inError;

@end