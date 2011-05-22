//
//  DocumentController.m
//  Prokope
//
//  Created by D. Robert Adams on 5/10/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import "DocumentController.h"
#import "DocumentViewerDelegate.h"
#import "WebViewController.h"

@implementation DocumentController

@synthesize document, commentary, vocabulary, sidebar;

/******************************************************************************
 * Closes this view.
 */
- (IBAction) close 
{
	[self dismissModalViewControllerAnimated:YES];
}


/******************************************************************************
 * Called whenever data is received. At this point we simply buffer it
 * until we are notified that the URL finished loading.
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{	
	[receivedData appendData:data];
}

/******************************************************************************
 * Called when the URL connection is finished loading. Take the data that
 * was received (receivedData) and display it in the web view.
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	// Convert the NSMutable data into a normal string.
	NSString *data = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];

	// Make sure that links look like normal text.
	NSString *doc = @"<style type=\"text/css\">a { color: black; text-decoration: none; </style>";
	// Find the content of the document itself.
	doc = [doc stringByAppendingString:[self getXMLElement:@"<content>" endElement:@"</content>" fromData:data]];
	[document loadHTMLString:doc baseURL:nil];	

	// Find the content of the commentary.
	doc = [self getXMLElement:@"<commentary>" endElement:@"</commentary>" fromData:data];
	[commentary loadHTMLString:doc baseURL:nil];

	// Find the content of the vocabulary.
	doc = [self getXMLElement:@"<vocabulary>" endElement:@"</vocabulary>" fromData:data];
	[vocabulary loadHTMLString:doc baseURL:nil];

	// Find the content of the sidebar.
	doc = [self getXMLElement:@"<sidebar>" endElement:@"</sidebar>" fromData:data];
	[sidebar loadHTMLString:doc baseURL:nil];
	
	[receivedData release];
	[connection release];
	[data release];
}

/******************************************************************************
 * Fetches an entire XML element. NOTE: This method uses substring operations,
 * not an XML parser. Therefore, all elements must be unique.
 */
- (NSString *) getXMLElement:(NSString *)startElement endElement:(NSString *)endElement fromData:(NSString *)data
{
	// Find where the start and end elements live.
	NSRange startRange = [data rangeOfString:startElement];	
	NSRange endRange = [data rangeOfString:endElement];
	
	// If we didn't find both elements, return an empty string.
	if (startRange.length == 0 || endRange.length == 0)
		return @"";
	
	// Create a range that subsumes the two elements and everything in between.
	NSRange dataRange;
	dataRange.location = startRange.location;
	dataRange.length = endRange.location - startRange.location + 1 + endRange.length;
	
	// Return the data between the two.
	return [data substringWithRange:dataRange];
}
	
/******************************************************************************
 * Force the application to remain in landscape mode.
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	return(interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

/******************************************************************************
 * Called after this view is loaded -- basically a constructor.
 */
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	// Create a delegate for the document viewer.
	document.delegate = [[DocumentViewerDelegate alloc] initWithController:self];

	// Make ourselves the delegate for the other web views.
	commentary.delegate = self;
	vocabulary.delegate = self;
	sidebar.delegate = self;
	
	// Fetch the document from the server.
	NSString *url = @"http://localhost:8082/rest/document/ag9wcm9rb3BlLXByb2plY3RyEwsSDURvY3VtZW50TW9kZWwYFQw";
//	NSString *url = @"http://prokope-project.appspot.com/rest/document/ag9wcm9rb3BlLXByb2plY3RyFQsSDURvY3VtZW50TW9kZWwYoZkCDA";
	
	// Build the request.
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url] 
												cachePolicy:NSURLRequestReloadIgnoringLocalCacheData 
												timeoutInterval:30];
	
	// Fetch the document. These will call connection:didReceiveData and connectionDidFinishLoading.
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection) {
		// Create the NSMutableData to hold the received data.
		// receivedData is an instance variable.
		receivedData = [[NSMutableData data] retain];
	} else {
		// Inform the user that the connection failed.
	}
}


/* **********************************************************************************************************************
 * Called when any of the webviews (except document) wants to load a URL.
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	// "Other" means we are loading a page ourselves (i.e., not in response to click) -- probably a document.
	if (navigationType == UIWebViewNavigationTypeOther)
		return TRUE; // load the document
	
	// Did the user click on a link?
	else if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		
		// Get the URL begin requested and feed it to our imageViewController.
		NSString *StringRequest = [[request URL] absoluteString];
		
		// Load the image viewer nib and set the URL.
		WebViewController *webViewer = [[WebViewController alloc] initWithNibName:@"WebViewController"
																				 bundle:nil];
		webViewer.url = StringRequest;
		
		// If not using a popover, create a modal view.
		[self presentModalViewController:webViewer animated:YES];
		[webViewer release];
		
	}
	
	// Ignore all other types of user interation.
	return FALSE;
}

/* **********************************************************************************************************************
 * Called by DocumentViewerDelegate when the user clicks on a word.
 */
- (void) wordClicked:(NSString *)id
{
	// Simply print the word id in the commentary window.
	[commentary loadHTMLString:id baseURL:nil];
}










- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */

@end
