//
//  Work.m
//  Prokope
//
//  Created by Justin Antranikian on 6/3/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import "Work.h"


@implementation Work

@synthesize name, workURL, ChaptersArray;

-(id)init
{
    if (self = [super init])
    {
		ChaptersArray = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return self;
}

@end
