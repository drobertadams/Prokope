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
@interface ProkopeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {

	IBOutlet UITableView *ProkopeTableView;
	NSMutableArray *AuthorsArray;
	NSMutableArray *MyURLData;
	
}

@property (nonatomic, retain) IBOutlet UITableView *ProkopeTableView;
@property (nonatomic, retain) NSMutableArray *AuthorsArray;

- (IBAction) showDocument; // action to display a document
-(void)SetDataArray:(NSMutableArray *)dataArray;

@end

