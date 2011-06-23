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
		<UITextFieldDelegate, UIAlertViewDelegate, UIScrollViewDelegate> {

	NSMutableArray *AuthorsArray;
			
	IBOutlet UIImageView *BookShelfImage;
	
	// Three IBOutlet UIScrollView's that hold the three layers of the bookshelf.
	IBOutlet UIScrollView *FirstShelf;
	IBOutlet UIScrollView *SecondShelf;
	IBOutlet UIScrollView *ThirdShelf;
	
	// This WebView holds the commentary of the bio.
	IBOutlet UIWebView *CommentaryView;
			
	// userInput is the UITextField added to the AlertView to capture the user's name.
	UITextField *userInput;
			
	// passInput is the UITextField added to the AlertView to capture the user's password.
	UITextField *passInput;		
			
	UIImage *BookSpine;

	NSString *CurrentAuthor;
	NSString *CurrentWork;

	UILabel *label2;
			
	UIImageView *FirstShelfLeftImage;
	UIImageView *FirstShelfRightImage;		
			
	UIImageView *SecondShelfLeftImage;
	UIImageView *SecondShelfRightImage;
	
	UIImageView *ThirdShelfLeftImage;
	UIImageView *ThirdShelfRightImage;		
			
	int first_shelf_x_cord;
	int second_shelf_x_cord;
	int third_shelf_x_cord;
			
	UIFont *ClickedFont;
	UIFont *ControlFont;
}

@property (nonatomic, retain) IBOutlet UIImageView *BookShelfImage;

@property (nonatomic, retain) IBOutlet UIScrollView *FirstShelf;
@property (nonatomic, retain) IBOutlet UIScrollView *SecondShelf;
@property (nonatomic, retain) IBOutlet UIScrollView *ThirdShelf;

@property (nonatomic, retain) IBOutlet UIWebView *CommentaryView;
@property (nonatomic, retain) UILabel *label2;

-(void)SetDataArray:(NSMutableArray *)dataArray;

-(void)FirstShelfButtonClicked:(id)sender;
-(void)SecondShelfButtonClicked:(id)sender;
-(void)ThirdShelfButtonClicked:(id)sender;

-(void)ForceScroll:(UIScrollView *)scroll;
-(void)setUpNavBar;

-(void)ClearShelfFonts:(UIScrollView *)BookShelfScrollView;
-(void)ClearShelf:(UIScrollView *)BookShelfScrollView;

-(void)ShowAlert;
-(void)SetUpLoginButton;
-(void)LogoutButtonClicked;
-(void)ClearUserSettings;

-(void)DisplayHelperImage:(int)offset scrollView:(UIScrollView *)scroll 
	LeftImage:(UIImageView *)LeftImage RightImage:(UIImageView *)RightImage ShelfCord:(int)ShelfCord;

@end

