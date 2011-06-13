//
//  LoginAlertViewDelegate.m
//  Prokope
//
//  Created by Justin Antranikian on 6/13/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import "LoginAlertViewDelegate.h"
#import "ProkopeViewController.h"

@implementation LoginAlertViewDelegate

-(LoginAlertViewDelegate*) initWithController: (UIViewController *) c {
    self = [super init];
	
    if ( self ) {
        if ([c isKindOfClass:[ProkopeViewController class]]) {
			controller = (ProkopeViewController *) c;
			NSLog(@"PROKOPE VIEW CONTROLLER");
		}
		else {
			NSLog(@"!!!!! PROKOPE VIEW CONTROLLER");
		}
    }
	
    return self;
}

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
		NSLog(@"File has not been created");
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

-(void)LogoutClicked
{
	label2 = [controller getLabel2];
	userNameLabel = [controller geUserNameLabel];

	userNameLabel = nil;
	label2.text = [NSString stringWithFormat:@"Welcome : %@", userNameLabel];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	label2 = [controller getLabel2];
	userNameLabel = [controller geUserNameLabel];
	
	NSLog(@"Hello");
	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *file = [docDir stringByAppendingPathComponent:@"AppUserData.plist"];
	
	// initilize the Dictionary to the appropriate path. The file is AppUserData.plist
	NSDictionary *test = [[NSDictionary alloc] initWithContentsOfFile:file];
	
	NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
	if ([buttonTitle isEqualToString:@"ok"])
	{
		NSString *UserName = userInput.text;
		NSString *PassWord = passInput.text;
		
		userNameLabel = UserName;
		
		label2.text = [NSString stringWithFormat:@"Welcome : %@", userNameLabel];
		
		NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
							  UserName,
							  @"UserName", 
							  PassWord,
							  @"Password", 
							  nil];
		
		[dict writeToFile:file atomically: TRUE];
		NSLog(@"File saved");
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
			NSLog(@"The file has been cleared.");
		}
		else 
		{
			NSLog(@"File was never created");
		}
	}
}

@end
