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
	
	NSString *URL;
	NSString *Title;
	NSString *UserName;
	UILabel *label2;
	
	NSMutableArray *RatingsArray;	
	NSMutableArray *ClicksArray;
	NSMutableArray *MediaArray;
	NSMutableArray *FollowArray;
	
	NSMutableString *XMLString;
	
	NSTimer *MyTimer;
	int TimerCount;
	
	NSMutableData *recievedData;
}

@property (nonatomic, retain) IBOutlet UIWebView *document;
@property (nonatomic, retain) IBOutlet UIWebView *commentary;
@property (nonatomic, retain) IBOutlet UIWebView *vocabulary;
@property (nonatomic, retain) IBOutlet UIWebView *sidebar;
@property (nonatomic, retain) NSString *URL;
@property (nonatomic, retain) NSString *Title;
@property (nonatomic, retain) NSString *UserName;
@property (nonatomic, retain) NSMutableArray *FollowArray;

- (void)fetchDocumentData;

// Utility method to extract an XML element from a string.
- (NSString *) getXMLElement:(NSString *)startElement endElement:(NSString *)endElement fromData:(NSString *)data;
-(void)targetMethod;
-(NSString *)getDate;
-(NSMutableString *)getXMLData;

// Called by DocumentVieweerDelegate when the user clicks on a word in the document.
-(void)wordClicked:(NSString *)id;
-(void)captureURL:(UIWebView *)webView RequestMade:(NSString *)request;

@end
