#import "Constants.h"
#import "StayConnectedError.h"

@implementation NSError ( StayConnectedError )

static NSString * sDomain;
static NSString * sKeyNestedError = @"NestedError";

+ ( void )initialize {
    sDomain = [ [ NSString stringWithFormat:@"com.%@.%@.ErrorDomain",
                 COMPANY_NAME, PRODUCT_NAME ] retain ];
}

- ( id )initWithCode:( NSInteger )inCode
         description:( NSString * )inDescription
              reason:( NSString * )inReason {
    return [ self initWithCode:inCode description:inDescription
                        reason:inReason nestedError:nil ];
}

- ( id )initWithCode:( NSInteger )inCode
         description:( NSString * )inDescription
              reason:( NSString * )inReason
         nestedError:( NSError * )inError {
    NSMutableDictionary * theUserInfo = 
        [ [ [ NSMutableDictionary alloc ] init ] autorelease ];
    if ( inDescription != nil ) {
        [ theUserInfo setValue:NSLocalizedString( inDescription, nil )
                        forKey:NSLocalizedDescriptionKey ];
    }
    if ( inReason != nil ) {
        [ theUserInfo setValue:NSLocalizedString( inReason, nil )
                        forKey:NSLocalizedFailureReasonErrorKey ];
    }
    if ( inError != nil ) {
        [ theUserInfo setValue:inError forKey:sKeyNestedError ];
    }
    return [ self initWithDomain:sDomain code:inCode userInfo:theUserInfo ];
}

- ( id )initWithException:( NSException * )inException  {
    return [ self initWithCode:0 description:[ inException name ] reason:[ inException reason ] ];
}

- ( void )log {
    NSLog( @"Error domain:%@ code:%d", [ self domain ], [ self code ] );
    NSDictionary * theUserInfo = [ self userInfo ];
    if ( theUserInfo != nil ) {
        for ( NSString * theKey in [ theUserInfo allKeys ] ) {
            if ( [ sKeyNestedError compare:theKey ] == NSOrderedSame ) {
                continue;
            }
            NSLog( @" %@:%@", theKey, [ theUserInfo valueForKey:theKey ] );
        }
        NSError * theNestedError = [ theUserInfo valueForKey:sKeyNestedError ];
        if ( theNestedError != nil ) {
            NSLog( @"--- Nested Error ---" );
            [ theNestedError log ];
        }
    }
}

@end
