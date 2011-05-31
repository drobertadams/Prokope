//
//  ProkopeAppDelegate.m
//  Prokope
//
//  Created by D. Robert Adams on 5/9/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import "ProkopeAppDelegate.h"
#import "ProkopeViewController.h"
#import "Author.h"
#import "Work.h"

@implementation ProkopeAppDelegate

@synthesize window;
@synthesize viewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch.
	
	AuthorsArray = [[NSMutableArray alloc] initWithCapacity:100];
	
	AuthorCount = -1;							
	WorkCount = 0;
	
	NSString* path = [[NSBundle mainBundle] pathForResource: @"Authors" ofType: @"xml"];
	NSData* data = [NSData dataWithContentsOfFile: path];
	NSXMLParser* parser = [[NSXMLParser alloc] initWithData: data];
	
	[parser setDelegate:self];
	[parser parse];
	[parser release];
	
	// This line initialized the navigation controller. 
	ProkopeNavigationController = [[UINavigationController alloc] init];
	
	[window addSubview:ProkopeNavigationController.view];
	
	viewController = [[ProkopeViewController alloc] initWithNibName:@"ProkopeViewController" bundle:nil];
	[viewController SetDataArray:AuthorsArray];
	
	[ProkopeNavigationController pushViewController:viewController animated:NO];
	[viewController release];
	
	// Set the view controller as the window's root view controller and display.
    //self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

	return YES;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict {
	
	
	if([elementName isEqualToString:@"Author"])
	{		
		AuthorCount++;
		WorkCount = -1;
		
		Author *newAuthor = [[Author alloc] init];
		NSString *thename = [attributeDict objectForKey:@"name"];
		NSString *icon = [attributeDict objectForKey:@"icon"];
		
		newAuthor.name = thename;
		newAuthor.iconURL = icon;
		
		[AuthorsArray addObject:newAuthor];
		
	}
	else if ([elementName isEqualToString:@"Work"])
	{	
		WorkCount ++;
		NSString *url = [attributeDict objectForKey:@"url"];
		NSString *name = [attributeDict objectForKey:@"name"]; 
		
		Work *w = [[Work alloc] init];
		w.name = name;
		w.iconURL = url;
		
		Author *a = [AuthorsArray objectAtIndex:AuthorCount];
		[a.WorksArray addObject:w];
	}
	else if ([elementName isEqualToString:@"Chapter"])
	{	
		NSString *name = [attributeDict objectForKey:@"name"];
		NSString *url = [attributeDict objectForKey:@"url"]; 
		
		Author *a = [AuthorsArray objectAtIndex:AuthorCount];
		Work *w = [a.WorksArray objectAtIndex:WorkCount];
		
		Work *newOne = [[Work alloc] init];
		newOne.name = name;
		newOne.iconURL = url;
		
		[w.ChaptersArray addObject:newOne];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if([elementName isEqualToString:@"Prokope"])
	{
		NSLog(@"Done Parsing Prokope");
	}
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
