    //
//  SecondNavigation.m
//  Prokope
//
//  Created by Justin Antranikian on 5/20/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import "SecondNavigation.h"
#import "DocumentController.h"
#import "Author.h"
#import "Work.h"

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
}

/******************************************************************************
 * This method is used by the ProkopeViewController to populate this Array.
 */
-(void)SetDataArray:(NSMutableArray *)dataArray
{
	myArrayData = dataArray;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

/******************************************************************************
 * Sets the name of the cell to name of the author's work
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// get the Author object and populate the table with the name of that work in the array.
    Author *a = [myArrayData objectAtIndex:indexPath.row];
	
    cell.textLabel.text = a.name;
	
    return cell;
}

/******************************************************************************
 * This method is called when something in the table was clicked. It creates a DocumentController
 * object and sets its url to the url of the corresponding cell that was clicked.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[SecondNavigationTableView deselectRowAtIndexPath:indexPath animated:YES];
	
	// get the Work object and grab the url in it to load the document controller.
	Work *a = [myArrayData objectAtIndex:indexPath.row];
	
	DocumentController *doc = [[DocumentController alloc] initWithNibName:@"DocumentController" bundle:nil];
	[doc setTitle:a.workURL];
	
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
