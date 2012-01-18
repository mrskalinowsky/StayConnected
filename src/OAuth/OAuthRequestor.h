#import <Foundation/Foundation.h>

#import "OAConsumer.h"
#import "OADataFetcher.h"
#import "OAToken.h"

@protocol OAuthRequestCallback <NSObject>

-( void )requestComplete:( NSDictionary * )inResult error:( NSError * )inError;

@end

@interface OAuthRequestor : NSObject {
    @private
    OAConsumer * mOAConsumer;
    OADataFetcher * mDataFetcher;
    OAToken * mRequestToken;
    OAToken * mAccessToken;
    NSURL * mRequestTokenURL;
    NSString * mAuthoriseURL;
    NSURL * mAccessTokenURL;
    NSString * mCallbackURL;
    NSString * mMethod;
    NSURL * mURL;
    NSArray * mParameters;
    id< OAuthRequestCallback > mCallback;
}

-( void )httpGet:( NSString * )inURL
      parameters:( NSArray * )inParameters
        callback:( id< OAuthRequestCallback > )inCallback;

-( void )httpPost:( NSString * )inURL
       parameters:( NSArray * )inParameters
         callback:( id< OAuthRequestCallback > )inCallback;

-( id )initWithKey:( NSString * )inKey
            secret:( NSString * )inSecret
   tokenRequestURL:( NSString * )inTokenRequestURL
      authoriseURL:( NSString * )inAuthoriseURL
         accessURL:( NSString * )inAccessURL
    callbackSuffix:( NSString * )inCallbackSuffix;

-( BOOL )openURL:( NSURL * )inURL;

@end