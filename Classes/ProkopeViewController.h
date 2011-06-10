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

	NSMutableArray *AuthorsArray;
			
	IBOutlet UITableView *ProkopeTableView;
	IBOutlet UIImageView *BookShelfImage;
	
	// Three IBOutlet UIScrollView's that hold the three layers of the bookshelf.
	IBOutlet UIScrollView *FirstShelf;
	IBOutlet UIScrollView *SecondShelf;
	IBOutlet UIScrollView *ThirdShelfScroll;
			
	UIImage *BookSpine;
	
	// userInput is the UITextField added to the AlertView to capture the user's name.
	UITextField *userInput;
	
	// passInput is the UITextField added to the AlertView to capture the user's password.
	UITextField *passInput;

	NSString *CurrentAuthor;
	NSString *CurrentWork;
			
	NSString *UserNameLabel;

	UILabel *label2;
}

@property (nonatomic, retain) IBOutlet UITableView *ProkopeTableView;
@property (nonatomic, retain) IBOutlet UIImageView *BookShelfImage;
@property (nonatomic, retain) IBOutlet UIScrollView *SecondShelf;
@property (nonatomic, retain) IBOutlet UIScrollView *ThirdShelfScroll;
@property (nonatomic, retain) IBOutlet UIScrollView *FirstShelf;

-(void)SetDataArray:(NSMutableArray *)dataArray;

-(void)FirstShelfButtonClicked:(id)sender;
-(void)SecondShelfButtonClicked:(id)sender;
-(void)ThirdShelfButtonClicked:(id)sender;

-(void)PopulateScroll;

-(void)ClearFirstShelfFonts;
-(void)ClearSecondShelf;
-(void)ClearSecondShelfFonts;
-(void)ClearThirdShelf;
-(void)ShowAlert;
-(void)SetUpLoginButton;
-(void)LogoutButtonClicked;

@end

