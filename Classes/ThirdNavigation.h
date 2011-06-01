//
//  ThirdNavigation.h
//  Prokope
//
//  Created by Justin Antranikian on 5/31/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ThirdNavigation : UIViewController <UITableViewDelegate, UITableViewDataSource> {

	IBOutlet UITableView *ThirdTableView;
	NSMutableArray *MyThirdArray;
}

@property (nonatomic, retain) IBOutlet UITableView *ThirdTableView;

-(void)SetThirdDataArray:(NSMutableArray *)dataArray;

@end
