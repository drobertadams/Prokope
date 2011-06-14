//
//  LoginAlertViewDelegate.h
//  Prokope
//
//  Created by Justin Antranikian on 6/13/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LoginAlertViewDelegate : NSObject <UIAlertViewDelegate> {

	UIViewController *controller;
	// userInput is the UITextField added to the AlertView to capture the user's name.
	UITextField *userInput;
	
	// passInput is the UITextField added to the AlertView to capture the user's password.
	UITextField *passInput;
	
	UILabel *label2;
	
	NSString *userNameLabel;
}

@property (nonatomic, retain) NSString *userNameLabel;

-(LoginAlertViewDelegate*) initWithController: (UIViewController *) c;
-(void)ShowAlert;
-(void)LogoutClicked;
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
-(void)GetLatestLoginData;
-(void)SwitchControllers: (UIViewController *) newController;

@end
