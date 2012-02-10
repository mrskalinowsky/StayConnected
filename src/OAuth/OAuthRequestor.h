#import <Foundation/Foundation.h>

#import "BusyLocker.h"

@class OAConsumer;
@class OAToken;

@interface OAuthRequestor : BusyLocker {
    @private
    OAConsumer * mConsumer;
    OAToken *    mToken;
    NSString *   mRequestTokenURL;
    NSString *   mAuthoriseURL;
    NSString *   mAccessTokenURL;
    NSString *   mCallbackURL;
}

-( id )httpGet:( NSString * )inURL
    parameters:( NSArray * )inParameters
         error:( NSError ** )outError;

-( id )httpPost:( NSString * )inURL
     parameters:( NSArray * )inParameters
          error:( NSError ** )outError;

-( id )httpPost:( NSString * )inURL
     parameters:( NSArray * )inParameters
           body:( NSData * )inBody
          error:( NSError ** )outError;

-( id )initWithKey:( NSString * )inKey
            secret:( NSString * )inSecret
   requestTokenURL:( NSString * )inRequestTokenURL
      authoriseURL:( NSString * )inAuthoriseURL
    accessTokenURL:( NSString * )inAccessTokenURL
    callbackSuffix:( NSString * )inCallbackSuffix;

-( BOOL )openURL:( NSURL * )inURL;

@end