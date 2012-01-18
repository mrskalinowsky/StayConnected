#import "Constants.h"
#import "OAMutableURLRequest.h"
#import "OAuthRequestor.h"
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

-( void )authorise;
-( void )accessToken;
-( void )accessToken:( OAServiceTicket * )inTicket
   didFinishWithData:( NSData * )inData;
-( void )accessToken:( OAServiceTicket * )inTicket
    didFailWithError:( NSError * )inError;
-( void )doRequest;
-( void )doRequest:( OAServiceTicket * )inTicket
 didFinishWithData:( NSData * )inData;
-( void )doRequest:( OAServiceTicket * )inTicket
  didFailWithError:( NSError * )inError;
-( void )httpRequest:( NSString * )inMethod
                 url:( NSString * )inURL
          parameters:( NSArray * )inParameters
            callback:( id< OAuthRequestCallback > )inCallback;
-( void )releaseRequest;
-( void )requestComplete:( NSDictionary * )inResult error:( NSError * )inError;
-( void )requestToken;
-( void )requestToken:( OAServiceTicket * )inTicket
    didFinishWithData:( NSData * )inData;
-( void )requestToken:( OAServiceTicket * )inTicket
     didFailWithError:( NSError * )inError;

@end

@implementation OAuthRequestor

-( void )dealloc {
    [ self releaseRequest ];
    [ mCallbackURL release ];
    [ mAccessToken release ];
    [ mRequestToken release ];
    [ mAccessTokenURL release ];
    [ mAuthoriseURL release ];
    [ mRequestTokenURL release ];
    [ mOAConsumer release ];
    [ super dealloc ];
}

-( void )httpGet:( NSString * )inURL
      parameters:( NSArray * )inParameters
        callback:( id< OAuthRequestCallback > )inCallback {
    [ self httpRequest:sMethodGET url:inURL parameters:inParameters callback:inCallback ];
}

-( void )httpPost:( NSString * )inURL
       parameters:( NSArray * )inParameters
         callback:( id< OAuthRequestCallback > )inCallback{
    [ self httpRequest:sMethodPOST url:inURL parameters:inParameters callback:inCallback ];
}

-( id )initWithKey:( NSString * )inKey
            secret:( NSString * )inSecret
   tokenRequestURL:( NSString * )inTokenRequestURL
      authoriseURL:( NSString * )inAuthoriseURL
         accessURL:( NSString * )inAccessURL
    callbackSuffix:( NSString * )inCallbackSuffix {
    self = [ super init ];
    if ( self != nil ) {
        mOAConsumer = [ [ OAConsumer alloc ] initWithKey:inKey secret:inSecret ];
        mRequestTokenURL = [ [ NSURL URLWithString:inTokenRequestURL ] retain ];
        mAuthoriseURL = [ inAuthoriseURL retain ];
        mAccessTokenURL = [ [ NSURL URLWithString:inAccessURL ] retain ];
        mAccessToken =
        [ [ OAToken alloc ]
         initWithUserDefaultsUsingServiceProviderName:[ mAccessTokenURL absoluteString ]
                                               prefix:sParamToken ];
        mCallbackURL =
        [ [ NSString stringWithFormat:@"%@%@",
            sCallbackPrefix, inCallbackSuffix ] retain ];
    }
    return self;
}

-( BOOL )openURL:( NSURL * )inURL {
    // Todo: Make sure the URL is one we can handle
    BOOL isOpened = FALSE;
    NSString * theQuery = [ inURL query ];
    if ( theQuery != nil ) {
        NSArray * theOptions = [ theQuery componentsSeparatedByString:( NSString * )sParamSep ];
        if ( theOptions != nil ) {
            for ( NSString * theOption in theOptions ) {
                NSArray * theOptionParts = [ theOption componentsSeparatedByString:( NSString * )sEquals ];
                if ( theOptionParts != nil && [ theOptionParts count ] == 2 ) {
                    if ( [ sParamVerifier isEqualToString:[ theOptionParts objectAtIndex:0 ] ] ) {
                        mRequestToken.verifier = [ theOptionParts objectAtIndex:1 ];
                        [ self accessToken ];
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

-( void )accessToken {
    OAMutableURLRequest * theRequest =
    [ [ OAMutableURLRequest alloc ] initWithURL:mAccessTokenURL
                                       consumer:mOAConsumer
                                          token:mRequestToken
                                          realm:nil
                              signatureProvider:nil ];
    [ theRequest setHTTPMethod:sMethodPOST ];
    mDataFetcher = [ [ OADataFetcher alloc ] init ];
    [ mDataFetcher fetchDataWithRequest:theRequest
                               delegate:self
                      didFinishSelector:@selector( accessToken:didFinishWithData: )
                        didFailSelector:@selector( accessToken:didFailWithError: ) ];
    [ mDataFetcher release ];
    [ theRequest release ];
}

-( void )accessToken:( OAServiceTicket * )inTicket
    didFinishWithData:( NSData * )inData {
    [ mRequestToken release ];
    if ( inTicket.didSucceed ) {
        NSString * theResponseBody =
        [ [ NSString alloc ] initWithData:inData encoding:NSUTF8StringEncoding ];
        mAccessToken = [ [ OAToken alloc ] initWithHTTPResponseBody:theResponseBody ];
        [ theResponseBody release ];
        [ mAccessToken storeInUserDefaultsWithServiceProviderName:[ mAccessTokenURL absoluteString ]
                                                           prefix:sParamToken ];
        [ self doRequest ];
    } else {
        NSError * theError =
        [ [ NSError alloc ] initWithCode:ErrOauthFailed
                             description:@"err_oauth_failed"
                                  reason:@"err_access_token" ];
        [ self requestComplete:nil error:[ theError autorelease ] ];
    }
    
}

-( void )accessToken:( OAServiceTicket * )inTicket
     didFailWithError:( NSError * )inError {
    [ mRequestToken release ];
    [ self requestComplete:nil error:inError ];
}

-( void )authorise {
    NSString * theURL = [ NSString stringWithFormat:@"%@%@%@%@%@",
     mAuthoriseURL, sURLSep, sParamToken, sEquals, mRequestToken.key ];
    [ [ UIApplication sharedApplication ] openURL:[ NSURL URLWithString:theURL ] ];
}

-( void )doRequest {
    OAMutableURLRequest * theRequest =
    [ [ OAMutableURLRequest alloc ] initWithURL:mURL
                                       consumer:mOAConsumer
                                          token:mAccessToken
                                          realm:nil
                              signatureProvider:nil ];
    [ theRequest setHTTPMethod:mMethod ];
    mDataFetcher = [ [ OADataFetcher alloc ] init ];
    [ mDataFetcher fetchDataWithRequest:theRequest
                               delegate:self
                      didFinishSelector:@selector( doRequest:didFinishWithData: )
                        didFailSelector:@selector( doRequest:didFailWithError: ) ];
    [ mDataFetcher release ];
    [ theRequest release ];
}

-( void )doRequest:( OAServiceTicket * )inTicket
 didFinishWithData:( NSData * )inData {
    NSError * theError;
    NSDictionary * theResults =
    [ NSJSONSerialization JSONObjectWithData:inData
                                     options:0
                                       error:&theError ];
    [ self requestComplete:theResults error:theError ];
}

-( void )doRequest:( OAServiceTicket * )inTicket
  didFailWithError:( NSError * )inError {
    [ self requestComplete:nil error:inError ];
}
     
-( void )httpRequest:( NSString * )inMethod
                 url:( NSString * )inURL
          parameters:( NSArray * )inParameters
            callback:( id< OAuthRequestCallback > )inCallback{
    [ self releaseRequest ];
    mMethod = [ inMethod retain ];
    mURL = [ [ NSURL URLWithString:inURL ] retain ];
    mParameters = [ inParameters retain ];
    mCallback = [ inCallback retain ];
    if ( mAccessToken == nil || ! [ mAccessToken isValid ] || [ mAccessToken hasExpired ] ) {
        [ mAccessToken release ];
        mAccessToken = nil;
        [ self requestToken ];
    } else {
        [ self doRequest ];
    }
}

-( void )releaseRequest {
    [ mMethod release ];
    [ mURL release ];
    [ mParameters release ];
    [ mCallback release ];
    mMethod = nil;
    mURL = nil;
    mParameters = nil;
    mCallback = nil;
}

-( void )requestComplete:( NSDictionary * )inResult error:( NSError * )inError {
    [ mCallback requestComplete:inResult error:inError ];
    [ self releaseRequest ];
}

-( void )requestToken {
    OAMutableURLRequest * theRequest =
    [ [ OAMutableURLRequest alloc ] initWithURL:mRequestTokenURL
                                       consumer:mOAConsumer
                                          token:nil
                                          realm:nil
                              signatureProvider:nil ];
    [ theRequest setHTTPMethod:sMethodPOST ];
    OARequestParameter * theParameter =
    [ OARequestParameter requestParameter:sParamCallback 
                                    value:mCallbackURL ];
    NSMutableArray * theParameters = [ NSMutableArray arrayWithArray:theRequest.parameters ];
    [ theParameters addObject:theParameter ];
    [ theRequest setParameters:theParameters ];
    mDataFetcher = [ [ OADataFetcher alloc ] init ];
    [ mDataFetcher fetchDataWithRequest:theRequest
                               delegate:self
                      didFinishSelector:@selector( requestToken:didFinishWithData: )
                        didFailSelector:@selector( requestToken:didFailWithError: ) ];
    [ mDataFetcher release ];
    [ theRequest release ];
}

-( void )requestToken:( OAServiceTicket * )inTicket
    didFinishWithData:( NSData * )inData {
    if ( inTicket.didSucceed ) {
        NSString * theResponseBody =
        [ [ NSString alloc ] initWithData:inData encoding:NSUTF8StringEncoding ];
        mRequestToken = [ [ OAToken alloc ] initWithHTTPResponseBody:theResponseBody ];
        [ theResponseBody release ];
        [ self authorise ];
    } else {
        NSError * theError =
        [ [ NSError alloc ] initWithCode:ErrOauthFailed
                             description:@"err_oauth_failed"
                                  reason:@"err_request_token" ];
        [ self requestComplete:nil error:[ theError autorelease ] ];
    }

}

-( void )requestToken:( OAServiceTicket * )inTicket
     didFailWithError:( NSError * )inError {
    [ self requestComplete:nil error:inError ];
}

@end
