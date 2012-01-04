//
//  ContactGroup.h
//  StayConnected
//
//  Created on 12/29/11.
//

#import <Foundation/Foundation.h>

@protocol ContactGroup <Contact>

/*
 * Query the contacts contained within a group.
 * returns an NSArray of Contact objects
 */
-( NSArray * )getContacts;

@end
