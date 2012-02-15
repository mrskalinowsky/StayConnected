//
//  Friend.h
//  StayConnected
//
//  Created by Christian Smith on 15/02/2012.
//  Copyright (c) 2012 Oracle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Account;

@interface Friend : NSManagedObject

@property (nonatomic, retain) NSDate * createdTimestamp;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * external_id;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * local_id;
@property (nonatomic, retain) NSDate * modifiedTimestamp;
@property (nonatomic, retain) NSData * pic;
@property (nonatomic, retain) NSString * url_fb;
@property (nonatomic, retain) NSString * url_li;
@property (nonatomic, retain) NSString * url_tw;
@property (nonatomic, retain) Account *account;

@end
