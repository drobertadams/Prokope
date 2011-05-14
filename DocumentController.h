//
//  DocumentController.h
//  Prokope
//
//	DocumentController mangages the main display of the document/text, commentary,
//	vocabulary, and the sidebar.
//
//  Created by D. Robert Adams on 5/10/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DocumentController : UIViewController {
	
	UIWebView 
		*document,		// where the document/text is displayed
		*commentary,	// where the commentary is displayed
		*vocabulary,	// where the vocabulary is displayed
		*sidebar;		// the sidebar
	
	NSMutableData *receivedData; // data received from the server

}

- (NSString *) getXMLElement:(NSString *)startElement endElement:(NSString *)endElement fromData:(NSString *)data;

- (IBAction) close; // close this view

@property (nonatomic, retain) IBOutlet UIWebView *document;
@property (nonatomic, retain) IBOutlet UIWebView *commentary;
@property (nonatomic, retain) IBOutlet UIWebView *vocabulary;
@property (nonatomic, retain) IBOutlet UIWebView *sidebar;


@end
