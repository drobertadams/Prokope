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

@implementation ProkopeAppDelegate

@synthesize window;
@synthesize viewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	
    // Override point for customization after app launch.
	
	AuthorsArray = [[NSMutableArray alloc] initWithCapacity:100];
	
	AuthorCount = 0;							
	WorkCount = 0;
	
	NSURL *url = [NSURL URLWithString:@"http://www.cis.gvsu.edu/~prokope/index.php/rest/index"];
	NSData *data = [NSData dataWithContentsOfURL:url]; 
	NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data];
	
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
	
    [self.window makeKeyAndVisible];
	
	return YES;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict {
	
	
	if([elementName isEqualToString:@"author"])
	{	
		WorkCount = 0;
		
		Author *newAuthor = [[Author alloc] init];
		NSString *thename = [attributeDict objectForKey:@"name"];
		NSString *icon = [attributeDict objectForKey:@"icon"];
		
		newAuthor.name = thename;
		newAuthor.iconURL = icon;
		
		[AuthorsArray addObject:newAuthor];
		
	}
	else if ([elementName isEqualToString:@"work"])
	{	
		NSString *url = [attributeDict objectForKey:@"url"];
		NSString *name = [attributeDict objectForKey:@"name"]; 

	//	Work *w = [[Work alloc] init];
	//	w.name = name;
	//	w.workURL = url;
		
	//	Author *a = [AuthorsArray objectAtIndex:AuthorCount];
	//	[a.WorksArray addObject:w];
	//	[w release];
	}
	else if ([elementName isEqualToString:@"chapter"])
	{	
		NSString *name = [attributeDict objectForKey:@"name"];
		NSString *url = [attributeDict objectForKey:@"url"]; 
		
		// This is the key to setting up the array. The counts are incremented as the XML file is being parsed.
		// That serves as a place holder to know where to insert the 'Chapters'.
	//	Author *a = [AuthorsArray objectAtIndex:AuthorCount];
	//	Work *w = [a.WorksArray objectAtIndex:WorkCount];
		
	//	Work *newOne = [[Work alloc] init];
	//	newOne.name = name;
	//	newOne.workURL = url;
		
	//	[w.ChaptersArray addObject:newOne];
	}
	else
	{
		NSLog(@"Unknown XML Element");
	}


}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if([elementName isEqualToString:@"prokope"])
	{
		NSLog(@"Done Parsing Prokope");
	}
	else if ([elementName isEqualToString:@"author"])
	{
		AuthorCount ++;
	}
	else if ([elementName isEqualToString:@"work"])
	{
		WorkCount ++;
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
