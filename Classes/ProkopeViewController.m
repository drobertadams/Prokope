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

@implementation ProkopeViewController

@synthesize BookShelfImage, SecondShelf, ThirdShelf, CommentaryView, FirstShelf, label2;


/******************************************************************************
 * This method is used by the ProkopeAppDelegate to populate this Array.
 */
-(void)SetDataArray:(NSMutableArray *)dataArray
{
	AuthorsArray = dataArray;
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
 * This method is called when the view is loaded. Custom code is called to configure
 * the application.
 */
-(void)viewDidLoad
{
	
	ClickedFont = [UIFont fontWithName:@"Helvetica-BoldOblique" size:25.0];
	ControlFont = [UIFont systemFontOfSize:25];
	
	self.title = @"Prokope - Intermediate Latin Reader";
	[super viewDidLoad];
	
	FirstShelf.tag = 1;
	FirstShelf.delegate = self;
	
	SecondShelf.tag = 2;
	SecondShelf.delegate = self;
	
	ThirdShelf.tag = 3;
	ThirdShelf.delegate = self;
	
	[self setUpNavBar];
	[self SetUpLoginButton];
	
	BookSpine = [UIImage imageNamed:@"BookSpine2.png"];
	
	[CommentaryView setBackgroundColor:[UIColor clearColor]];
	
	UIImage *image_left = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"more-icon-left" ofType:@"png"]];
	UIImage *image_right = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"more-icon" ofType:@"png"]];
	
	SecondShelfLeftImage = [[UIImageView alloc]initWithImage:image_left];
	SecondShelfRightImage = [[UIImageView alloc]initWithImage:image_right];
	
	FirstShelfLeftImage = [[UIImageView alloc] initWithImage:image_left];
	FirstShelfRightImage = [[UIImageView alloc] initWithImage:image_right];
	
	ThirdShelfLeftImage = [[UIImageView alloc] initWithImage:image_left];
	ThirdShelfRightImage = [[UIImageView alloc] initWithImage:image_right];
	
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
	
	[self ForceScroll:FirstShelf];
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
	
	
	//label2 = [[UILabel alloc] initWithFrame:CGRectMake(-350, 10, 350, 16)];
	label2 = [[UILabel alloc] initWithFrame:CGRectMake(305, 10, 295, 16)];
	label2.tag = 2;
	label2.backgroundColor = [UIColor clearColor];
	label2.font = [UIFont boldSystemFontOfSize:17];
	label2.adjustsFontSizeToFitWidth = YES;
	label2.textAlignment = UITextAlignmentRight;
	label2.textColor = [UIColor blackColor];
	NSString *UserNameLabel = @"";
	label2.text = [NSString stringWithFormat:@"Welcome : %@", UserNameLabel];
	label2.highlightedTextColor = [UIColor blackColor];
	[NavBarView addSubview:label2];
	[label2 release];
	
	self.navigationItem.titleView = NavBarView;
	
	// This button will be added later on.
	//UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear User Info" style:UIBarButtonItemStylePlain target:self action:@selector(ClearUserSettings)];          
	//self.navigationItem.leftBarButtonItem = anotherButton;
	//[anotherButton release];
	
}

/******************************************************************************
 * This method is the selector for the clear user settings button. It makes an alertview where the user can opt 
 * out if they want.
 */
-(void)ClearUserSettings
{	
	UIAlertView *alertDialog;
	alertDialog = [[UIAlertView alloc]initWithTitle:@"Clear User Settings ?" message:@"Are you sure you want to clear your settings" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:@"cancel", nil];
	alertDialog.tag = 2;

	[alertDialog show];
	[alertDialog release];
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
	
	[SecondShelf setScrollEnabled:YES];
	[SecondShelf setShowsHorizontalScrollIndicator:YES];
	[SecondShelf setContentSize:CGSizeMake(second_shelf_x_cord, SecondShelf.frame.size.height)];
	
	[self ForceScroll:SecondShelf];
	
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
		DocumentController *doc = [[DocumentController alloc] initWithNibName:@"DocumentController" bundle:nil];
		
		doc.URL = MyAuth.workURL;
		doc.Title = MyAuth.name;

		NSString *str = [label2 text];
		
		// strips away the 'Welcome : ' part of the user login label.
		NSString *TheName = [str substringFromIndex:10];
		doc.UserName = TheName;
		
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
		[ThirdShelf setScrollEnabled:YES];
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
	
	NSString *str = [label2 text];
	
	NSString *TheName = [str substringFromIndex:10];
	doc.UserName = TheName;
	
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
	alertDialog = [[UIAlertView alloc]initWithTitle:nil message:@"\n\n\n\n" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:@"cancel", nil];
	alertDialog.tag = 1;
	
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
				
			label2.text = [NSString stringWithFormat:@"Welcome : %@", UserName];
		
			NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
							  UserName,
							  @"UserName", 
							  PassWord,
							  @"Password", 
							  nil];
		
			[dict writeToFile:file atomically: TRUE];
			self.navigationItem.rightBarButtonItem = nil;
		
			// Once the user is loged in, we can now switch the button to log the user out. See the selector to see the corresponding method that gets called. 
			UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(LogoutButtonClicked)];          
			self.navigationItem.rightBarButtonItem = anotherButton;
			[anotherButton release];
		}
	}
	// The alertView that has the tag == 2 is the one that clears the contents of the AppUserData.plist file. 
	else if (alertView.tag == 2)
	{
		if([buttonTitle isEqualToString:@"ok"])
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
	}
}

/******************************************************************************
 * This method populates the login button for the navigation bar. 
 */
-(void)SetUpLoginButton
{
	self.navigationItem.rightBarButtonItem = nil;
	UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(ShowAlert)];          
	self.navigationItem.rightBarButtonItem = anotherButton;
	[anotherButton release];	
}

/******************************************************************************
 * This method gets called when the logout button is clicked. 
 */
-(void)LogoutButtonClicked
{
	[self SetUpLoginButton];
	
	NSString *UserNameLabel = @"";
	label2.text = [NSString stringWithFormat:@"Welcome : %@", UserNameLabel];
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
	    [self DisplayHelperImage:p.x scrollView:FirstShelf LeftImage:FirstShelfLeftImage RightImage:FirstShelfRightImage ShelfCord:first_shelf_x_cord];	
	}
	else if (inscrollView.tag == 2)
	{
		[self DisplayHelperImage:p.x scrollView:SecondShelf LeftImage:SecondShelfLeftImage RightImage:SecondShelfRightImage ShelfCord:second_shelf_x_cord];
	}
	else if (inscrollView.tag == 3)
	{
		[self DisplayHelperImage:p.x scrollView:ThirdShelf LeftImage:ThirdShelfLeftImage RightImage:ThirdShelfRightImage ShelfCord:third_shelf_x_cord];
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
	LeftImage:(UIImageView *)LeftImage RightImage:(UIImageView *)RightImage ShelfCord:(int)ShelfCord
{
	int size = 30;
	int y_placement = (scroll.frame.size.height / 2) - (size / 2);
	
	// if the x_cord is < than the frame then there is nothing to scroll.
	if(ShelfCord < scroll.frame.size.width)
	{
		[LeftImage removeFromSuperview];
		[RightImage removeFromSuperview];
		return;
	}
	// This means it is in there is content to the right and to the left of the contentOffset.
	if( (scroll.frame.size.width + offset < ShelfCord) && (offset > 0) )
	{
		LeftImage.frame = CGRectMake(offset + 10, y_placement, size, size);
		[scroll addSubview:LeftImage];
		
		RightImage.frame = CGRectMake( (scroll.frame.size.width + offset) - 50, y_placement, size, size);
		[scroll addSubview:RightImage];
		return;
	}
	// This means the content offset is at the right side of the scroll view.
	if ( scroll.frame.size.width + offset >= ShelfCord )
	{
		[RightImage removeFromSuperview];
		
		LeftImage.frame = CGRectMake(offset + 10, y_placement, size, size);
		[scroll addSubview:LeftImage];
	}
	// This means the content offset is at 0 (or lower), and therefore on the left side of the screen.
	else if (offset <= 0)
	{
		[LeftImage removeFromSuperview];
		
		RightImage.frame = CGRectMake( (scroll.frame.size.width + offset) - 50, y_placement, size, size);
		[scroll addSubview:RightImage];
	} 
}

- (void)dealloc {
    [super dealloc];
}

@end
