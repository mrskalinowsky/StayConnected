//
//  Contact.h
//  StayConnected
//
//  Created on 12/29/11.
//

#import <Foundation/Foundation.h>

@protocol Contact < NSObject >

/*
 * Qeury an attribute of a contact
 *  inAttributeName is the name of the required attribute.
 *   See ContactAttributes.h for the list of available attribute names
 *  returns the value of the requested attribute
 */
-( NSString * )getAttributeValue:( NSString * )inAttributeName;

/*
 * Query the id of a contact
 */
-( NSString * )getId;

/*
 * Query the groups that a contact belongs to
 * returns an NSArray of ContactGroup objects
 */
-( NSArray * )getGroups;

@end