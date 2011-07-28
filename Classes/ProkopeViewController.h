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
		<UITextFieldDelegate, UIAlertViewDelegate, UIScrollViewDelegate, UIActionSheetDelegate, NSXMLParserDelegate> {

	NSMutableArray *AuthorsArray;
			
	IBOutlet UIImageView *BookShelfImage;
	
	// Three IBOutlet UIScrollView's that hold the three layers of the bookshelf.
	IBOutlet UIScrollView *FirstShelf;
	IBOutlet UIScrollView *SecondShelf;
	IBOutlet UIScrollView *ThirdShelf;
	
	// This WebView holds the commentary of the bio.
	IBOutlet UIWebView *CommentaryView;
			
	UIActionSheet *popupQuery;		
			
	// userInput is the UITextField added to the AlertView to capture the user's name.
	UITextField *userInput;
			
	// passInput is the UITextField added to the AlertView to capture the user's password.
	UITextField *passInput;		
			
	UIImage *BookSpine;

	NSString *CurrentAuthor;
	NSString *CurrentWork;

	UILabel *label2;
			
	int first_shelf_x_cord;
	int second_shelf_x_cord;
	int third_shelf_x_cord;
			
	UIFont *ClickedFont;
	UIFont *ControlFont;
			
	UIButton *FirstRightButton;
	UIButton *FirstLeftButton;
			
	UIButton *SecondLeftButton;
	UIButton *SecondRightButton;
	
	UIButton *ThirdLeftButton;
	UIButton *ThirdRightButton;
			
	BOOL logedin;
			
	NSString *CurrentTag;
			
	int LoginResult;
			
	NSString *TheUserName;
	NSString *ThePassWord;
	NSString *Professor;
			
	UIImage *image_left;
	UIImage *image_right;
}

@property (nonatomic, retain) IBOutlet UIImageView *BookShelfImage;

@property (nonatomic, retain) IBOutlet UIScrollView *FirstShelf;
@property (nonatomic, retain) IBOutlet UIScrollView *SecondShelf;
@property (nonatomic, retain) IBOutlet UIScrollView *ThirdShelf;

@property (nonatomic, retain) IBOutlet UIWebView *CommentaryView;
@property (nonatomic, retain) NSString *TheUserName;
@property (nonatomic, retain) NSString *ThePassWord;
@property (nonatomic, retain) NSString *Professor;
@property (nonatomic, getter=isWorking, setter=isWorking) BOOL logedin;

-(void)SetDataArray:(NSMutableArray *)dataArray;
-(void)InitalizeButton:(UIButton *)Button Tag:(int)tag Shelf:(UIScrollView *)Shelf Side:(NSString *)Side;

-(void)accelorateRight:(id)sender;
-(void)accelorateLeft:(id)sender;

-(void)setUpNavBar;
-(void)ForceScroll:(UIScrollView *)scroll;

-(void)FirstShelfButtonClicked:(id)sender;
-(void)SecondShelfButtonClicked:(id)sender;
-(void)ThirdShelfButtonClicked:(id)sender;

-(void)ClearShelfFonts:(UIScrollView *)BookShelfScrollView;
-(void)ClearShelf:(UIScrollView *)BookShelfScrollView;

-(void)showActionSheet;

-(void)SetUpLoginButton;

-(void)DisplayHelperImage:(int)offset scrollView:(UIScrollView *)scroll 
	LeftImage:(UIButton *)LeftImage RightImage:(UIButton *)RightImage ShelfCord:(int)ShelfCord;

@end

