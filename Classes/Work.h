//
//  Work.h
//  Prokope
//
//  Created by Justin Antranikian on 6/3/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Work : NSObject {

	NSString *name;
	NSString *workURL;
	NSMutableArray *ChaptersArray;
	
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *workURL;
@property (nonatomic, retain) NSMutableArray *ChaptersArray;


@end
