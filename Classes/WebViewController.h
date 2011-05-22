//
//  WebViewController.h
//  Prokope
//
//  A "web browser" for displaying information linked from commentary.
//
//  Created by D. Robert Adams on 5/16/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController <UIWebViewDelegate> {
	
	UIWebView *webView;
	
}

- (IBAction) Close; // close this view

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSString *url;	// URL view


@end
