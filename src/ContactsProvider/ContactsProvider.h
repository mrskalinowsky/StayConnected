//
//  ContactsProvider.h
//  StayConnected
//
//  Created on 12/26/11.
//

#import <Foundation/Foundation.h>

@protocol Contact;
@protocol ContactsCallback;
@protocol NewContactsCallback;
@protocol SendMessageCallback;

@protocol ContactsProvider < NSObject >

/*
 * Request one or more new contact requests
 *  inContacts, an NSArray of Contact objects, specifies the contacts
 *  inMessage specifies a message to send as part of the requests
 *  inCallback is invoked to indicate the success or failure of the requests.
 */
-( void )createNewContacts:( NSArray * )inContacts
                   message:( NSString * )inMessage
                  callback:( id< NewContactsCallback > )inCallback;

/*
 * Query contact attributes
 *  inContactIds, an NSArray of NSString objects, specifies the ids of the
 *   contacts of interest. nil may be used to indicate "all contacts"
 *  inAttributes, an NSArray of NSString objects, specifies the contact
 *   attributes ( See ContactAttributes.h ) to be queried
 *  inCallback is invoked to pass the queried contacts back to the caller
 */
-( void )getContacts:( NSArray * )inContactIds
          attributes:( NSArray * )inAttributes
            callback:( id< ContactsCallback > )inCallback;

/*
 * Hmm! This is here temporarily as Facebook expects the app to handle the
 * opening of URLs and the the facebook provider will, in turn, pass any such
 * requests on to its Facebook instance. The current usage would be that the
 * AppDelegate responds to openURL requests by passing them on to a provider.
 * Need to find a better way of handling this.
 */
 -( BOOL )openURL:( NSURL * )inURL;

/*
 * Search for contacts
 *  inSearchString is the search string to use when searching for contacts
 *  inAttributes, an NSArray of NSString objects, specifies the contact
 *   attributes ( See ContactAttributes.h ) to be returned for any contacts
 *   found
 *  inCallback is invoked to pass any contacts found to the caller
 */
-( void )searchForContacts:( NSString * )inSearchString
                attributes:( NSArray * )inAttributes
                  callback:( id< ContactsCallback > )inCallback;

/*
 * Send a message to one or more contacts
 *  inContacts, an NSArray of Contact objects, specifies the list of contacts
 *   to whom the message should be sent.
 *  inMessage specifies the message to send
 *  inCallback is invoked to indicate success or failure
 */
-( void )sendMessage:( NSArray * )inContacts
             message:( NSString * )inMessage
            callback:( id< SendMessageCallback > )inCallback;

/*
 * The name of the provider
 */
@property ( readonly ) NSString * name;

@end

@protocol NewContactsCallback < NSObject >

/*
 * Invoked in response to createNewContacts
 *  inError indicates an error on failure. inError is nil on success
 */
-( void )onContactsRequested:( NSError * )inError;

@end

@protocol ContactsCallback < NSObject >

/*
 * Invoked in response to getContacts and searchForContacts
 *  inContacts, an NSArray of Contact objects, is the list of contacts requested
 *  inError indicates an error on failure. inError is nil on success
 */
-( void )onContactsFound:( NSArray * )inContacts error:( NSError * )inError;

@end

@protocol SendMessageCallback < NSObject >

/*
 * Invoked in response to sendMessage
 *  inError indicates an error on failure. inError is nil on success
 */
-( void )onMessageSent:( NSError * )inError;

@end
