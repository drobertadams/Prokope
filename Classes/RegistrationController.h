//
//  RegistrationController.h
//  Prokope
//
//  Created by Justin Antranikian on 6/23/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProkopeViewController.h"
#import "Reachability.h"

@interface RegistrationController : UIViewController <UIAlertViewDelegate, NSXMLParserDelegate, UITableViewDelegate, UITableViewDataSource> {

	IBOutlet UITextField *EmailText;
	IBOutlet UITextField *PassWordText;
	IBOutlet UITextField *PassWordConfirmText;
	IBOutlet UITextField *ProfessorText;
	
	IBOutlet UITableView *ProfessorTable;
	IBOutlet UIButton *RegisterButton;
	
	IBOutlet UILabel *TitleLabel;
	IBOutlet UILabel *EmailLabel;
	IBOutlet UILabel *PassWordLabel;
	IBOutlet UILabel *ProfessorLabel;
	IBOutlet UILabel *PassWordStatus;
	IBOutlet UILabel *StatusLabel;
	
	NSString *name;
	NSString *pass;
	NSString *mail;
	NSString *prof;
	
	NSString *CurrentTag;
	
	NSMutableArray *ProfessorsArray;
	
	int RegistrationResult;
	
	ProkopeViewController *controller;
	
	Reachability *internetReach;
  
    BOOL ProfessorsDataPopulated;
	
	BOOL InternetConnection;
}

@property (nonatomic, retain) IBOutlet UITextField *PassWordText;
@property (nonatomic, retain) IBOutlet UITextField *EmailText;
@property (nonatomic, retain) IBOutlet UITextField *ProfessorText;
@property (nonatomic, retain) IBOutlet UITextField *PassWordConfirmText;

@property (nonatomic, retain) IBOutlet UIButton *RegisterButton;
@property (nonatomic, retain) IBOutlet UITableView *ProfessorTable;

@property (nonatomic, retain) IBOutlet UILabel *StatusLabel;
@property (nonatomic, retain) IBOutlet UILabel *PassWordStatus;
@property (nonatomic, retain) IBOutlet UILabel *EmailLabel;
@property (nonatomic, retain) IBOutlet UILabel *ProfessorLabel;
@property (nonatomic, retain) IBOutlet UILabel *PassWordLabel;

@property (nonatomic, retain) ProkopeViewController *controller;

-(void)PopulateProfessorsTable;
-(IBAction)RegisterButtonClicked:(id)sender;
-(BOOL)FieldsFilledOutCorrectly;
-(void)SaveContentsToFile;
-(void)UpdateInternetConnectionStatus;

@end
