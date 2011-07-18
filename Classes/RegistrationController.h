//
//  RegistrationController.h
//  Prokope
//
//  Created by Justin Antranikian on 6/23/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RegistrationController : UIViewController <UIAlertViewDelegate, NSXMLParserDelegate, UITableViewDelegate, UITableViewDataSource> {

	IBOutlet UITextField *PassWordText;
	IBOutlet UITextField *EmailText;
	IBOutlet UITextField *ProfessorText;
	IBOutlet UITableView *ProfessorTable;
	IBOutlet UIButton *RegisterButton;
	IBOutlet UILabel *StatusLabel;
	
	NSString *name;
	NSString *pass;
	NSString *mail;
	NSString *prof;
	
	BOOL logedin;
	
	NSString *CurrentTag;
	
	NSMutableArray *ProfessorsArray;
}

@property (nonatomic, retain) IBOutlet UITextField *PassWordText;
@property (nonatomic, retain) IBOutlet UITextField *EmailText;
@property (nonatomic, retain) IBOutlet UITextField *ProfessorText;
@property (nonatomic, retain) IBOutlet UIButton *RegisterButton;
@property (nonatomic, retain) IBOutlet UITableView *ProfessorTable;
@property (nonatomic, retain) IBOutlet UILabel *StatusLabel;

-(IBAction)RegisterButtonClicked:(id)sender;

-(void)DisplayHelperImage:(NSString *)u_name Password:(NSString *)p_word
		Email:(NSString *)e_mail Professor:(NSString *)professor_word;

-(void)UserLogedIn:(BOOL)u_logged;
-(NSString *) urlencode: (NSString *) url;

@end
