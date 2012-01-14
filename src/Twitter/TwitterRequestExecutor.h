#import <Foundation/Foundation.h>
#import <Twitter/Twitter.h>

@interface TwitterRequestExecutor : NSObject

-( void )execute:( NSString * )inURL
      parameters:( NSDictionary * )inParameters
          method:( TWRequestMethod )inMethod
         handler:( TWRequestHandler )inHandler;

@end