//
//  SecondNavigation.h
//  Prokope
//
//  Created by Justin Antranikian on 5/20/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SecondNavigation : UIViewController <UITableViewDelegate, UITableViewDataSource> {

	NSMutableArray *myArrayData;
	IBOutlet UITableView *SecondNavigationTableView;
}

@property (nonatomic, retain) IBOutlet UITableView *SecondNavigationTableView;

@end
