
#import <Foundation/Foundation.h>
#import "Contact.h"

@protocol ContactGroup;

@interface ContactBaseImpl : NSObject < Contact > {
    @protected
    NSString * mId;
    NSDictionary * mAttributes;
    NSDictionary * mMapping;
    NSMutableDictionary * mGroups;
}

-( void )addGroup:( id< ContactGroup > )inGroup;

-( id )initWithId:( NSString * )inId
       attributes:( NSDictionary * )inAttributes
          mapping:( NSDictionary * )inMapping;

@end
