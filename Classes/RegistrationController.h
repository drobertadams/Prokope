//
//  RegistrationController.h
//  Prokope
//
//  Created by Justin Antranikian on 6/23/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RegistrationController : UIViewController {

	IBOutlet UITextField *UserNameText;
	IBOutlet UITextField *PassWordText;
	IBOutlet UITextField *EmailText;
	IBOutlet UITextField *ProfessorText;
}

@property (nonatomic, retain) IBOutlet UITextField *UserNameText;
@property (nonatomic, retain) IBOutlet UITextField *PassWordText;
@property (nonatomic, retain) IBOutlet UITextField *EmailText;
@property (nonatomic, retain) IBOutlet UITextField *ProfessorText;

-(IBAction)RegisterButtonClicked:(id)sender;

@end
