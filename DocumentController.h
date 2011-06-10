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


@interface DocumentController : UIViewController <UIWebViewDelegate>
{	
	UIWebView 
		*document,		// where the document/text is displayed
		*commentary,	// where the commentary is displayed
		*vocabulary,	// where the vocabulary is displayed
		*sidebar;		// the sidebar
}

NSString *URL;

// Utility method to extract an XML element from a string.
- (NSString *) getXMLElement:(NSString *)startElement endElement:(NSString *)endElement fromData:(NSString *)data;

// Called by DocumentVieweerDelegate when the user clicks on a word in the document.
- (void) wordClicked:(NSString *)id;
-(void)setStringURL:(NSString *)StringURL;

- (IBAction) close; // close this view

@property (nonatomic, retain) IBOutlet UIWebView *document;
@property (nonatomic, retain) IBOutlet UIWebView *commentary;
@property (nonatomic, retain) IBOutlet UIWebView *vocabulary;
@property (nonatomic, retain) IBOutlet UIWebView *sidebar;

@end
