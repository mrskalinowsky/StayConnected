//
//  DataStore.h
//  StayConnected
//
//  Created by Christian Smith on 15/02/2012.
//  Copyright (c) 2012 Oracle. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Account, Friend;

@interface DataStore : NSObject {
    
}

+ (NSArray*) fetchAccounts:(NSManagedObjectContext *)context;

@end
