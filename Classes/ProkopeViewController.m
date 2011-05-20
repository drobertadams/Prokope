//
//  ProkopeViewController.m
//  Prokope
//
//  Created by D. Robert Adams on 5/9/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import "DocumentController.h"
#import "ProkopeViewController.h"
#import "SecondNavigation.h"

@implementation ProkopeViewController

/******************************************************************************
 * Handles the event of the user wanting to display a document. Loads the
 * DocumentController and displays it.
 */
- (void) showDocument 
{
	[super viewDidLoad];
	
	// Load the document controller nib display it.
	DocumentController *docController = [[DocumentController alloc] 
										 initWithNibName:@"DocumentController" bundle:nil];
	[self presentModalViewController:docController animated:YES];
	
	[docController release];
}


- (IBAction) NavigationButtonClicked:(id)sender
{
	SecondNavigation *viewController = [[SecondNavigation alloc] initWithNibName:@"SecondNavigation" bundle:nil];
	[self.navigationController pushViewController:viewController animated:NO];
	[viewController release];
	
}




// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(void)viewDidLoad
{
	self.title = @"Home Page";
}

- (void)dealloc {
    [super dealloc];
}

@end
