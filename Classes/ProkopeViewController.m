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

@synthesize ProkopeTableView, NameLabel, BookShelfImage;


/******************************************************************************
 * This determines how many dividing sections there are in the table view 
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

/******************************************************************************
 * This determines how many cells are in the table. Only allocate what is needed.
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [AuthorsArray count];
}

/******************************************************************************
 * This method is used by the ProkopeAppDelegate to populate this Array.
 */
-(void)SetDataArray:(NSMutableArray *)dataArray
{
	AuthorsArray = dataArray;
}

/******************************************************************************
 * Sets the name of the cell to name of the author, and the Image to the image 
 * using the url of the author.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Retrive the author for that specific cell.
	Author *a = [AuthorsArray objectAtIndex:indexPath.row];
	
	NSString *url = a.iconURL;
	NSData *mydata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
	UIImage *myimage = [[UIImage alloc] initWithData:mydata];
	cell.imageView.image = myimage;
	
    cell.textLabel.text = a.name;
	
    return cell;
}

/******************************************************************************
 * This method is called when something in the table was clicked. It creates a SecondNavigation
 * object and sets its array to the WorksArray of the corresponding cell that was clicked.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[ProkopeTableView deselectRowAtIndexPath:indexPath animated:YES];
	
	Author *a = [AuthorsArray objectAtIndex:indexPath.row];
	SecondNavigation *secondNav = [[SecondNavigation alloc] initWithNibName:@"SecondNavigation" bundle:nil];
	[secondNav setTitle:a.name];
	[secondNav SetDataArray:a.WorksArray];
	
	// Pushes the view controller on the navigation stack. The navigation controller takes care of the rest. 
	[self.navigationController pushViewController:secondNav animated:YES];
	[secondNav release];
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
	[self ShowAlert];
}

/******************************************************************************
 * This alert get shown when this view is first launched. There are two UITextFields
 * that are created and then added to the alert. Two buttons are also created in the 
 * initialization code. Furthermore the message is set to "\n\n\n" to 'stretch' the 
 * alertView's boundries to include the two UITextFields.
 */
-(void)ShowAlert
{
	UIAlertView *alertDialog;
	alertDialog = [[UIAlertView alloc]initWithTitle:nil message:@"\n\n\n\n" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:@"quit", nil];
		
	userInput = [[UITextField alloc] initWithFrame:CGRectMake(10.0, 20.0, 260.0, 25.0)];
	[userInput setBackgroundColor:[UIColor whiteColor]];
	[userInput setText:@"User Name"];
	[userInput setClearsOnBeginEditing:YES];
	
	passInput = [[UITextField alloc] initWithFrame:CGRectMake(10.0, 60.0, 260.0, 25.0)];
	[passInput setBackgroundColor:[UIColor whiteColor]];
	[passInput setText:@"Pass Word"];
	[passInput setClearsOnBeginEditing:YES];
	
	[alertDialog addSubview:userInput];
	[alertDialog addSubview:passInput];
	[alertDialog show];
	[alertDialog release];
}

/******************************************************************************
 * This method is overridden as part of the UIAlertViewDelegate protocol. This method
 * uses the title of the buttons on an alert, and the programmer decides what to do with it.
 */
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
	if ([buttonTitle isEqualToString:@"ok"])
	{
		NSString *UserName = userInput.text;
		NSString *PassWord = passInput.text;
		
		NSLog(UserName);
		NSLog(PassWord);
		
		[NameLabel setText:[NSString stringWithFormat:@"Welcome : %@", UserName]];
	}
	else if([buttonTitle isEqualToString:@"quit"])
	{
		NSLog(@"You need to login");
	}
}

- (void)dealloc {
    [super dealloc];
}

@end
