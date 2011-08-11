//
//  DocumentViewerDelegate.m
//  Prokope
//
//	The delegate for handling events in the document UIWebView from DocumentController.
//
//  Created by D. Robert Adams on 5/21/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import "DocumentViewerDelegate.h"
#import "WebViewController.h"


@implementation DocumentViewerDelegate

@synthesize controller;

/* **********************************************************************************************************************
 * Constructor. Sets the controller to the parent's controller so we can get a reference to its data and methods.
 */
-(DocumentViewerDelegate*)initWithController:(DocumentController *)c
{
    self = [super init];	
    if (self)
	{
        self.controller = c;
    }
    return self;
}

/* **********************************************************************************************************************
 * Capture URL loads in the document viewer UIWebView. 
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	// "Other" means we are loading a page ourselves (i.e., not in response to click) -- probably a document.
	// Just load it.
	if (navigationType == UIWebViewNavigationTypeOther)
		return TRUE; // load the document
	
	// Did the user click on a link?
	else if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		
		// Get the URL requested.
		NSString *url = [[request URL] absoluteString];
				
		// Word links don't look like URLs. They are of the form 10.4.2.1 (no "http"). If the user clicked
		// on a word, tell the parent controller, otherwise, load the URL.
		if ( [url rangeOfString:@"http"].length == 0 ) {
			
			// Unfortunately, the URL actually sent to us looks like this:
			// applewebdata://D34C7F13-505E-4A9A-96E9-0108DF12DCC0/10.4.4.4
			// The word id is at the end (10.4.4.4). Strip it off.
			NSString *wordId = [[url componentsSeparatedByString:@"/"] lastObject];

			// Tell the controller a word was clicked.
			[controller wordClicked:wordId];
			return FALSE;
		}
		
		// Otherwise, the user clicked on something other than a word. Load the URL
		// in the WebViewController.		
		WebViewController *webViewer = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
		
		NSLog(@"%@", url);
		NSString *returnval = [webView stringByEvaluatingJavaScriptFromString:
							   [NSString stringWithFormat:@"GetTypeFromHref('%@')", url]];
		
		if ([returnval isEqualToString:@"media"])
		{
			NSLog(@"MEDIA RESULT");
			[controller captureURL:webView RequestMade:url];
		}
		else
		{
			NSLog(@"NonMedia");
			NSString *new = [NSString stringWithFormat:@"<follow date='%@' doc='%@' comment='%@' /> \n", [controller getDate], controller.URL, url];
			[controller.EventsArray addObject:new];
		}
												   
		webViewer.url = url;
		
		// Create a modal view.
		[controller presentModalViewController:webViewer animated:YES];
		[webViewer release];
		
	}	
	// Ignore all other types of user interation.
	return FALSE;
}

@end
