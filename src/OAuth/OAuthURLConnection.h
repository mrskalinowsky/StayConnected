#import <Foundation/Foundation.h>

#import "BusyLocker.h"

@class OAMutableURLRequest;
@class OAServiceTicket;

@interface OAuthURLResponse : NSObject  {
    @private
    NSURLResponse *   mResponse;
    OAServiceTicket * mTicket;
    NSMutableData *   mData;
    NSError *         mError;
}

@property (retain) NSURLResponse *   response;
@property (retain) OAServiceTicket * ticket;
@property (retain) NSData *          data;
@property (retain) NSError *         error;

@end

@interface OAuthURLConnection : BusyLocker {
    @private
    NSURLConnection *     mConnection;
    OAMutableURLRequest * mRequest;
    OAuthURLResponse *    mResponse;
}

-( OAuthURLResponse * )executeRequest:( OAMutableURLRequest * )inRequest;

@end