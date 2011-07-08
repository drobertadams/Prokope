//
//  RegistrationController.h
//  Prokope
//
//  Created by Justin Antranikian on 6/23/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RegistrationController : UIViewController <UIAlertViewDelegate> {

	IBOutlet UITextField *UserNameText;
	IBOutlet UITextField *PassWordText;
	IBOutlet UITextField *EmailText;
	IBOutlet UITextField *ProfessorText;
	IBOutlet UIButton *RegisterButton;
	
	NSString *name;
	NSString *pass;
	NSString *mail;
	NSString *prof;
	
	BOOL logedin;
}

@property (nonatomic, retain) IBOutlet UITextField *UserNameText;
@property (nonatomic, retain) IBOutlet UITextField *PassWordText;
@property (nonatomic, retain) IBOutlet UITextField *EmailText;
@property (nonatomic, retain) IBOutlet UITextField *ProfessorText;
@property (nonatomic, retain) IBOutlet UIButton *RegisterButton;

-(IBAction)RegisterButtonClicked:(id)sender;
-(void)DisplayHelperImage:(NSString *)u_name Password:(NSString *)p_word
		Email:(NSString *)e_mail Professor:(NSString *)professor_word;

-(void)UserLogedIn:(BOOL)u_logged;

@end
