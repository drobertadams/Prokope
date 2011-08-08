    //
//  RegistrationController.m
//  Prokope
//
//  Created by Justin Antranikian on 6/23/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import "RegistrationController.h"
#import "Reachability.h" 

@implementation RegistrationController

@synthesize EmailText, PassWordText, PassWordConfirmText, ProfessorText, 
    ProfessorTable, StatusLabel, RegisterButton, controller, PassWordStatus, PassWordLabel, EmailLabel, ProfessorLabel;

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

/******************************************************************************
 * auto created method.
 */
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];    
    // Release any cached data, images, etc. that aren't in use.
}

/******************************************************************************
 * auto created method.
 */
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;	
}

/******************************************************************************
 * auto created method. Have to remove the observer and release internetReach.
 */
- (void) viewWillDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[internetReach release];
}


/******************************************************************************
 * Override to allow orientations other than the default portrait orientation..
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

/******************************************************************************
 * We return one for this because there is one entry per row in the table.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

/******************************************************************************
 * We specify the size of the table here.
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [ProfessorsArray count];
}

/******************************************************************************
 * We load the data for the cells here.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	// we assign the cell's text to the name in the Professor's array.
    NSString *a = [ProfessorsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = a;
	
    return cell;
}

/******************************************************************************
 * We respond to clicks (touches) on the table here.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[ProfessorTable deselectRowAtIndexPath:indexPath animated:YES];
	
	NSString *a = [ProfessorsArray objectAtIndex:indexPath.row];
	[ProfessorText setText:a];
}

/******************************************************************************
 * auto created method. Called when the view is loaded. A constructor basically.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
	
	ProfessorsDataPopulated = FALSE;
	
	internetReach = [[Reachability reachabilityForInternetConnection] retain];
	[internetReach startNotifier];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
	[self UpdateInternetConnectionStatus];
	
	if (self.controller.logedin)
	{
		[EmailText setText:self.controller.TheUserName];
		[PassWordText setText:self.controller.ThePassWord];
		[PassWordConfirmText setText:self.controller.ThePassWord];
		[ProfessorText setText:self.controller.Professor];
		if (![[ProfessorText text] isEqualToString:@""])
		{
			[ProfessorLabel setText:@""];
		}
		[PassWordLabel setText:@"New Password"];
		[RegisterButton setTitle:@"Update" forState:UIControlStateNormal];
		[TitleLabel setText:[NSString stringWithFormat:@"Update Profile : %@", self.controller.TheUserName]];
	}	
	ProfessorsArray = [[NSMutableArray alloc] initWithCapacity:100];
	
	if(InternetConnection == TRUE)
	{
		[self PopulateProfessorsTable];
	}
	ProfessorTable.delegate = self;
	ProfessorTable.dataSource = self;	
}

/******************************************************************************
 * This method is part of the reachability api. This gets called whenever there is
 * a change in the status of the internet connection.
 */
-(void)reachabilityChanged:(NSNotification *)note
{
	[self UpdateInternetConnectionStatus];
}

/******************************************************************************
 * This method is called when the internet connection status is changed. When the
 * reachabilityChanged method is triggered by the NotificationCenter, it calls this 
 * method. We can also call this method when we first load the view.
 */
-(void)UpdateInternetConnectionStatus
{	
	NetworkStatus internetStatus = [internetReach currentReachabilityStatus];
	
	switch (internetStatus)
	{
		case NotReachable:
		{
			UIAlertView *connectionAlert = [[UIAlertView alloc] initWithTitle:@"No internet connection" message:@"Please check your network conenction" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil]; 
			[connectionAlert show];
			[connectionAlert release];
			RegisterButton.enabled = FALSE;
			RegisterButton.alpha = 0.5f;
			InternetConnection = FALSE;
			break;
		}
		case ReachableViaWiFi:
		{
			RegisterButton.enabled = TRUE;
			RegisterButton.alpha = 1.0f;
			InternetConnection = TRUE;
			if (ProfessorsDataPopulated == FALSE)
			{
				[self PopulateProfessorsTable];
			}
			break;
		}
		case ReachableViaWWAN:
		{
			RegisterButton.enabled = TRUE;
			RegisterButton.alpha = 1.0f;
			InternetConnection = TRUE;
			if (ProfessorsDataPopulated == FALSE)
			{
				[self PopulateProfessorsTable];
			}
			break;
		}
	}
}

/******************************************************************************
 * A convience method to keep from repeating the same code. There are multiple ways
 * the ProfessorsTable can be populated. Since it uses REST it requires an internet
 * connection. Therefore if there is no connection when the view is loaded, we will 
 * have to wait until the connection becomes available to get the data. 
 */
-(void)PopulateProfessorsTable
{
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.cis.gvsu.edu/~prokope/index.php/rest/professor"]];
	NSData *data = [NSData dataWithContentsOfURL: url];
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
	[parser setDelegate:self];
	[parser parse];
	[parser release];
	[ProfessorTable reloadData];
	ProfessorsDataPopulated = TRUE;
}

/******************************************************************************
 * This method responds to clicks for the register/update button.
 */
-(IBAction)RegisterButtonClicked:(id)sender
{	
	UIButton *resultButton = (UIButton *)sender;
	NSString *ButtonTitle = [resultButton currentTitle];
	
	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *file = [docDir stringByAppendingPathComponent:@"AppUserData.plist"];
	
	NSString *e_Name = [EmailText text];
	NSString *p_Name = [PassWordText text];
	NSString *professor_Name = [ProfessorText text];
	
	// initilize the Dictionary to the appropriate path. The file is AppUserData.plist
	NSDictionary *test = [[NSDictionary alloc] initWithContentsOfFile:file];
	
	// If the BOOL from the call to FieldsFilledOutCorrectly returns true, then we send the form off to be processed. 
	if ([self FieldsFilledOutCorrectly])
	{
		if ([ButtonTitle isEqualToString:@"Register"])
		{		
			NSString *StringUrl = [NSString stringWithFormat:@"http://www.cis.gvsu.edu/~prokope/index.php/rest/register/"
								   "username/%@/password/%@/professor/%@", e_Name, p_Name, professor_Name];
			
			StringUrl = [StringUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
			StringUrl = [StringUrl stringByReplacingOccurrencesOfString:@"@" withString:@"%40"];
			NSLog(@"%@", StringUrl);
			
			NSURL *url = [NSURL URLWithString:StringUrl];
			NSData *data = [NSData dataWithContentsOfURL: url];
			
			NSString *theString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
			NSLog(@"%@", theString);

			NSXMLParser *parse = [[NSXMLParser alloc] initWithData:data];
			[parse setDelegate:self];
			[parse parse];
			[parse release];
			
			NSString *theUser = [test objectForKey:@"E-mail"];
			
			// we know the registration was sucessful because of the response from the server. 
			if (RegistrationResult == 1)
			{
				if (![e_Name isEqualToString:theUser])
				{	
					NSString *message = [NSString stringWithFormat:@"%@ is not the default, would you like it to be ?", e_Name];
					
					UIAlertView *alertDialog;
					alertDialog = [[UIAlertView alloc]initWithTitle:@"Remember Me" message:message delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
					alertDialog.tag = 1;
					[alertDialog show];
					[alertDialog release];
				}
				self.controller.TheUserName = [EmailText text];
				NSLog(@"%@", [EmailText text]);
				self.controller.ThePassWord = [PassWordText text];
				self.controller.Professor = [ProfessorText text];
				self.controller.logedin = TRUE;
			}
			else
			{
				self.controller.logedin = FALSE;
			}
		}
		// We know we are doing an update call here.
		else if([ButtonTitle isEqualToString:@"Update"])
		{		
			NSString *StringUrl = [NSString stringWithFormat:@"http://www.cis.gvsu.edu/~prokope/index.php/rest/update/"
								   "oldusername/%@/newusername/%@/oldpassword/%@/newpassword/%@/professor/%@", self.controller.TheUserName, e_Name, self.controller.ThePassWord, p_Name, professor_Name];
			
			StringUrl = [StringUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
			StringUrl = [StringUrl stringByReplacingOccurrencesOfString:@"@" withString:@"%40"];		
			NSLog(@"%@", StringUrl);
			
			NSURL *url = [NSURL URLWithString:StringUrl];
			NSData *data = [NSData dataWithContentsOfURL: url];
			
			NSString *theString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
			NSLog(@"%@", theString);
			
			NSXMLParser *parse = [[NSXMLParser alloc] initWithData:data];
			[parse setDelegate:self];
			[parse parse];
			[parse release];
			
			NSString *theUser = [test objectForKey:@"E-mail"];
			NSString *thePass = [test objectForKey:@"Password"];
			NSString *theProf = [test objectForKey:@"Professor"];
			
			// we know there was a sucessful update if the RegistrationResult variable is equal to 1.
			if (RegistrationResult == 1)
			{
				// if the p-list file is the same as the the textviews then we do not need to update the p-list.
				if (!([theUser isEqualToString:e_Name] && [thePass isEqualToString:p_Name] &&
						[theProf isEqualToString:professor_Name]))
				{
					[self SaveContentsToFile];
					
					UIAlertView *alertDialog;
					alertDialog = [[UIAlertView alloc]initWithTitle:@"Profile Updated" message:@"Your update has been saved." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
					[alertDialog show];
					[alertDialog release];
				}
				self.controller.TheUserName = [EmailText text];
				NSLog(@"%@", [EmailText text]);
				self.controller.ThePassWord = [PassWordText text];
				self.controller.Professor = [ProfessorText text];
				self.controller.logedin = TRUE;
			}
		}
	}
}

-(BOOL)FieldsFilledOutCorrectly
{
	BOOL correct = TRUE;
	
	NSString *e_Name = [EmailText text];
	NSString *p_Name = [PassWordText text];
	NSString *confirm = [PassWordConfirmText text];
	NSString *professor_Name = [ProfessorText text];
	
	NSError *anError = NULL;
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[a-zA-Z0-9._%+-]+@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,6}$" options:0 error:&anError];
	
	NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:e_Name options:0 range:NSMakeRange(0, [e_Name length])];
	
	if (NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0)))
	{
		[EmailLabel setText:[NSString stringWithFormat:@"Please Provide a valid email."]];
		EmailLabel.textColor = [UIColor redColor];
		correct = FALSE;
	}
	else
	{
		[EmailLabel setText:@""];
	}
	
	if ([p_Name isEqualToString:@""])
	{
		[PassWordStatus setText:@"You have not entered a password."];
		PassWordStatus.textColor = [UIColor redColor];
		correct = FALSE;
	}
	else if(![p_Name isEqualToString:confirm])
	{
		[PassWordStatus setText:@"Your passwords are not the same"];
		PassWordStatus.textColor = [UIColor redColor];
		correct = FALSE;
	}
	else
	{
		[PassWordStatus setText:@""];
	}

	if ([professor_Name isEqualToString:@""])
	{
		[ProfessorLabel setText:@"Please Select a professor"];
		ProfessorLabel.textColor = [UIColor redColor];
		correct = FALSE;
	}
	else
	{
		[ProfessorLabel setText:@"Select a professor from the list"];
		ProfessorLabel.textColor = [UIColor blackColor];
	}

	return correct;
}

/******************************************************************************
 * This method gets called when the parser found characters in an XML document. 
 */
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if ([CurrentTag isEqualToString:@"result"])
	{
		// they are logged in so it is an update. 
		if ([[RegisterButton currentTitle] isEqualToString:@"Update"])
		{
			NSString *StatusString = @"Nothing to report";
			UIColor *StatusColor = [UIColor whiteColor];
			
			// a -1 login means the user is not found.
			if ([string isEqualToString:@"-1"])
			{
				RegistrationResult = -1;
				StatusString = @"This profile was not found.";
				StatusColor = [UIColor redColor];	
			}
			// a -2 means an error in the URI string
			else if([string isEqualToString:@"-2"])
			{
				RegistrationResult = -2;
				StatusString = @"Error in the URL string.";
				StatusColor = [UIColor redColor];				
			}
			// a -3 means permission is denied. The new user name already exists, and their authentication failed (wrong password).
			else if([string isEqualToString:@"-3"])
			{
				RegistrationResult = -3;
				StatusString = @"Permission is denied.";
				StatusColor = [UIColor redColor];				
			}
			// a -4 means the new user name already exists, and their authentication was correct.
			else if([string isEqualToString:@"-4"])
			{
				RegistrationResult = -4;
				StatusString = @"New User Name already exists.";
				StatusColor = [UIColor redColor];				
			}
			// a 1 means the update was a success.
			else if ([string isEqualToString:@"1"])
			{
				RegistrationResult = 1;
				StatusString = @"Your profile was updated";
				StatusColor = [UIColor greenColor];
			}
			else
			{
				RegistrationResult = 0;
				StatusString = @"An error occured in the update";
				StatusColor = [UIColor darkGrayColor];
			}
			[StatusLabel setText:StatusString];
			[StatusLabel setBackgroundColor:StatusColor];
		}
		// The registration button title is equal to registration. So we know it is a registration.
		else
		{
			NSString *StatusString = @"Nothing to report";
			UIColor *StatusColor = [UIColor whiteColor];
		
			// a -1 means the profile is already in use.
			if ([string isEqualToString:@"-1"])
			{
				RegistrationResult = -1;
				StatusString = @"This profile is in use";
				StatusColor = [UIColor redColor];
			}
			// a -2 means the registration had a URI error.
			else if([string isEqualToString:@"-2"])
			{
				RegistrationResult = -2;
				StatusString = @"You did not enter in the information correctly";
				StatusColor = [UIColor redColor];
			}
			// a -1 means the registration was sucessful.
			else if([string isEqualToString:@"1"])
			{
				RegistrationResult = 1;
				StatusString = @"Your profile was created";
				StatusColor = [UIColor greenColor];
			}
			else 
			{
				RegistrationResult = 0;
				StatusString = @"An error occured in the registration";
				StatusColor = [UIColor darkGrayColor];
			}
			[StatusLabel setText:StatusString];
			[StatusLabel setBackgroundColor:StatusColor];
		}
	}
}

/******************************************************************************
 * This method gets called when the parser starts parsing an XML element.  
 */
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict
{	
	if([elementName isEqualToString:@"result"])
		CurrentTag = @"result";
	else if([elementName isEqualToString:@"professors"])
		CurrentTag = @"professors";
	// each professor element contains a username, a fullname, and an id.
	else if([elementName isEqualToString:@"professor"])
	{
		CurrentTag = @"professor";
		NSString *username = [attributeDict objectForKey:@"username"];
		[ProfessorsArray addObject:username];
	}
}

/******************************************************************************
 * This method responds to clicks when an alertview is clicked.
 */
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
	if ([buttonTitle isEqualToString:@"YES"])
		[self SaveContentsToFile];	
}

/******************************************************************************
 * A convience method to update the p-list xml file with the latest user data.
 */
-(void)SaveContentsToFile
{
	NSString *e_Name = [EmailText text];
	NSString *p_Name = [PassWordText text];
	NSString *professor_Name = [ProfessorText text];
	
	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *file = [docDir stringByAppendingPathComponent:@"AppUserData.plist"];
	
	// initilize the Dictionary to the appropriate path and write to the file. The file is AppUserData.plist
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  e_Name, @"E-mail", 
						  p_Name, @"Password",
						  professor_Name, @"Professor",
						  nil];
	
	[dict writeToFile:file atomically: TRUE];	
}

/******************************************************************************
 * Deallocation our memory. 
 */
- (void)dealloc {
    [super dealloc];
}

@end
