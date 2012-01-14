#import <Foundation/Foundation.h>

@interface NSError ( StayConnectedError )

- ( id )initWithCode:( NSInteger )inCode
         description:( NSString * )inDescription
              reason:( NSString * )inReason;
- ( id )initWithCode:( NSInteger )inCode
         description:( NSString * )inDescription
              reason:( NSString * )inReason
         nestedError:( NSError * )inError;
- ( id )initWithException:( NSException * )inException;
- ( void )log;

@end
