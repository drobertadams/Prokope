//
//  ProkopeAppDelegate.h
//  Prokope
//
//  Created by D. Robert Adams on 5/9/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProkopeViewController;

@interface ProkopeAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    ProkopeViewController *viewController;
	
	UINavigationController *ProkopeNavigationController;
	
	NSMutableArray *AuthorsArray;
	
	int AuthorCount;
	int WorkCount;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ProkopeViewController *viewController;

@end

