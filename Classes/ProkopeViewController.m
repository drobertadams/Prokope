//
//  ProkopeViewController.m
//  Prokope
//
//  Created by D. Robert Adams on 5/9/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import "DocumentController.h"
#import "ProkopeViewController.h"
#import "Author.h"
#import "Work.h"
#import "LoginAlertViewDelegate.h"
#import "RegistrationController.h"

@implementation ProkopeViewController

@synthesize BookShelfImage, SecondShelf, ThirdShelf, CommentaryView, FirstShelf, label2;


/******************************************************************************
 * This method is used by the ProkopeAppDelegate to populate this Array.
 */
-(void)SetDataArray:(NSMutableArray *)dataArray
{
	AuthorsArray = dataArray;
}

// Look into why scrolls doesn't work for i-pad.
// salting on the i-pad.


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
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
 * This method is called when the view is loaded. Custom code is called to configure
 * the application.
 */
-(void)viewDidLoad
{
	[super viewDidLoad];
	ClickedFont = [UIFont fontWithName:@"Helvetica-BoldOblique" size:25.0];
	ControlFont = [UIFont systemFontOfSize:25];
	
	self.title = @"Prokope - Intermediate Latin Reader";
	[CommentaryView setBackgroundColor:[UIColor clearColor]];
	
	[self setUpNavBar];
	[self SetUpLoginButton];
	
	FirstShelf.tag = 1;
	FirstShelf.delegate = self;
	
	SecondShelf.tag = 2;
	SecondShelf.delegate = self;
	
	ThirdShelf.tag = 3;
	ThirdShelf.delegate = self;
	
	// these images are constants for this controller. The image_left and image_right UIImages are for the buttons on the shelves
	// to indicate if there is more content that can be scrolled to. 
	BookSpine = [UIImage imageNamed:@"BookSpine2.png"];
	image_left = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"more-icon-left" ofType:@"png"]];
	image_right = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"more-icon" ofType:@"png"]];
	
	first_shelf_x_cord = -55;
	// This loop populates the 'top shelf' of the BookShelfImage.
	for (Author *a in AuthorsArray)
	{
		UIButton *ProgramButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		ProgramButton.frame = CGRectMake(first_shelf_x_cord, 60, FirstShelf.frame.size.height, 60);
		[ProgramButton.titleLabel setFont:ControlFont];
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
		first_shelf_x_cord += 65;
	}
	first_shelf_x_cord += 55;
	
	[FirstShelf setScrollEnabled:YES];
	[FirstShelf setShowsHorizontalScrollIndicator:YES];
	[FirstShelf setContentSize:CGSizeMake(first_shelf_x_cord, FirstShelf.frame.size.height)];
	
	[SecondShelf setScrollEnabled:YES];
	[SecondShelf setShowsHorizontalScrollIndicator:YES];
	
	[ThirdShelf setScrollEnabled:YES];
	[ThirdShelf setShowsHorizontalScrollIndicator:YES];

	// These series of 6 buttons are the buttons on the book shelves to indicate if there is content that can be scrolled to.
	// There is a right and left button on each shelf, and each button has been given a tag that the code can later reference.
	FirstLeftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self InitalizeButton:FirstLeftButton Tag:21 Shelf:FirstShelf Side:@"Left"];
	
	FirstRightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self InitalizeButton:FirstRightButton Tag:22 Shelf:FirstShelf Side:@"Right"];
	
	SecondLeftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self InitalizeButton:SecondLeftButton Tag:23 Shelf:SecondShelf Side:@"Left"];
	
	SecondRightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self InitalizeButton:SecondRightButton Tag:24 Shelf:SecondShelf Side:@"Right"];
	
	ThirdLeftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self InitalizeButton:ThirdLeftButton Tag:25 Shelf:ThirdShelf Side:@"Left"];	
	
	ThirdRightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self InitalizeButton:ThirdRightButton Tag:26 Shelf:ThirdShelf Side:@"Right"];
	
	[self ForceScroll:FirstShelf];
	
	logedin = FALSE;
}

/******************************************************************************
 * This method allows you to inialize a button and assign it to UIScrollView. It saves on repeating the same
 * code for the 6 different buttons. 
 */
-(void)InitalizeButton:(UIButton *)Button Tag:(int)tag Shelf:(UIScrollView *)Shelf Side:(NSString *)Side
{
	NSString *myselector;
	UIImage *myImage;
	
	if([Side isEqualToString:@"Right"])
	{
		myselector = @"accelorateRight:";
		myImage = image_right;
	}
	else
	{
		myselector = @"accelorateLeft:";
		myImage = image_left;	
	}
	
	[Button setBackgroundImage:myImage forState:UIControlStateNormal];
	[Button setBackgroundImage:myImage forState:UIControlStateHighlighted];
	[Button setBackgroundImage:myImage forState:UIControlStateSelected];
	[Button addTarget:self action:NSSelectorFromString(myselector) forControlEvents:UIControlEventTouchUpInside];
	Button.tag=tag;
	[Shelf addSubview:Button];
}

/******************************************************************************
 * This method is called when a button on the left side of the scroll view is clicked. 
 * Meaning the user wants to scroll all the way to the left of the shelf.
 */
-(void)accelorateLeft:(id)sender
{
	UIScrollView *scroll;
	int x_cord;
	
	int tid = [sender tag];
	// if the tag is 21 we know it is the left button on the first shelf since we tagged it.
	if (tid == 21)
	{
		scroll = FirstShelf;
		x_cord = first_shelf_x_cord;
	}
	else if (tid == 23)
	{
		scroll = SecondShelf;
		x_cord = second_shelf_x_cord;
	}
    else if (tid == 25)
	{
		scroll = ThirdShelf;
		x_cord = third_shelf_x_cord;
	}
	else
	{
		return;
	}
	
	CGPoint offset = scroll.contentOffset;
    offset.x = 0;
    offset.y = 0;
    [scroll setContentOffset:offset animated:YES];	
}

/******************************************************************************
 * This method is called when a button on the right side of the scroll view is clicked. 
 * Meaning the user wants to scroll all the way to the right of the shelf.
 */
-(void)accelorateRight:(id)sender
{	
	UIScrollView *scroll;
	int x_cord;
	
	int tid = [sender tag];
	// if the tag is 22 we know it is the right button on the first shelf since we tagged it. 
	if (tid == 22)
	{
		scroll = FirstShelf;
		x_cord = first_shelf_x_cord;
	}
	else if (tid == 24)
	{
		scroll = SecondShelf;
		x_cord = second_shelf_x_cord;
	}
	else if (tid == 26)
	{
		scroll = ThirdShelf;
		x_cord = third_shelf_x_cord;
	}
	else
	{
		return;
	}
	
	CGPoint offset = scroll.contentOffset;
	// This calculation scrolls us to the very right of the scrollview. 
    offset.x = x_cord - scroll.frame.size.width;
    offset.y = 0;
    [scroll setContentOffset:offset animated:YES];
}

/******************************************************************************
 * This method is called when the view is loaded. It sets up some subviews for the navigation bar.
 */
-(void)setUpNavBar
{	
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
	
	self.navigationItem.titleView = NavBarView;
}

/******************************************************************************
 * This method is called when something in the table was clicked. It creates a SecondNavigation
 * object and sets its array to the WorksArray of the corresponding cell that was clicked.
 */
-(void)FirstShelfButtonClicked:(id)sender
{
	
	[self ClearShelf:self.SecondShelf];
	[self ClearShelf:self.ThirdShelf];
	[self ClearShelfFonts:self.FirstShelf];
	
	UIButton *resultButton = (UIButton *)sender;
	CurrentAuthor = resultButton.currentTitle;
	resultButton.titleLabel.font = ClickedFont;
	
	Author *MyAuth;
	for (Author *auth in AuthorsArray)
	{
		if([auth.name isEqualToString:resultButton.currentTitle])
		{
			MyAuth = auth;
			break;
		}
	}
	
	second_shelf_x_cord = -80;
	
	// This loop adds the books on the second level of the book shelf.
	for (Work *work in MyAuth.WorksArray)
	{
		UIButton *ProgramButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		ProgramButton.frame = CGRectMake(second_shelf_x_cord, 85, SecondShelf.frame.size.height, 40);
		[ProgramButton.titleLabel setFont:ControlFont];
		[ProgramButton setTitle:work.name forState:UIControlStateNormal];
		[ProgramButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
		[ProgramButton setBackgroundImage:BookSpine forState:UIControlStateNormal];
		[ProgramButton setBackgroundImage:BookSpine forState:UIControlStateHighlighted];
		[ProgramButton setBackgroundImage:BookSpine forState:UIControlStateSelected];
		// The selector is set to SecondShelfButtonClicked method in this class. 
		[ProgramButton addTarget:self action:@selector(SecondShelfButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
		
		// This line of code rotates the button to be facing vertical.
		ProgramButton.transform = CGAffineTransformMakeRotation( ( 90 * M_PI ) / 180 );
		[SecondShelf addSubview:ProgramButton];
		second_shelf_x_cord += 45;
	}
	second_shelf_x_cord += 80;
	
	[SecondShelf setContentSize:CGSizeMake(second_shelf_x_cord, SecondShelf.frame.size.height)];
	
	[self ForceScroll:SecondShelf];
	[self ForceScroll:ThirdShelf];
	
	NSString *ShelfImage = [NSString stringWithFormat:@"<img width='100px' height='100px' align ='left' style='padding:5px' src='%@' />", MyAuth.iconURL]; 
	NSString *HTML = [ShelfImage stringByAppendingString:MyAuth.bio];	
	
	[CommentaryView loadHTMLString:HTML baseURL:nil];
}

/******************************************************************************
 * The idea behind the force scroll method is twofold :
 * 1) It will automatically set the contentOffset to 0, which will set it to the scroll to the original position.
 * 2) by changing the scollview's position programmatically it will kickoff the viewdidscoll method for that 
 * scrollview. That method will kickoff the method to display the images if there is scrollable content. These images
 * are loaded before the user has even touched the scroll bar.
 */
-(void)ForceScroll:(UIScrollView *)scroll
{
	CGPoint offset = scroll.contentOffset;
    offset.x = -10;
    offset.y = 0;
    [scroll setContentOffset:offset animated:NO];
	
	offset = scroll.contentOffset;
    offset.x = 0;
    offset.y = 0;
    [scroll setContentOffset:offset animated:NO];
}

/******************************************************************************
 * This method is used as the selector when when a second level book is selected.
 * There is a series of loops that have to be done in order to get to the correct
 * work in the AuthorsArray. It then loads the DocumentController of that work it its
 * URL.
 */
-(void)SecondShelfButtonClicked:(id)sender
{
	[self ClearShelfFonts:self.SecondShelf];
	[self ClearShelf:self.ThirdShelf];
	
	UIButton *resultButton = (UIButton *)sender;
	resultButton.titleLabel.font = ClickedFont;
	
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
		[self ForceScroll:ThirdShelf];
		
		DocumentController *doc = [[DocumentController alloc] initWithNibName:@"DocumentController" bundle:nil];
		
		doc.URL = MyAuth.workURL;
		doc.Title = MyAuth.name;

		doc.UserName = TheUserName;
		
		[self.navigationController pushViewController:doc animated:YES];
		[doc release];
	}
	else 
	{
		third_shelf_x_cord = -75;
		for (Work *work in MyAuth.ChaptersArray)
		{
			UIButton *ProgramButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			ProgramButton.frame = CGRectMake(third_shelf_x_cord, 75, ThirdShelf.frame.size.height, 40);
			[ProgramButton.titleLabel setFont:ControlFont];
			[ProgramButton setTitle:work.name forState:UIControlStateNormal];
			[ProgramButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
			[ProgramButton setBackgroundImage:BookSpine forState:UIControlStateNormal];
			[ProgramButton setBackgroundImage:BookSpine forState:UIControlStateHighlighted];
			[ProgramButton setBackgroundImage:BookSpine forState:UIControlStateSelected];
			[ProgramButton addTarget:self action:@selector(ThirdShelfButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
			
			ProgramButton.transform = CGAffineTransformMakeRotation( ( 90 * M_PI ) / 180 );
			[ThirdShelf addSubview:ProgramButton];
			third_shelf_x_cord += 45;
		}
		third_shelf_x_cord += 75;
	
		[ThirdShelf setContentSize:CGSizeMake(third_shelf_x_cord, ThirdShelf.frame.size.height)];
		
		[self ForceScroll:ThirdShelf];
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
	
	doc.UserName = TheUserName;
	
	[self.navigationController pushViewController:doc animated:YES];
	[doc release];
}


/******************************************************************************
 * This method is needed to reset the fonts of the first shelf. Once a button is
 * clicked. 
 */
-(void)ClearShelfFonts:(UIScrollView *)BookShelfScrollView
{
	NSArray *viewsToChange = [BookShelfScrollView subviews];
	for (UIView *v in viewsToChange)
	{
		if ([v isKindOfClass: [UIButton class]])
		{
			UIButton *button = (UIButton *)v;
			button.titleLabel.font = ControlFont;
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
-(void)ClearShelf:(UIScrollView *)BookShelfScrollView
{
	NSArray *viewsToRemove = [BookShelfScrollView subviews];
	for (UIView *v in viewsToRemove)
	{
		if ([v isKindOfClass: [UIButton class]])
		{
		     UIButton *b = (UIButton*)v;
			 int t = [b tag];
			 // we don't want to get rid of these six buttons because they are the left and right buttons on the shelves.
			 if (t== 21 || t == 22 || t == 23 || t == 24 || t == 25 || t == 26)
			 {
				// NSLog(@"Except %i", t);
			 }
			 else
			 {
				 [b removeFromSuperview];
			 }
		}
	}
	third_shelf_x_cord = 0;
	[ThirdShelf setContentSize:CGSizeMake(0, 0)];
}

/******************************************************************************
 * This alert get shown when this view is first launched. There are two UITextFields
 * that are created and then added to the alert. Two buttons are also created in the 
 * initialization code. Furthermore the message is set to "\n\n\n..." to 'stretch' the 
 * alertView's boundries to include the two UITextFields.
 */
-(void)ShowAlert
{
	[self showActionSheet];
}

-(void)showActionSheet
{
	NSString *login_string;
	NSString *register_string;
	if(logedin == TRUE)
	{
		NSString *login_name = [self.navigationItem.rightBarButtonItem title];
	    login_string = @"Logout";
		register_string = [NSString stringWithFormat:@"Edit Profile (%@)", login_name];
	}
	else
	{
		login_string = @"Login";
		register_string = @"Register Profile";
	}
	
	if(!popupQuery)
	{
		popupQuery = [[UIActionSheet alloc] initWithTitle:@"Options" delegate:self cancelButtonTitle:@"no" destructiveButtonTitle:nil otherButtonTitles:login_string, register_string, @"forget me", nil];
		popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
		[popupQuery showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
		[popupQuery release];
	}
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *file = [docDir stringByAppendingPathComponent:@"AppUserData.plist"];
	
	// initilize the Dictionary to the appropriate path. The file is AppUserData.plist
	NSDictionary *test = [[NSDictionary alloc] initWithContentsOfFile:file];
	
	if (buttonIndex == 0)
	{
		if(logedin == TRUE)
		{
			logedin = FALSE;
			TheUserName = @"";
			ThePassWord = @"";
			[self.navigationItem.rightBarButtonItem setTitle:@"Profile"];
		}
		else 
		{
			UIAlertView *alertDialog;
			alertDialog = [[UIAlertView alloc]initWithTitle:nil message:@"\n\n\n\n\n" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:@"cancel", nil];
			alertDialog.tag = 1;
			 
			NSString *theUser = @"E-mail";
			NSString *thePass = @"Pass Word";
			
			if(!test)
			{
			//	NSLog(@"File has not been created");
			}
			else
			{
				theUser = [test objectForKey:@"E-mail"];
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
	}
	else if (buttonIndex == 1)
	{
		
		RegistrationController *reg = [[RegistrationController alloc] initWithNibName:@"RegistrationController" bundle:nil];
	
		if(logedin == TRUE)
		{

			[reg SetInitialData:TheUserName Password:ThePassWord Professor:Professor];
			
			[reg UserLogedIn:YES];
		}
		[self.navigationController pushViewController:reg animated:YES];
		[reg release];
	}
	else if (buttonIndex == 2)
	{
	    if(test)
		{
			NSFileManager *fileManager = [NSFileManager defaultManager];
			[fileManager removeItemAtPath:file error:NULL];
		}
		else 
		{
			NSLog(@"File was never created");
		} 
    }
	popupQuery = nil;
}


/******************************************************************************
 * This method gets called when an alertview's button gets clicked. 
 */
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{	
	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *file = [docDir stringByAppendingPathComponent:@"AppUserData.plist"];
	
	// initilize the Dictionary to the appropriate path. The file is AppUserData.plist
	NSDictionary *test = [[NSDictionary alloc] initWithContentsOfFile:file];
	
	NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
	// The alertview with tag == 1 is the one that contains the dialog to log users in.
	if(alertView.tag == 1)
	{
		if ([buttonTitle isEqualToString:@"ok"])
		{
			NSString *UserName = [userInput text];
			NSString *PassWord = [passInput text];
			
			NSData *data = [UserName dataUsingEncoding:NSASCIIStringEncoding];
			UserName = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
			data = [PassWord dataUsingEncoding:NSASCIIStringEncoding];
			PassWord = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
			
			NSString *StringUrl = [NSString stringWithFormat:@"https://www.cis.gvsu.edu/~prokope/index.php/rest/login/"
				"username/%@/password/%@", UserName, PassWord];
			
			StringUrl = [StringUrl stringByReplacingOccurrencesOfString:@"@" withString:@"%40"];
			
			NSURL *url = [NSURL URLWithString:StringUrl];
			data = [NSData dataWithContentsOfURL: url];
			NSXMLParser *parse = [[NSXMLParser alloc] initWithData:data];
			[parse setDelegate:self];
			[parse parse];
			[parse release];
			
			NSString *theUser = [test objectForKey:@"E-mail"];
			NSString *thePass = [test objectForKey:@"Password"];
			
			if(LoginResult == 1)
			{			
				if ([[userInput text] isEqualToString:theUser])
				{
					NSLog(@"Match");
				}
				else
				{ 
					UIAlertView *alertDialog;
					NSString *dialog_message = [NSString stringWithFormat:@"%@ is not the default profile, would you like it to be ?", UserName];
					alertDialog = [[UIAlertView alloc]initWithTitle:nil message:dialog_message delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
					alertDialog.tag = 5;
					
					[alertDialog show];
					[alertDialog release];
				}
				logedin = TRUE;
		
				TheUserName = UserName;
				ThePassWord = PassWord;
				
				[self.navigationItem.rightBarButtonItem setTitle:UserName];
			}
			// If the LoginResult comes back as anything other than -1 we know the login information was not correct. 
			else
			{
				UIAlertView *alertDialog;
				NSString *dialog_message = @"Your login was unsucessful";
				alertDialog = [[UIAlertView alloc]initWithTitle:nil message:dialog_message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
				
				[alertDialog show];
				[alertDialog release];
			}
		}
	}
	// The alertview with a 5 is the one asking if the user wants to save the profile locally.
	else if(alertView.tag == 5)
	{
		if ([buttonTitle isEqualToString:@"YES"])
		{
			
			NSString *UserName = [userInput text];
			NSString *PassWord = [passInput text];
			
			NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
								  UserName, @"E-mail", 
								  PassWord, @"Password", nil];
			
			[self.navigationItem.rightBarButtonItem setTitle:UserName];
			[dict writeToFile:file atomically: TRUE];
		}
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if ([CurrentTag isEqualToString:@"result"])
	{		
		if ([string isEqualToString:@"-1"])
		{
			LoginResult = -1;
		}
		else
		{
		    LoginResult = 1;
			
			// This needs to be converted into a NSData object and then back. 
			NSData *data = [string dataUsingEncoding:NSASCIIStringEncoding];
        	Professor = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
		}
		NSLog(@"%@", string);
	}
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict
{	
	if([elementName isEqualToString:@"result"])
	{
		CurrentTag = @"result";
	}
	else
	{
		CurrentTag = "Unknown";
	}
}

/******************************************************************************
 * This method populates the login button for the navigation bar. 
 */
-(void)SetUpLoginButton
{
	self.navigationItem.rightBarButtonItem = nil;
	UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Profile" style:UIBarButtonItemStylePlain target:self action:@selector(ShowAlert)];          
	self.navigationItem.rightBarButtonItem = anotherButton;
	[anotherButton release];	
}


/******************************************************************************
 * This method is one of the central methods for the UIScrollView delegate protocol.
 * This gets called whenever a scrollview has scrolled. This code responds to different
 * events such as displaying images based on the position of the current scroll position.
 * This is found by getting the contentOffset for that ScrollView. 
 */
- (void)scrollViewDidScroll:(UIScrollView *)inscrollView
{

	CGPoint	p = inscrollView.contentOffset;
	if (inscrollView.tag == 1)
	{
		[self DisplayHelperImage:p.x scrollView:FirstShelf LeftImage:FirstLeftButton RightImage:FirstRightButton ShelfCord:first_shelf_x_cord];	
	}
	else if (inscrollView.tag == 2)
	{
		[self DisplayHelperImage:p.x scrollView:SecondShelf LeftImage:SecondLeftButton RightImage:SecondRightButton ShelfCord:second_shelf_x_cord];
	}
	else if (inscrollView.tag == 3)
	{
		[self DisplayHelperImage:p.x scrollView:ThirdShelf LeftImage:ThirdLeftButton RightImage:ThirdRightButton ShelfCord:third_shelf_x_cord];
	}
}

/******************************************************************************
 * This method handels the calls from the ScrollViewDidScroll method. This method allows for 
 * each scroll view to recieve the same action. The parameters are as follows. 
 * 1) the offset. It is always set to the currentOffset of the scroll view. See method above.
 * 2) The ScrollView. 
 * 3 & 4) Left and Right Images. Each scroll view has this pair of images. These are sent as parameters so the method can 
 * add/remove the correct UIImageViews.
 * 5) The size of the current scroll view is kept in int variables for each of the three scrolls. These values will change
 * all the time so we need to always pass in the latest values.
 */
-(void)DisplayHelperImage:(int)offset scrollView:(UIScrollView *)scroll 
	LeftImage:(UIButton *)LeftImage RightImage:(UIButton *)RightImage ShelfCord:(int)ShelfCord
{
	int size = 30;
	int x_left_placement = offset + 10;
	// the right_placement is calculated by moving 50 pixels to the left of the right edge of the scrollview.
	int x_right_placement = (scroll.frame.size.width + offset) - 50;
	int y_placement = (scroll.frame.size.height / 2) - (size / 2);
	
	// if the x_cord is < than the frame then there is nothing to scroll.
	if(ShelfCord < scroll.frame.size.width)
	{
		LeftImage.hidden = YES;
		RightImage.hidden = YES;
		return;
	} 
	// This means it is in there is content to the right and to the left of the contentOffset.
	if( (scroll.frame.size.width + offset < ShelfCord) && (offset > 0) )
	{
		LeftImage.frame = CGRectMake(x_left_placement, y_placement, size, size);
		LeftImage.hidden = NO;
		
		RightImage.frame = CGRectMake(x_right_placement, y_placement, size, size);
		RightImage.hidden = NO;
		
		[scroll bringSubviewToFront:LeftImage];
		[scroll bringSubviewToFront:RightImage];
		return;
	}
	// This means the content offset is at the right side of the scroll view.
	if ( scroll.frame.size.width + offset >= ShelfCord )
	{
		RightImage.hidden = YES;
		
		LeftImage.frame = CGRectMake(x_left_placement, y_placement, size, size);
		LeftImage.hidden = NO;
        [scroll bringSubviewToFront:LeftImage];
	}
	// This means the content offset is at 0 (or lower), and therefore on the left side of the screen.
	else if (offset <= 0)
	{
		LeftImage.hidden = YES;

		RightImage.frame = CGRectMake(x_right_placement, y_placement, size, size);
		RightImage.hidden = NO;
		[scroll bringSubviewToFront:RightImage];
	}	
}


- (void)dealloc {
    [super dealloc];
}

@end
