//
//  Author.m
//  Prokope
//
//  Created by Justin Antranikian on 5/31/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import "Author.h"


@implementation Author

@synthesize name, iconURL, WorksArray;

-(id)init
{
    if (self = [super init])
    {
		WorksArray = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return self;
}

@end
