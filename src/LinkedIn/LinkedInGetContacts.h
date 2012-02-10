//
//  LinkedInGetContacts.h
//  StayConnected
//
//  Created by Christian Smith on 08/02/2012.
//  Copyright (c) 2012 Oracle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LinkedInCommandBaseImpl.h"

@interface LinkedInGetContacts : LinkedInCommandBaseImpl

-( NSArray * )getContacts:( NSArray * )inContactIds
               attributes:( NSArray * )inAttributes
                    error:( NSError ** )outError;

@end
