//
//  ProkopeViewController.h
//  Prokope
//
//	This is the "main screen" for the application.
//
//  Created by D. Robert Adams on 5/9/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import <UIKit/UIKit.h>

/* Implementing the UITableViewDelegate and the UITableViewDataSource protocols allows this class
to implement the necessary methods for a table view to respond to actions and load data into the
table. 
 */
@interface ProkopeViewController : UIViewController 
		<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate> {

	IBOutlet UITableView *ProkopeTableView;
	IBOutlet UILabel *NameLabel;
	NSMutableArray *AuthorsArray;
	
	// userInput is the UITextField added to the AlertView to capture the user's name.
	UITextField *userInput;
	
	// passInput is the UITextField added to the AlertView to capture the user's password.
	UITextField *passInput;

}

@property (nonatomic, retain) IBOutlet UITableView *ProkopeTableView;
@property (nonatomic, retain) NSMutableArray *AuthorsArray;
@property (nonatomic, retain) IBOutlet UILabel *NameLabel;

-(void)SetDataArray:(NSMutableArray *)dataArray;
-(void)ShowAlert;

@end

