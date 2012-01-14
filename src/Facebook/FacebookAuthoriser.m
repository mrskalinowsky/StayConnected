#import "Constants.h"
#import "FacebookAuthoriser.h"
#import "FacebookConstants.h"
#import "StayConnectedError.h"

@implementation FacebookAuthoriser

-( void )authorise {
    if ( [ mFacebook isSessionValid ] ) {
        [ mCallback onAuthorise:TRUE error:nil ];
    } else {
        NSArray * thePermissions =
            [ [ NSArray alloc ]
             initWithObjects:sFacebookPermissionBirthday,
                             sFacebookPermissionGroups,
                             sFacebookPermissionsHometown,
                             sFacebookPermissionReadStream,
                             sFacebookPermissionWebsite,
                             sFacebookPermissionWork,
                             nil ];
        [ mFacebook authorize:thePermissions ];
        [ thePermissions release ];
    }
}

-( void )dealloc {
    [ mCallback release ];
    [ mFacebook release ];
    [ super dealloc ];
}

-( id )initWithFacebook:( Facebook * )inFacebook
            andCallback:(id< FacebookAuthoriserCallback > )inCallback {
    self = [ super init ];
    if ( self != nil ) {
        mFacebook = [ inFacebook retain ];
        mFacebook.sessionDelegate = self;
        mCallback = [ inCallback retain ];
    }
    return self;
}

// FBSessionDelegate Implementation
-( void )fbDidLogin {
    NSUserDefaults * theDefaults = [ NSUserDefaults standardUserDefaults ];
    [ theDefaults setObject:[ mFacebook accessToken ] forKey:( NSString * )sFacebookKeyFBAccess ];
    [ theDefaults setObject:[ mFacebook expirationDate ] forKey:( NSString * )sFacebookKeyFBExpirationDate ];
    [ theDefaults synchronize ];
    [ mCallback onAuthorise:TRUE error:nil ];
}

-( void )fbDidNotLogin:( BOOL )inCancelled {
    NSError * theError;
    if ( inCancelled ) {
        theError = [ [ NSError alloc ]
            initWithCode:ErrFacebookLoginCanceled
                    description:@"err_facebook_login"
                    reason:@"err_facebook_login_canceled" ];
    } else {
        theError = [ [ NSError alloc ]
            initWithCode:ErrFacebookLoginFailed
                    description:@"err_facebook_login"
                    reason:@"err_facebook_login_failed" ];
                    }
    [ mCallback onAuthorise:FALSE error:[ theError autorelease ] ];
}

@end
