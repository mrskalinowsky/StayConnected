//
//  LinkedInCommandBaseImpl.h
//  StayConnected
//
//  Created by Christian Smith on 08/02/2012.
//  Copyright (c) 2012 Oracle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthRequestor.h"

@interface LinkedInCommandBaseImpl : NSObject {
@protected
    OAuthRequestor * mRequestor;
}

-( id )initWithRequestor:( OAuthRequestor * )inRequestor;

@end
