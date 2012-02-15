//
//  Account.h
//  StayConnected
//
//  Created by Christian Smith on 15/02/2012.
//  Copyright (c) 2012 Oracle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Friend;

@interface Account : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSDate * lastSync;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSSet *friends;
@end

@interface Account (CoreDataGeneratedAccessors)

- (void)addFriendsObject:(Friend *)value;
- (void)removeFriendsObject:(Friend *)value;
- (void)addFriends:(NSSet *)values;
- (void)removeFriends:(NSSet *)values;
@end
