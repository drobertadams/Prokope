//
//  Work.h
//  Prokope
//
//  Created by Justin Antranikian on 5/31/11.
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
