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
	IBOutlet UILabel *NameLabel;
	IBOutlet UIImageView *BookShelfImage;
	IBOutlet UIScrollView *FirstShelf;
	IBOutlet UIScrollView *SecondShelf;
			
	UIImage *BookSpine;
	
	// userInput is the UITextField added to the AlertView to capture the user's name.
	UITextField *userInput;
	
	// passInput is the UITextField added to the AlertView to capture the user's password.
	UITextField *passInput;

	NSString *CurrentAuthor;
			
	IBOutlet UIScrollView *ThirdShelfScroll;
}

@property (nonatomic, retain) IBOutlet UITableView *ProkopeTableView;
@property (nonatomic, retain) IBOutlet UILabel *NameLabel;
@property (nonatomic, retain) IBOutlet UIImageView *BookShelfImage;
@property (nonatomic, retain) IBOutlet UIScrollView *SecondShelf;
@property (nonatomic, retain) NSString *CurrentAuthor;
@property (nonatomic, retain) IBOutlet UIScrollView *ThirdShelfScroll;
@property (nonatomic, retain) IBOutlet UIScrollView *FirstShelf;

-(void)SetDataArray:(NSMutableArray *)dataArray;
-(void)ShowAlert;
-(void)AuthorButtonClicked:(id)sender;
-(void)ClearSecondShelf;
-(void)WorkButtonClicked:(id)sender;
-(void)PopulateScroll;

@end

