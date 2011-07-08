    //
//  RegistrationController.m
//  Prokope
//
//  Created by Justin Antranikian on 6/23/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import "RegistrationController.h"


@implementation RegistrationController

@synthesize UserNameText, PassWordText, EmailText, ProfessorText;

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
	[UserNameText setText:name];
	[PassWordText setText:pass];
	[EmailText setText:mail];
	[ProfessorText setText:prof];
	
	if (logedin)
	{
		[RegisterButton setTitle:@"Update" forState:UIControlStateNormal];
	}
	else
	{
		//<#statements#>
	}
}

-(void)UserLogedIn:(BOOL)u_logged
{
	logedin = u_logged;
}

-(void)DisplayHelperImage:(NSString *)u_name Password:(NSString *)p_word
		Email:(NSString *)e_mail Professor:(NSString *)professor_word
{
	name = u_name;
	pass = p_word;
	mail = e_mail;
	prof = professor_word;
}

-(IBAction)RegisterButtonClicked:(id)sender
{	
	NSString *u_Name = [UserNameText text];
	NSString *p_Name = [PassWordText text];
	NSString *e_Name = [EmailText text];
	NSString *professor_Name = [ProfessorText text];
	
	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *file = [docDir stringByAppendingPathComponent:@"AppUserData.plist"];
	
	// initilize the Dictionary to the appropriate path. The file is AppUserData.plist
	NSDictionary *test = [[NSDictionary alloc] initWithContentsOfFile:file];
	
	NSString *url = [NSString stringWithFormat:@"http:www.prokope.com/test?username=%@&password=%@&professor=&%@", u_Name, p_Name, professor_Name];
	NSLog(url);
	
	NSString *theUser = [test objectForKey:@"UserName"];
	NSString *thePass = [test objectForKey:@"Password"];
	
	if ([u_Name isEqualToString:theUser])
	{
		NSLog(@"Match");
	}
	else
	{	
		NSString *message = [NSString stringWithFormat:@"%@ is not the default, would you like it to be ?", u_Name];
		
		UIAlertView *alertDialog;
		alertDialog = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
		alertDialog.tag = 1;
		[alertDialog show];
		[alertDialog release];
	}
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
	
		NSString *u_Name = [UserNameText text];
		NSString *p_Name = [PassWordText text];
		NSString *e_Name = [EmailText text];
		NSString *professor_Name = [ProfessorText text];
		
		NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *file = [docDir stringByAppendingPathComponent:@"AppUserData.plist"];
		
		// initilize the Dictionary to the appropriate path. The file is AppUserData.plist
		NSDictionary *test = [[NSDictionary alloc] initWithContentsOfFile:file];
		
		NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
							  u_Name, @"UserName", 
							  p_Name, @"Password",
							  e_Name, @"E-mail", 
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
