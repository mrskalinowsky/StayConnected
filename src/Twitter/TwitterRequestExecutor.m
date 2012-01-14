#import <Accounts/Accounts.h>
#import "Constants.h"
#import "StayConnectedError.h"
#import "TwitterRequestExecutor.h"

@implementation TwitterRequestExecutor

-( void )execute:( NSString * )inURL
      parameters:( NSDictionary * )inParameters
          method:( TWRequestMethod )inMethod
         handler:( TWRequestHandler )inHandler {
    ACAccountStore * theAccountStore = [ [ ACAccountStore alloc ] init ];
    ACAccountType * theAccountType =
        [ theAccountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter ];
    if ( [ theAccountStore accountsWithAccountType:theAccountType ] == nil ) {
        NSError * theError =
            [ [ NSError alloc ] initWithCode:ErrTwitterNoAccount
                                 description:@"err_twitter_login"
                                      reason:@"err_twitter_no_account" ];
        inHandler( nil, nil, [ theError autorelease ] );
    } else {
        [ theAccountStore requestAccessToAccountsWithType:theAccountType
                                    withCompletionHandler:^( BOOL inIsGranted, NSError * inError ) {
            if ( inIsGranted ) {
                NSArray * theAccountsArray =
                    [ theAccountStore accountsWithAccountType:theAccountType ];
                if ( [ theAccountsArray count ] > 0 ) {
                    ACAccount * theAccount = [ theAccountsArray objectAtIndex:0 ];
                    TWRequest * theRequest = 
                        [ [ TWRequest alloc ] initWithURL:[ NSURL URLWithString:inURL ]
                                               parameters:inParameters
                                            requestMethod:inMethod ];
                    [ theRequest setAccount:theAccount ];
                    [ theRequest performRequestWithHandler:inHandler ];
                    [ theRequest release ];
                }
            }
        } ];
    }
    [ theAccountStore release ];
}

@end
