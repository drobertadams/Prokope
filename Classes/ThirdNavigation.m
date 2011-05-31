    //
//  ThirdNavigation.m
//  Prokope
//
//  Created by Justin Antranikian on 5/31/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import "ThirdNavigation.h"
#import "Work.h"
#import "DocumentController.h"

@implementation ThirdNavigation

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [MyThirdArray count];
}

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    Work *w = [MyThirdArray objectAtIndex:indexPath.row];
	
    cell.textLabel.text = w.name;
	
    return cell;
}

// This method repsonds to the touch on an item in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[ThirdTableView deselectRowAtIndexPath:indexPath animated:YES];
	Work *w = [MyThirdArray objectAtIndex:indexPath.row];
	
	DocumentController *doc = [[DocumentController alloc] initWithNibName:@"DocumentController" bundle:nil];
	[doc setTitle:w.iconURL];
	
	[self.navigationController pushViewController:doc animated:YES];
	[doc release];
	
}

-(void)SetSecondDataArray:(NSMutableArray *)dataArray;
{
	MyThirdArray = dataArray; 
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	ThirdTableView.dataSource = self;
	ThirdTableView.delegate = self;
	
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

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
