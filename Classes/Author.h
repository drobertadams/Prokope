//
//  Author.h
//  Prokope
//
//  Created by Justin Antranikian on 5/31/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Author : NSObject {

	NSString *name;
	NSString *iconURL;
	NSMutableArray *WorksArray;
	
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *iconURL;
@property (nonatomic, retain) NSMutableArray *WorksArray;

@end
