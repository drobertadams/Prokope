//
//  LoginAlertViewDelegate.m
//  Prokope
//
//  Created by Justin Antranikian on 6/13/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import "LoginAlertViewDelegate.h"
#import "ProkopeViewController.h"
#import "DocumentController.h"

@implementation LoginAlertViewDelegate

@synthesize userNameLabel;

-(LoginAlertViewDelegate*) initWithController: (UIViewController *) c {
    self = [super init];
	
    if ( self )
	{
        if ([c isKindOfClass:[ProkopeViewController class]])
		{
			controller = (ProkopeViewController *) c;
		}
		else
		{
			NSLog(@"!!!!! PROKOPE VIEW CONTROLLER");
		}
		label2 = [controller getLabel2];
    }
	
    return self;
}

-(void)SwitchControllers: (UIViewController *) newController
{
	if([controller isKindOfClass: [ProkopeViewController class]])
	{
		controller = (ProkopeViewController *) newController;
		NSLog(@"A Prokope Controller");
	}
	else if([controller isKindOfClass: [DocumentController class]])
	{
		controller = (DocumentController *) newController;
		NSLog(@"A document controller");
	}
	
	label2 = [controller getLabel2];
	
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

/*-(void)GetLatestLoginData
{
	label2 = [controller getLabel2];
	
	if (userNameLabel == nil) {
		[controller SetUpLoginButton];
		NSLog(@"USER NAME is null");
	}
	else {
		
		NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *file = [docDir stringByAppendingPathComponent:@"AppUserData.plist"];
		
		// initilize the Dictionary to the appropriate path. The file is AppUserData.plist
		NSDictionary *test = [[NSDictionary alloc] initWithContentsOfFile:file];
		
		if(!test)
		{
			NSLog(@"File has not been created");
		}
		else
		{
			NSLog(@"File has been created");
			NSString *theUser = @"User Name";
			NSString *thePass = @"Pass Word";
			
			theUser = [test objectForKey:@"UserName"];
			thePass = [test objectForKey:@"Password"];
			
			label2.text = [NSString stringWithFormat:@"Welcome : %@", theUser];
			
			controller.navigationItem.rightBarButtonItem = nil;
			
			UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:controller action:@selector(LogoutButtonClicked)];          
			controller.navigationItem.rightBarButtonItem = anotherButton;
			[anotherButton release];
		}
	}
}
*/

-(void)LogoutClicked
{
	userNameLabel = nil;
	label2.text = [NSString stringWithFormat:@"Welcome : %@", userNameLabel];
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
		
	//	controller.UserNameLabel = UserName;
		
		label2.text = [NSString stringWithFormat:@"Welcome : %@", userNameLabel];
		
		NSLog(userNameLabel);
		
		NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
							  UserName,
							  @"UserName", 
							  PassWord,
							  @"Password", 
							  nil];
		
		[dict writeToFile:file atomically: TRUE];
		controller.navigationItem.rightBarButtonItem = nil;
		
		UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:controller action:@selector(LogoutButtonClicked)];          
		controller.navigationItem.rightBarButtonItem = anotherButton;
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

@end
