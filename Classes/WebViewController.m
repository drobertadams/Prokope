//
//  WebViewController.m
//  Prokope
//
//  Created by D. Robert Adams on 5/16/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import "WebViewController.h"


@implementation WebViewController


@synthesize webView, url;

/* **********************************************************************************************************************
 * Closes this view.
 */
- (IBAction) Close {
	[self dismissModalViewControllerAnimated:YES];
}


/* **********************************************************************************************************************
 * Called after the view is loaded. Fetch the image URL and display it.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
	
	webView.delegate = self;
	webView.allowsInlineMediaPlayback = YES;	// display movies "inline" (in the UIWebView)
	
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	//NSLog(@"url=%@", url);
	[webView loadRequest:theRequest]; 		
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	return YES;
}








- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
	[webView release];
    [super dealloc];
	
}


@end
