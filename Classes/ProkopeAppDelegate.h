//
//  ProkopeAppDelegate.h
//  Prokope
//
//  Created by D. Robert Adams on 5/9/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProkopeViewController;

@protocol NSXMLParserDelegate;

@interface ProkopeAppDelegate : NSObject <UIApplicationDelegate, NSXMLParserDelegate> {
    UIWindow *window;
    ProkopeViewController *viewController;
	
	UINavigationController *ProkopeNavigationController;
	
	NSMutableArray *AuthorsArray;
	
	int AuthorCount;
	int WorkCount;
	
	UIBarButtonItem *addButton;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ProkopeViewController *viewController;

-(void)addButtonPressed;

@end

