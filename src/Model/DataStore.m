
#import "DataStore.h"
#import "Account.h"
#import "Friend.h"

@implementation DataStore

#pragma mark -
#pragma mark Projects

+ (NSArray*) fetchAccounts:(NSManagedObjectContext *)context {
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];	
    
	// select the event table
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Account" 
														 inManagedObjectContext:context];	
	[request setEntity:entityDescription];
	
	NSError *error;
	return [context executeFetchRequest:request error:&error];
}

@end
