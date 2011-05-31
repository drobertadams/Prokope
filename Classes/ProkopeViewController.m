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
#import "Author.h"

@implementation ProkopeViewController

@synthesize ProkopeTableView;

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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [AuthorArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	Author *a = [AuthorArray objectAtIndex:indexPath.row];
	
	NSString *url = a.iconURL;
	NSData *mydata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
	UIImage *myimage = [[UIImage alloc] initWithData:mydata];
	cell.image = myimage;
	
    cell.textLabel.text = a.name;
	
    return cell;
}

// This method repsonds to the touch on an item in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[ProkopeTableView deselectRowAtIndexPath:indexPath animated:YES];
	
	SecondNavigation *secondNav = [[SecondNavigation alloc] initWithNibName:@"SecondNavigation" bundle:nil];
	
	Author *a = [AuthorArray objectAtIndex:indexPath.row];
	[secondNav setTitle: a.name];
	[secondNav SetSecondDataArray:a.WorksArray];
	
	// Pushes the view controller on the navigation stack. The navigation controller takes care of the rest. 
	[self.navigationController pushViewController:secondNav animated:YES];
	[secondNav release];
}

-(void)SetDataArray:(NSMutableArray *)dataArray
{
	AuthorArray = dataArray;
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
	self.title = @"Prokope Home Page";
	[super viewDidLoad];
		
	// You must set the delegate and dataSource of the table to self, otherwise it will just be an empty table.
	ProkopeTableView.delegate = self;
	ProkopeTableView.dataSource = self;
		
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	// self.navigationItem.rightBarButtonItem = self.editButtonItem;
		
//	myArrayData = [[NSMutableArray alloc] initWithObjects: @"Ceasar", @"Ciscero", @"Plato", @"Aristole", nil];
//	MyURLData = [[NSMutableArray alloc] initWithObjects: @"http://www.stenudd.com/myth/greek/images/plato.jpg", 
//				 @"http://www.stenudd.com/myth/greek/images/plato.jpg", @"http://www.stenudd.com/myth/greek/images/plato3.jpg",
//				 @"http://www.stenudd.com/myth/greek/images/plato4.jpg", nil];
}



- (void)dealloc {
    [super dealloc];
}

@end
