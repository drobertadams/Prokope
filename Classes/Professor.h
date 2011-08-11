//
//  Professor.h
//  Prokope
//
//  Created by Justin Antranikian on 8/10/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Professor : NSObject {

	NSString *name;
	NSString *fullname;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *fullname;

@end
