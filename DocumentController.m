//
//  DocumentController.m
//  Prokope
//
//  Created by D. Robert Adams on 5/10/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import "DocumentController.h"

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
	
	// Find the content of the document itself.
	NSString *doc = [self getXMLElement:@"<content>" endElement:@"</content>" fromData:data];
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
	
	// Fetch the document from the server.
//	NSString *url = @"http://localhost:8082/rest/document/ag9wcm9rb3BlLXByb2plY3RyEwsSDURvY3VtZW50TW9kZWwYCQw";
	NSString *url = @"http://prokope-project.appspot.com/rest/document/ag9wcm9rb3BlLXByb2plY3RyFQsSDURvY3VtZW50TW9kZWwYoZkCDA";
	
	// Build the request.
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url] 
												cachePolicy:NSURLRequestReloadIgnoringLocalCacheData 
												timeoutInterval:30];
	
	// Fetch the document.
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection) {
		// Create the NSMutableData to hold the received data.
		// receivedData is an instance variable.
		receivedData = [[NSMutableData data] retain];
	} else {
		// Inform the user that the connection failed.
	}
	
	
	// Load some dummy data, just to show it works.
	[commentary loadHTMLString:@"<w id=\"foo\">This is the commentary</w>" baseURL:nil];
	[vocabulary loadHTMLString:@"This is the vocabulary" baseURL:nil];
	[sidebar loadHTMLString:@"This is the sidebar" baseURL:nil];
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
