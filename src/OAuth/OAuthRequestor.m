#import "Constants.h"
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OAServiceTicket.h"
#import "OAToken.h"
#import "OAuthRequestor.h"
#import "OAuthURLConnection.h"
#import "StayConnectedError.h"

static NSString * sCallbackPrefix = @"x-com-mpoauth-mobile://success";
static NSString * sEquals         = @"=";
static NSString * sMethodGET      = @"GET";
static NSString * sMethodPOST     = @"POST";
static NSString * sParamSep       = @"&";
static NSString * sParamCallback  = @"oauth_callback";
static NSString * sParamToken     = @"oauth_token";
static NSString * sParamVerifier  = @"oauth_verifier";
static NSString * sURLSep         = @"?";

@interface OAuthRequestor ( PrivateMethods )

-( BOOL )authorise:( NSError ** )outError;
-( BOOL )getToken:( NSString * )inTokenURL
            error:( NSError ** )outError
      errorReason:( NSString * )inErrorReason;
-( NSDictionary * )httpRequest:( NSString * )inMethod
                           url:( NSString * )inURL
                    parameters:( NSArray * )inParameters
                         error:( NSError ** )outError;
-( BOOL )isLoggedIn;
-( BOOL )login:( NSError ** )outError;
-( OAuthURLResponse * )oauthRequest:( NSString * )inMethod
                                url:( NSString * )inURL
                         parameters:( NSArray * )inParameters;
-( void )setCallbackURL:( OAMutableURLRequest * )inRequest;
-( NSArray * )stringsToParameters:( NSArray * )inStrings;

@end

@implementation OAuthRequestor

-( void )dealloc {
    [ mCallbackURL release ];
    [ mAccessTokenURL release ];
    [ mAuthoriseURL release ];
    [ mRequestTokenURL release ];
    [ mToken release ];
    [ mConsumer release ];
    [ super dealloc ];
}

-( NSDictionary * )httpGet:( NSString * )inURL
                parameters:( NSArray * )inParameters
                     error:( NSError ** )outError {
    return [ self httpRequest:sMethodGET url:inURL parameters:inParameters error:outError ];
}

-( NSDictionary * )httpPost:( NSString * )inURL
                 parameters:( NSArray * )inParameters
                      error:( NSError ** )outError {
    return [ self httpRequest:sMethodPOST url:inURL parameters:inParameters error:outError ];
}

-( id )initWithKey:( NSString * )inKey
            secret:( NSString * )inSecret
   requestTokenURL:( NSString * )inRequestTokenURL
      authoriseURL:( NSString * )inAuthoriseURL
    accessTokenURL:( NSString * )inAccessTokenURL
    callbackSuffix:( NSString * )inCallbackSuffix {
    self = [ super init ];
    if ( self != nil ) {
        mConsumer  = [ [ OAConsumer alloc ] initWithKey:inKey secret:inSecret ];
        mRequestTokenURL = [ inRequestTokenURL retain ];
        mAuthoriseURL    = [ inAuthoriseURL retain ];
        mAccessTokenURL  = [ inAccessTokenURL retain ];
        mCallbackURL     =
        [ [ NSString stringWithFormat:@"%@%@",
           sCallbackPrefix, inCallbackSuffix ] retain ];
        mToken =
        [ [ OAToken alloc ]
         initWithUserDefaultsUsingServiceProviderName:mAccessTokenURL
                                               prefix:sParamToken ];
    }
    return self;
}

-( BOOL )openURL:( NSURL * )inURL {
    if ( ! [ [ inURL absoluteString ] hasPrefix:mCallbackURL ] ) {
        return FALSE;
    }
    BOOL isOpened = FALSE;
    NSString * theQuery = [ inURL query ];
    if ( theQuery != nil ) {
        NSArray * theOptions = [ theQuery componentsSeparatedByString:( NSString * )sParamSep ];
        if ( theOptions != nil ) {
            for ( NSString * theOption in theOptions ) {
                NSArray * theOptionParts = [ theOption componentsSeparatedByString:( NSString * )sEquals ];
                if ( theOptionParts != nil && [ theOptionParts count ] == 2 ) {
                    if ( [ sParamVerifier isEqualToString:[ theOptionParts objectAtIndex:0 ] ] ) {
                        mToken.verifier = [ theOptionParts objectAtIndex:1 ];
                        [ self setBusy:FALSE ];
                        isOpened = TRUE;
                        break;
                    }
                }
            }
        }
    }
    return isOpened;
}

@end

@implementation OAuthRequestor ( PrivateMethods )

-( BOOL )authorise:( NSError ** )outError {
    NSString * theURL = [ NSString stringWithFormat:@"%@%@%@%@%@",
                         mAuthoriseURL, sURLSep, sParamToken, sEquals, mToken.key ];
    [ self setBusy:TRUE ];
    [ [ UIApplication sharedApplication ] openURL:[ NSURL URLWithString:theURL ] ];
    [ self waitWhileBusy ];
    if ( mToken.verifier == nil ) {
        outError[ 0 ] = [ [ NSError alloc ] initWithCode:ErrOauthFailed
                                             description:@"err_oauth_failed"
                                                  reason:@"err_authorise" ];
        return FALSE;
    }
    return  TRUE;
}

-( BOOL )getToken:( NSString * )inTokenURL
            error:( NSError ** )outError
      errorReason:( NSString * )inErrorReason {
    OAuthURLResponse * theResponse = [ self oauthRequest:sMethodPOST
                                                     url:inTokenURL
                                              parameters:nil ];
    if ( theResponse.error != nil ) {
        outError[ 0 ] = theResponse.error;
        return FALSE;
    }
    if ( ! theResponse.ticket.didSucceed ) {
        outError[ 0 ] = [ [ NSError alloc ] initWithCode:ErrOauthFailed
                                             description:@"err_oauth_failed"
                                                  reason:inErrorReason ];
        return FALSE;
    }
    [ mToken release ];
    NSString * theResponseBody =
    [ [ NSString alloc ] initWithData:theResponse.data encoding:NSUTF8StringEncoding ];
    mToken = [ [ OAToken alloc ] initWithHTTPResponseBody:theResponseBody ];
    [ theResponseBody release ];
    return TRUE;
}
 
-( NSDictionary * )httpRequest:( NSString * )inMethod
                           url:( NSString * )inURL
                    parameters:( NSArray * )inParameters
                         error:( NSError ** )outError {
    if ( ! [ self login:outError ] ) {
        NSLog(@"Error:%@", outError[ 0 ] );
        return nil;
    }
    OAuthURLResponse * theResponse = [ self oauthRequest:inMethod
                                                     url:inURL
                                              parameters:inParameters ];
    outError[ 0 ] = theResponse.error;
    if ( outError[ 0 ] != nil ) {
        return nil;
    }
    return [ NSJSONSerialization JSONObjectWithData:theResponse.data
                                            options:0
                                              error:outError ];
}

-( BOOL )isLoggedIn {
    return mToken == nil        ||
           ! [ mToken isValid ] ||
           [ mToken hasExpired ] ?
        FALSE : TRUE;
}

-( BOOL )login:( NSError ** )outError {
    if ( [ self isLoggedIn ] ) {
        return TRUE;
    }
    [ mToken release ];
    mToken = nil;
    BOOL isLoggedin =
           [ self getToken:mRequestTokenURL
                     error:outError
               errorReason:@"err_oauth_request_token" ] &&
           [ self authorise:outError ] &&
           [ self getToken:mAccessTokenURL
                     error:outError
               errorReason:@"err_oauth_access_token" ];
    if ( isLoggedin ) {
        [ mToken storeInUserDefaultsWithServiceProviderName:mAccessTokenURL
                                                     prefix:sParamToken ];
    }
    return isLoggedin;
}

-( OAuthURLResponse * )oauthRequest:( NSString * )inMethod
                                url:( NSString * )inURL
                         parameters:( NSArray * )inParameters {
    OAMutableURLRequest * theRequest =
    [ [ OAMutableURLRequest alloc ] initWithURL:[ NSURL URLWithString:inURL ]
                                       consumer:mConsumer
                                          token:mToken
                                          realm:nil
                              signatureProvider:nil ];
    [ theRequest setHTTPMethod:inMethod ];
    [ self setCallbackURL:theRequest ];
    if ( inParameters != nil ) {
        [ theRequest setParameters:[ self stringsToParameters:inParameters ] ];
    }
    OAuthURLConnection * theConnection = [ [ OAuthURLConnection alloc ] init ];
    OAuthURLResponse * theResponse = [ theConnection executeRequest:theRequest ];
    [ theConnection release ];
    [ theRequest release ];
    return theResponse;
}

-( void )setCallbackURL:( OAMutableURLRequest * )inRequest {
    NSMutableArray * theParameters = [ NSMutableArray arrayWithArray:inRequest.parameters ];
    [ theParameters addObject:
     [ OARequestParameter requestParameter:sParamCallback value:mCallbackURL ] ];
    inRequest.parameters = theParameters;
}

-( NSArray * )stringsToParameters:( NSArray * )inStrings {
    NSMutableArray * theParameters = nil;
    if ( inStrings != nil ) {
        theParameters = [ [ NSMutableArray alloc ] init ];
        int theCount = [ inStrings count ];
        int theIndex = 0;
        while ( theIndex < theCount ) {
            [ theParameters addObject:
             [ OARequestParameter requestParameter:[ inStrings objectAtIndex:theIndex ]
                                             value:[ inStrings objectAtIndex:theIndex + 1 ] ] ];
            theIndex += 2;
        }
    }
    return [ theParameters autorelease ];
}

@end
