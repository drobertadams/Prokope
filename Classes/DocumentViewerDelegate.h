//
//  DocumentViewerDelegate.h
//  Prokope
//
//	The delegate for handling events in the document UIWebView from DocumentController.
//
//  Created by D. Robert Adams on 5/21/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DocumentController.h"

@interface DocumentViewerDelegate : NSObject <UIWebViewDelegate> 
{
	DocumentController *controller; // pointer to the parent controller
}

// Initalizes this class with a pointer to the parent controller.
-(DocumentViewerDelegate*) initWithController: (DocumentController *) c;

@property (nonatomic, retain) DocumentController *controller;

@end
