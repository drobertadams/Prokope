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

@interface ProkopeViewController : UIViewController {

	IBOutlet UIButton *NavigationButton;

}

- (IBAction) showDocument; // action to display a document
- (IBAction) NavigationButtonClicked:(id)sender;

@end

