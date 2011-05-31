    //
//  SecondNavigation.m
//  Prokope
//
//  Created by Justin Antranikian on 5/20/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import "SecondNavigation.h"
#import "DocumentController.h"

@implementation SecondNavigation

@synthesize SecondNavigationTableView;
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [myArrayData count];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	SecondNavigationTableView.delegate = self;
	SecondNavigationTableView.dataSource = self;
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	NSString *text = [[self title] stringByAppendingString:@" Work"];
	
	myArrayData = [[NSMutableArray alloc] initWithObjects:[text stringByAppendingString:@" 1"] , [text stringByAppendingString:@" 2"], 
			   [text stringByAppendingString:@" 3"], [text stringByAppendingString:@" 4"],
			   [text stringByAppendingString:@" 5"], [text stringByAppendingString:@" 6"],  nil];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [myArrayData objectAtIndex:indexPath.row];
	
    return cell;
}

// This method repsonds to the touch on an item in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[SecondNavigationTableView deselectRowAtIndexPath:indexPath animated:YES];
	
	DocumentController *doc = [[DocumentController alloc] initWithNibName:@"DocumentController" bundle:nil];
	[doc setTitle:[myArrayData objectAtIndex:indexPath.row]];
	
	[self.navigationController pushViewController:doc animated:YES];
	[doc release];
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


@end