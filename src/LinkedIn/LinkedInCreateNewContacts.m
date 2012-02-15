
#import "LinkedInCreateNewContacts.h"
#import "LinkedInConstants.h"

@implementation LinkedInCreateNewContacts

static NSString * const sURLCreateNewContact = @"https://api.linkedin.com/v1/people/~/mailbox";

-( void )createNewContacts:( NSArray * )inContactIds error:( NSError ** )outError {
    
    NSString * authName = nil;
    NSString * authValue = nil;
    
    NSMutableArray * values = [ [ NSMutableArray alloc ] init ];
    
    for ( NSString * theContactId in inContactIds ) {
        
        NSDictionary * person = [ NSDictionary dictionaryWithObjectsAndKeys:
                                 [ NSDictionary dictionaryWithObjectsAndKeys:
                                  [ NSString stringWithFormat:@"/people/id=%@", theContactId ], 
                                  @"_path", nil], 
                                 @"person", nil ];
        [values addObject:person];
        
        NSDictionary * theResults =
        [ mRequestor httpGet:[ NSString stringWithFormat:@"https://api.linkedin.com/v1/people/id=%@:(id,first-name,last-name,formatted-name,location:(name),picture-url,public-profile-url,api-standard-profile-request)", theContactId ]
                  parameters:[ NSArray arrayWithObjects:sKeyFormat, sValueJSON, nil ]
                       error:outError ];
        if ( outError[ 0 ] != nil ) {
            NSLog(@"Error getting profile: %@", outError[ 0 ] != nil);
            return;
        }

        NSArray * headerValue = [ [ [ [ theResults valueForKey:@"apiStandardProfileRequest"] valueForKey:@"headers"] valueForKey:@"values" ] valueForKey:@"value" ];

        NSArray * tokens = [ [ headerValue objectAtIndex:0] componentsSeparatedByString:@":" ];
        authName = [ tokens objectAtIndex:0 ];
        authValue = [ tokens objectAtIndex:1 ];
    }
    
    NSDictionary * authorization = [ NSDictionary dictionaryWithObjectsAndKeys:authName, @"name", authValue, @"value", nil ];
    NSDictionary * invitationRequest =  
            [ NSDictionary dictionaryWithObjectsAndKeys:
             [ NSDictionary dictionaryWithObjectsAndKeys:@"friend", @"content-type", authorization, @"authorization", nil ], 
             @"invitation-request", nil ];
    
    NSMutableDictionary * data = [ [ NSMutableDictionary alloc ] init ];
    [ data setObject:[NSDictionary dictionaryWithObjectsAndKeys:values, @"values", nil] forKey:@"recipients" ];
    [ data setObject:@"Invitation to Connect" forKey:@"subject" ];
    [ data setObject:@"Say Yes!" forKey:@"body" ];
    [ data setObject:invitationRequest forKey:@"item-content" ];

    NSData * body = [ [ NSJSONSerialization dataWithJSONObject:data 
                                                     options:NSJSONWritingPrettyPrinted 
                                                       error:outError ] retain ];
    
    if ( outError[ 0 ] != nil ) {
        return;
    }
    
    [ mRequestor httpPost:sURLCreateNewContact
               parameters:[ NSArray arrayWithObjects:sKeyFormat, sValueJSON, nil ]
                     body:body
                    error:outError ];
}

@end
