    //
//  RegistrationController.m
//  Prokope
//
//  Created by Justin Antranikian on 6/23/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import "RegistrationController.h"


@implementation RegistrationController

@synthesize EmailText, PassWordText, ProfessorText, ProfessorTable, StatusLabel;

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[EmailText setText:mail];
	[PassWordText setText:pass];
	[ProfessorText setText:prof];
	
	if (logedin)
	{
		[RegisterButton setTitle:@"Update" forState:UIControlStateNormal];
	}
	else
	{
		//<#statements#>
	}
	
	//ProfessorsArray = [[NSMutableArray alloc] initWithObjects:@"Adams", @"Anderson", @"Smith", nil];
	ProfessorsArray = [[NSMutableArray alloc] initWithCapacity:100];
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.cis.gvsu.edu/~prokope/index.php/rest/professor"]];
	
	//NSURL *url = [NSURL URLWithString:@"http://www.cis.gvsu.edu/~prokope/index.php/rest/register/username/true/password/1234/professor/adams"];
	NSData *data = [NSData dataWithContentsOfURL: url];
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
	[parser setDelegate:self];
	[parser parse];
	[parser release];
	
	ProfessorTable.delegate = self;
	ProfessorTable.dataSource = self;
	
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [ProfessorsArray count];
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
	
    NSString *a = [ProfessorsArray objectAtIndex:indexPath.row];
	
    cell.textLabel.text = a;
	
    return cell;
}

// This method repsonds to the touch on an item in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[ProfessorTable deselectRowAtIndexPath:indexPath animated:YES];
	
	NSString *a = [ProfessorsArray objectAtIndex:indexPath.row];
	[ProfessorText setText:a];
}

-(void)UserLogedIn:(BOOL)u_logged
{
	logedin = u_logged;
}

-(void)SetInitialData:(NSString *)e_mail Password:(NSString *)p_word Professor:(NSString *)professor_word
{
	mail = e_mail;
	pass = p_word;
	prof = professor_word;
}

-(IBAction)RegisterButtonClicked:(id)sender
{	
	UIButton *resultButton = (UIButton *)sender;
	NSString *ButtonTitle = [resultButton currentTitle];
	if ([ButtonTitle isEqualToString:@"Register"])
	{

		NSString *e_Name = [EmailText text];
		NSString *p_Name = [PassWordText text];
		NSString *professor_Name = [ProfessorText text];
		
		NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *file = [docDir stringByAppendingPathComponent:@"AppUserData.plist"];
		
		// initilize the Dictionary to the appropriate path. The file is AppUserData.plist
		NSDictionary *test = [[NSDictionary alloc] initWithContentsOfFile:file];
		
		
		NSString *StringUrl = [NSString stringWithFormat:@"http://www.cis.gvsu.edu/~prokope/index.php/rest/register/"
							   "username/%@/password/%@/professor/%@", e_Name, p_Name, professor_Name];
		
	//	NSString *StringUrl = @"http://www.cis.gvsu.edu/~prokope/index.php/rest/register/username/tom/password/1234/professor/adams%40cis.gvsu.edu";
		
	//	NSString* escapedUrlString = [@"hee there" stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
		StringUrl = [StringUrl stringByReplacingOccurrencesOfString:@"@" withString:@"%40"];
		
		NSLog(StringUrl);
		
		NSURL *url = [NSURL URLWithString:StringUrl];
		
		NSData *data = [NSData dataWithContentsOfURL: url];
		
		NSString *theString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
		NSLog(theString);
		
		NSXMLParser *parse = [[NSXMLParser alloc] initWithData:data];
		[parse setDelegate:self];
		[parse parse];
		[parse release];
		
		NSString *theUser = [test objectForKey:@"E-mail"];
		NSString *thePass = [test objectForKey:@"Password"];
		
		if (RegistrationResult == 1)
		{
			if ([e_Name isEqualToString:theUser])
			{
				NSLog(@"Match");
			}
			else
			{	
				NSString *message = [NSString stringWithFormat:@"%@ is not the default, would you like it to be ?", e_Name];
				
				UIAlertView *alertDialog;
				alertDialog = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
				alertDialog.tag = 1;
				[alertDialog show];
				[alertDialog release];
			}
		}
		
    }
	else if([ButtonTitle isEqualToString:@"Update"])
	{
	    NSLog(@"Update");	
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if ([CurrentTag isEqualToString:@"result"])
	{
		NSString *StatusString = @"Nothing to report";
		UIColor *StatusColor = [UIColor whiteColor];
		NSLog(@"Result from rest server is : %@", string);
	
		if ([string isEqualToString:@"-1"])
		{
			StatusString = @"This profile is in use";
			StatusColor = [UIColor redColor];
			RegistrationResult = -1;
		}
		else if([string isEqualToString:@"1"])
		{
			StatusColor = [UIColor greenColor];
			StatusString = @"Your profile was created";
			RegistrationResult = 1;
		}
		else if([string isEqualToString:@"-2"])
		{
			StatusString = @"You did not enter in the information correctly";
			StatusColor = [UIColor redColor];
			RegistrationResult = -2;
		}
		[StatusLabel setText:StatusString];
		[StatusLabel setBackgroundColor:StatusColor];
	}
	else if([CurrentTag isEqualToString:@"professors"])
	{
	 //   NSLog(@"Starting to parse the professors section");	
	}
	else if([CurrentTag isEqualToString:@"professor"])
	{
	//	NSLog(string);
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
	else if([elementName isEqualToString:@"professors"])
	{
		CurrentTag = @"professors";
	}
	else if([elementName isEqualToString:@"professor"])
	{
		CurrentTag = @"professor";
		NSString *username = [attributeDict objectForKey:@"username"];
		NSString *fullname = [attributeDict objectForKey:@"fullname"];
		NSString *id = [attributeDict objectForKey:@"id"];
		
		[ProfessorsArray addObject:username];
	}
}

-(NSString *) urlencode: (NSString *) url
{
    NSArray *escapeChars = [NSArray arrayWithObjects:@";" , @"/" , @"?" , @":" ,
							@"@" , @"&" , @"=" , @"+" ,
							@"$" , @"," , @"[" , @"]",
							@"#", @"!", @"'", @"(", 
							@")", @"*", nil];
	
    NSArray *replaceChars = [NSArray arrayWithObjects:@"%3B" , @"%2F" , @"%3F" ,
							 @"%3A" , @"%40" , @"%26" ,
							 @"%3D" , @"%2B" , @"%24" ,
							 @"%2C" , @"%5B" , @"%5D", 
							 @"%23", @"%21", @"%27",
							 @"%28", @"%29", @"%2A", nil];
	
    int len = [escapeChars count];
	
    NSMutableString *temp = [url mutableCopy];
	
    int i;
    for(i = 0; i < len; i++)
    {
		
        [temp replaceOccurrencesOfString: [escapeChars objectAtIndex:i]
							  withString:[replaceChars objectAtIndex:i]
								 options:NSLiteralSearch
								   range:NSMakeRange(0, [temp length])];
    }
	
    NSString *out = [NSString stringWithString: temp];
	
    return out;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

	NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
	
	if ([buttonTitle isEqualToString:@"YES"])
	{
	
		NSString *e_Name = [EmailText text];
		NSString *p_Name = [PassWordText text];
		NSString *professor_Name = [ProfessorText text];
		
		NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *file = [docDir stringByAppendingPathComponent:@"AppUserData.plist"];
		
		// initilize the Dictionary to the appropriate path. The file is AppUserData.plist
		NSDictionary *test = [[NSDictionary alloc] initWithContentsOfFile:file];
		
		NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
							  e_Name, @"E-mail", 
							  p_Name, @"Password",
							  professor_Name, @"Professor",
							  nil];
		
		[dict writeToFile:file atomically: TRUE];
	}
	else if ([buttonTitle isEqualToString:@"NO"])
	{
	  // for now we simply dismiss this, but we might want to add something later. 
	  //  NSLog(@"Dismiss");	
	}
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
