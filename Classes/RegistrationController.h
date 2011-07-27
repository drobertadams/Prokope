//
//  RegistrationController.h
//  Prokope
//
//  Created by Justin Antranikian on 6/23/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProkopeViewController.h"

@interface RegistrationController : UIViewController <UIAlertViewDelegate, NSXMLParserDelegate, UITableViewDelegate, UITableViewDataSource> {

	IBOutlet UITextField *EmailText;
	IBOutlet UITextField *PassWordText;
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
	
	int RegistrationResult;
	
	ProkopeViewController *controller;
}

@property (nonatomic, retain) IBOutlet UITextField *PassWordText;
@property (nonatomic, retain) IBOutlet UITextField *EmailText;
@property (nonatomic, retain) IBOutlet UITextField *ProfessorText;
@property (nonatomic, retain) IBOutlet UIButton *RegisterButton;
@property (nonatomic, retain) IBOutlet UITableView *ProfessorTable;
@property (nonatomic, retain) IBOutlet UILabel *StatusLabel;
@property (nonatomic, retain) ProkopeViewController *controller;

-(IBAction)RegisterButtonClicked:(id)sender;
-(void)SaveContentsToFile;

-(NSString *) urlencode: (NSString *) url;

@end
