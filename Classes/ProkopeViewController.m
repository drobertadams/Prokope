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
#import "Work.h"
#import "LoginAlertViewDelegate.h"

@implementation ProkopeViewController

@synthesize ProkopeTableView, BookShelfImage, SecondShelf, ThirdShelfScroll, FirstShelf, label2;


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

-(UILabel *)getLabel2
{
	return self.label2;
}

-(NSString *)geUserNameLabel
{
	return UserNameLabel;
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

/******************************************************************************
 * This method used to demo a horizontal scroll bar.
 */
-(void)PopulateScroll
{
	int x_cord = -65;
	for (int i = 0; i <= 25; i++)
	{
		UIButton *ProgramButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		ProgramButton.frame = CGRectMake(x_cord, 75, 182, 40);
		[ProgramButton.titleLabel setFont:[UIFont systemFontOfSize:30]];
		[ProgramButton setTitle:[NSString stringWithFormat:@"Title %i", i] forState:UIControlStateNormal];
		[ProgramButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
		[ProgramButton setBackgroundColor:[UIColor cyanColor]];
		[ProgramButton setBackgroundImage:BookSpine forState:UIControlStateNormal];
		[ProgramButton setBackgroundImage:BookSpine forState:UIControlStateHighlighted];
		[ProgramButton setBackgroundImage:BookSpine forState:UIControlStateSelected];
		ProgramButton.transform = CGAffineTransformMakeRotation( ( 90 * M_PI ) / 180 );
		[ThirdShelfScroll addSubview:ProgramButton];
		x_cord += 50;
	}
	[ThirdShelfScroll setScrollEnabled:YES];
	[ThirdShelfScroll setContentSize:CGSizeMake(x_cord + 40, ThirdShelfScroll.frame.size.height)];
}

/******************************************************************************
 * This method is called when the view is loaded. Custom code is called to configure
 * the application.
 */
-(void)viewDidLoad
{
	self.title = @"Prokope - Intermediate Latin Reader";
	[super viewDidLoad];
		
	// You must set the delegate and dataSource of the table to self, otherwise it will just be an empty table.
	ProkopeTableView.delegate = self;
	ProkopeTableView.dataSource = self;
	
	[self setUpNavBar];
	[self SetUpLoginButton];
	
	[self ShowAlert];
	
	BookSpine = [UIImage imageNamed:@"BookSpine2.png"];
	
	int x_cord = -70 + 10;
	// This loop populates the 'top shelf' of the BookShelfImage.
	for (Author *a in AuthorsArray)
	{
		UIButton *ProgramButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		ProgramButton.frame = CGRectMake(x_cord, 70, FirstShelf.frame.size.height, 40);
		[ProgramButton.titleLabel setFont:[UIFont systemFontOfSize:25]];
		[ProgramButton setTitle:a.name forState:UIControlStateNormal];
		[ProgramButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
		[ProgramButton setBackgroundColor:[UIColor cyanColor]];
		[ProgramButton setBackgroundImage:BookSpine forState:UIControlStateNormal];
		[ProgramButton setBackgroundImage:BookSpine forState:UIControlStateHighlighted];
		[ProgramButton setBackgroundImage:BookSpine forState:UIControlStateSelected];
		[ProgramButton addTarget:self action:@selector(FirstShelfButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
		
		// This line of code rotates the button to be facing vertical.
		ProgramButton.transform = CGAffineTransformMakeRotation( ( 90 * M_PI ) / 180 );
		[FirstShelf addSubview:ProgramButton];
		x_cord += 50;
	}
	[self PopulateScroll];
}

-(void)setUpNavBar
{
	UserNameLabel = nil;

	UIView *NavBarView = [[UIView alloc] init];
	NavBarView.frame = CGRectMake(0, 0, 320, 40);
	
	UILabel *label;
	label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 300, 16)];
	label.tag = 1;
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:17];
	label.adjustsFontSizeToFitWidth = NO;
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor grayColor];
	label.text = @"Prokope - Intermediate Latin Reader";
	label.highlightedTextColor = [UIColor blackColor];
	[NavBarView addSubview:label];
	[label release];
	
	
	//label2 = [[UILabel alloc] initWithFrame:CGRectMake(-350, 10, 350, 16)];
	label2 = [[UILabel alloc] initWithFrame:CGRectMake(305, 10, 295, 16)];
	label2.tag = 2;
	label2.backgroundColor = [UIColor clearColor];
	label2.font = [UIFont boldSystemFontOfSize:17];
	label2.adjustsFontSizeToFitWidth = YES;
	label2.textAlignment = UITextAlignmentRight;
	label2.textColor = [UIColor blackColor];
	label2.text = [NSString stringWithFormat:@"Welcome : %@", UserNameLabel];
	label2.highlightedTextColor = [UIColor blackColor];
	[NavBarView addSubview:label2];
	[label2 release];
	
	self.navigationItem.titleView = NavBarView;
	
}

/******************************************************************************
 * This method is called when something in the table was clicked. It creates a SecondNavigation
 * object and sets its array to the WorksArray of the corresponding cell that was clicked.
 */
-(void)FirstShelfButtonClicked:(id)sender
{
	[self ClearSecondShelf];
	[self ClearThirdShelf];
	[self ClearFirstShelfFonts];

	UIButton *resultButton = (UIButton *)sender;
	CurrentAuthor = resultButton.currentTitle;
	UIFont *myFont = [UIFont fontWithName:@"Helvetica-BoldOblique" size:30.0];
	resultButton.titleLabel.font = myFont;
	
	Author *MyAuth;
	for (Author *auth in AuthorsArray)
	{
		if([auth.name isEqualToString:resultButton.currentTitle])
		{
			MyAuth = auth;
			break;
		}
	}
	
	int x_cord = 10;

	NSURL *url = [NSURL URLWithString: MyAuth.iconURL]; 
	UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
	UIImageView *myi = [[UIImageView alloc] initWithFrame:CGRectMake(x_cord, 110, 100, 100)];
	[myi setImage:image];
	[SecondShelf addSubview:myi];
	
	x_cord += 20;
	
	// This loop adds the books on the second level of the book shelf.
	for (Work *work in MyAuth.WorksArray)
	{
		UIButton *ProgramButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		ProgramButton.frame = CGRectMake(x_cord, 85, 200, 40);
		[ProgramButton.titleLabel setFont:[UIFont systemFontOfSize:25]];
		[ProgramButton setTitle:work.name forState:UIControlStateNormal];
		[ProgramButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
		[ProgramButton setBackgroundColor:[UIColor cyanColor]];
		[ProgramButton setBackgroundImage:BookSpine forState:UIControlStateNormal];
		[ProgramButton setBackgroundImage:BookSpine forState:UIControlStateHighlighted];
		[ProgramButton setBackgroundImage:BookSpine forState:UIControlStateSelected];
		[ProgramButton addTarget:self action:@selector(SecondShelfButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
		ProgramButton.transform = CGAffineTransformMakeRotation( ( 90 * M_PI ) / 180 );
		[SecondShelf addSubview:ProgramButton];
		x_cord += 45;
	}
	x_cord += 75;
	
	UIImageView *myi2 = [[UIImageView alloc] initWithFrame:CGRectMake(x_cord, 110, 100, 100)];
	[myi2 setImage:image];
	[SecondShelf addSubview:myi2];
	
	[SecondShelf setScrollEnabled:YES];
	[SecondShelf setShowsHorizontalScrollIndicator:YES];
	[SecondShelf setContentSize:CGSizeMake(x_cord + 110, SecondShelf.frame.size.height)];
}

/******************************************************************************
 * This method is used as the selector when when a second level book is selected.
 * There is a series of loops that have to be done in order to get to the correct
 * work in the AuthorsArray. It then loads the DocumentController of that work it its
 * URL.
 */
-(void)SecondShelfButtonClicked:(id)sender
{
	[self ClearThirdShelf];
	[self ClearSecondShelfFonts];
	
	UIButton *resultButton = (UIButton *)sender;
	UIFont *myFont = [UIFont fontWithName:@"Helvetica-BoldOblique" size:25.0];
	resultButton.titleLabel.font = myFont;
	
	CurrentWork = resultButton.currentTitle;
	
	Work *MyAuth;
	for (Author *auth in AuthorsArray)
	{
		for (Work *worktitle in auth.WorksArray)
		{
			if ([worktitle.name isEqualToString:resultButton.currentTitle])
			{
				MyAuth = worktitle;
				break;
			}
		}
	}
	
	if(MyAuth.workURL != nil)
	{
		DocumentController *doc = [[DocumentController alloc] initWithNibName:@"DocumentController" bundle:nil];
		
		doc.URL = MyAuth.workURL;
		doc.Title = MyAuth.name;
	
		//doc.UserName = UserNameLabel;
		
		[self.navigationController pushViewController:doc animated:YES];
		[doc release];
	}
	else 
	{
		int x_cord = 10;
		for (Work *work in MyAuth.ChaptersArray)
		{
			UIButton *ProgramButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			ProgramButton.frame = CGRectMake(x_cord, 85, 200, 40);
			[ProgramButton.titleLabel setFont:[UIFont systemFontOfSize:25]];
			[ProgramButton setTitle:work.name forState:UIControlStateNormal];
			[ProgramButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
			[ProgramButton setBackgroundColor:[UIColor cyanColor]];
			[ProgramButton setBackgroundImage:BookSpine forState:UIControlStateNormal];
			[ProgramButton setBackgroundImage:BookSpine forState:UIControlStateHighlighted];
			[ProgramButton setBackgroundImage:BookSpine forState:UIControlStateSelected];
			[ProgramButton addTarget:self action:@selector(ThirdShelfButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
			ProgramButton.transform = CGAffineTransformMakeRotation( ( 90 * M_PI ) / 180 );
			[ThirdShelfScroll addSubview:ProgramButton];
			x_cord += 45;
		}
		[ThirdShelfScroll setScrollEnabled:YES];
		[ThirdShelfScroll setContentSize:CGSizeMake(x_cord + 40, ThirdShelfScroll.frame.size.height)];
	}

}

/******************************************************************************
 * This method is used as the selector when when a third level book is selected.
 * There is a series of loops that have to be done in order to get to the correct
 * work in the ChaptersArray. It then loads the DocumentController of that work it its
 * URL.
 */
-(void)ThirdShelfButtonClicked:(id)sender
{
	UIButton *resultButton = (UIButton *)sender;
	
	Work *MyAuth;
	for (Author *auth in AuthorsArray)
	{
		for (Work *worktitle in auth.WorksArray)
		{
			for (Work *chapter in worktitle.ChaptersArray)
			{
				if ([chapter.name isEqualToString:resultButton.currentTitle])
				{
					MyAuth = chapter;
					break;
				}
			}
		}
	}
	DocumentController *doc = [[DocumentController alloc] initWithNibName:@"DocumentController" bundle:nil];
	
	doc.URL = MyAuth.workURL;
	doc.Title = MyAuth.name;
	doc.UserName = UserNameLabel;
	
	[self.navigationController pushViewController:doc animated:YES];
	[doc release];
}


/******************************************************************************
 * This method is needed to reset the fonts of the first shelf. Once a button is
 * clicked. 
 */
-(void)ClearFirstShelfFonts
{
	NSArray *viewsToChange = [self.FirstShelf subviews];
	for (UIView *v in viewsToChange)
	{
		if ([v isKindOfClass: [UIButton class]])
		{
			UIButton *button = (UIButton *)v;
			UIFont *font = [UIFont systemFontOfSize:25.0];
			button.titleLabel.font = font;
		}
		else if ([v isKindOfClass: [UIImageView class]]){
		//	NSLog(@"OTHER");
		}
		
	}	
}

/******************************************************************************
 * This method simply removes all the UIViews from the SecondShelf View. It is 
 * necessary to clear the shelf and load the new books when another 'book' on the
 * shelf is clicked.
 */
-(void)ClearSecondShelf
{
	NSArray *viewsToRemove = [self.SecondShelf subviews];
	for (UIView *v in viewsToRemove)
	{
		[v removeFromSuperview];
	}
}

/******************************************************************************
 * This method is needed to reset the fonts of the second shelf once a button is
 * clicked. 
 */
-(void)ClearSecondShelfFonts
{
	NSArray *viewsToChange = [self.SecondShelf subviews];
	for (UIView *v in viewsToChange)
	{
		if ([v isKindOfClass: [UIButton class]])
		{
			UIButton *button = (UIButton *)v;
			UIFont *font = [UIFont systemFontOfSize:25.0];
			button.titleLabel.font = font;
		}
		else if ([v isKindOfClass: [UIImageView class]]){
		//	NSLog(@"OTHER");
		}		
	}	
}

/******************************************************************************
 * This method is needed to clear the third shelf of all the buttons in it.
 */
-(void)ClearThirdShelf
{
	NSArray *viewsToChange = [self.ThirdShelfScroll subviews];
	for (UIView *v in viewsToChange)
	{
		[v removeFromSuperview];
	}
}


/******************************************************************************
 * This alert get shown when this view is first launched. There are two UITextFields
 * that are created and then added to the alert. Two buttons are also created in the 
 * initialization code. Furthermore the message is set to "\n\n\n..." to 'stretch' the 
 * alertView's boundries to include the two UITextFields.
 */
-(void)ShowAlert
{
	UIAlertView *alertDialog;
	alertDialog = [[UIAlertView alloc]initWithTitle:nil message:@"\n\n\n\n" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:@"clear file", nil];
	
	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *file = [docDir stringByAppendingPathComponent:@"AppUserData.plist"];
	
	// initilize the Dictionary to the appropriate path. The file is AppUserData.plist
	NSDictionary *test = [[NSDictionary alloc] initWithContentsOfFile:file];
	
	NSString *theUser = @"User Name";
	NSString *thePass = @"Pass Word";
	
	if(!test)
	{
		//	NSLog(@"File has not been created");
	}
	else
	{
		theUser = [test objectForKey:@"UserName"];
		thePass = [test objectForKey:@"Password"];
	}
	
	userInput = [[UITextField alloc] initWithFrame:CGRectMake(10.0, 20.0, 260.0, 25.0)];
	[userInput setBackgroundColor:[UIColor whiteColor]];
	[userInput setText:theUser];
	[userInput setClearsOnBeginEditing:YES];
	
	passInput = [[UITextField alloc] initWithFrame:CGRectMake(10.0, 60.0, 260.0, 25.0)];
	[passInput setBackgroundColor:[UIColor whiteColor]];
	[passInput setText:thePass];
	[passInput setClearsOnBeginEditing:YES];
	
	[alertDialog addSubview:userInput];
	[alertDialog addSubview:passInput];
	[alertDialog show];
	[alertDialog release];
	
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{	
	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *file = [docDir stringByAppendingPathComponent:@"AppUserData.plist"];
	
	// initilize the Dictionary to the appropriate path. The file is AppUserData.plist
	NSDictionary *test = [[NSDictionary alloc] initWithContentsOfFile:file];
	
	NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
	if ([buttonTitle isEqualToString:@"ok"])
	{
		NSString *UserName = userInput.text;
		NSString *PassWord = passInput.text;
		
		UserNameLabel = UserName;
		
		label2.text = [NSString stringWithFormat:@"Welcome : %@", UserNameLabel];
		
		NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
							  UserName,
							  @"UserName", 
							  PassWord,
							  @"Password", 
							  nil];
		
		[dict writeToFile:file atomically: TRUE];
		self.navigationItem.rightBarButtonItem = nil;
		
		UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(LogoutButtonClicked)];          
		self.navigationItem.rightBarButtonItem = anotherButton;
		[anotherButton release];
	}
	else if([buttonTitle isEqualToString:@"clear file"])
	{
		if(test)
		{
			NSFileManager *fileManager = [NSFileManager defaultManager];
			[fileManager removeItemAtPath:file error:NULL];
		}
		else 
		{
			//	NSLog(@"File was never created");
		}
	}
}

-(void)SetUpLoginButton
{
	self.navigationItem.rightBarButtonItem = nil;
	UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(ShowAlert)];          
	self.navigationItem.rightBarButtonItem = anotherButton;
	[anotherButton release];	
}

-(void)LogoutButtonClicked
{
	[self SetUpLoginButton];
	
	UserNameLabel = nil;
	label2.text = [NSString stringWithFormat:@"Welcome : %@", UserNameLabel];
}

- (void)dealloc {
    [super dealloc];
}

@end
