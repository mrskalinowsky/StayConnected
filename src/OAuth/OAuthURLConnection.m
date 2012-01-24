#import "Constants.h"
#import "OAuthURLConnection.h"
#import "OAMutableURLRequest.h"
#import "OAServiceTicket.h"
#import "StayConnectedError.h"

@implementation OAuthURLResponse

@synthesize response = mResponse;
@synthesize ticket   = mTicket;
@synthesize data     = mData;
@synthesize error    = mError;

@end

@interface OAuthURLConnection ( PrivateMethods )

-( void )initRequest:( OAMutableURLRequest * )inRequest;

@end

@implementation OAuthURLConnection

-( void )connection:( NSURLConnection * )inConnection
 didReceiveResponse:( NSURLResponse * )inResponse {
    mResponse.response = inResponse;
}

-( void )connection:( NSURLConnection * )inConnection
   didFailWithError:( NSError * )inError {
    mResponse.error = inError;
    [ self setBusy:FALSE ];
}

-( void )connection:( NSURLConnection * )inConnection
     didReceiveData:( NSData * )inData {
    if ( mResponse.data == nil ) {
        mResponse.data = inData;
    } else {
        [ ( NSMutableData * )mResponse.data appendData:inData ];
    }
}

-(void)connectionDidFinishLoading:( NSURLConnection * )connection {
    OAServiceTicket * theTicket =
    [ [OAServiceTicket alloc ] initWithRequest:mRequest
                                      response:mResponse.response
                                          data:mResponse.data
                                    didSucceed:[ ( NSHTTPURLResponse * )mResponse.response statusCode] < 400 ];
    mResponse.ticket = theTicket;
    [ theTicket release ];
    [ self setBusy:FALSE ];
}
        

-( OAuthURLResponse * )executeRequest:( OAMutableURLRequest * )inRequest {
    [ self setBusy:TRUE ];
    mResponse = [ [ OAuthURLResponse alloc ] init ];
    if ( ! [ NSThread isMainThread ] ) {
        [ self performSelectorOnMainThread:@selector( initRequest: )
                                withObject:inRequest
                             waitUntilDone:FALSE ];
        [ self waitWhileBusy ];
    } else {
        NSError * theError = [ [ NSError alloc ] initWithCode:ErrOauthFailed
                                                  description:@"err_oauth_failed"
                                                       reason:@"err_oauth_main_thread" ];
        mResponse.error = theError;
        [ theError release ];
    }
    [ mConnection release ];
    return [ mResponse autorelease ];
}

@end

@implementation OAuthURLConnection ( PrivateMethods )

-( void )initRequest:( OAMutableURLRequest * )inRequest {
    mRequest = [ inRequest retain ];
    [ mRequest prepare ];
    mConnection = [ [ NSURLConnection alloc ] initWithRequest:mRequest delegate:self ];
}

@end
