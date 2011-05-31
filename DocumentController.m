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
	doc = [doc stringByAppendingString:[self getXMLElement:@"<body>" endElement:@"</body>" fromData:data]];
	[document loadHTMLString:doc baseURL:nil];	

	// Find the content of the commentary.
	doc = [self getXMLElement:@"<commentary>" endElement:@"</commentary>" fromData:data];
	
	// Construct a function to hide all comments except the ones associated with the
	// given id (ref attribute)
	NSString *js = 
		@"<script lang=\"text/javascript\">"
		"function show_only(ref)"
		"{"
		"	var comments = document.getElementsByTagName('li');"
		"	for (i = 0; i < comments.length; i++) {"
		"		if ( comments[i].getAttribute('ref') == ref ) {"
		"			comments[i].style.display = 'list-item';"
		"		}"
		"		else {"
		"			comments[i].style.display = 'none';"
		"		}"
		"	}"
		"}"
		"</script>";
	doc = [doc stringByAppendingString:js];
	[commentary loadHTMLString:doc baseURL:nil];

	// Find the content of the vocabulary.
	doc = [self getXMLElement:@"<vocabulary>" endElement:@"</vocabulary>" fromData:data];
	doc = [doc stringByAppendingString:js];
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
	NSString *url = @"http://www.cis.gvsu.edu/~prokope/index.php/rest/document/1";
//	NSString *url = @"http://localhost/~adams/Private/Prokope/index.php/rest/document/4";

	
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
	//[commentary loadHTMLString:id baseURL:nil];
	
	// Call the javascript show_only() function in the commentary UIWebView to display all comments associated with the
	// given id and hide all the others.
	NSString *js = [NSString stringWithFormat: 
							  @"show_only('%@');", id];
	[commentary stringByEvaluatingJavaScriptFromString:js];	
	[vocabulary stringByEvaluatingJavaScriptFromString:js];	
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
