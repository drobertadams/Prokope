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

/******************************************************************************
 * This method is called when the application first begins to launch.
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
 	
    // Override point for customization after app launch.
	
	AuthorsArray = [[NSMutableArray alloc] initWithCapacity:100];
	
	AuthorCount = 0;							
	WorkCount = 0;
		
//	NSString* path = [[NSBundle mainBundle] pathForResource: @"Authors" ofType: @"xml"];
//	NSData* data = [NSData dataWithContentsOfFile: path];
	
	NSURL *url = [NSURL URLWithString:@"http://www.cis.gvsu.edu/~prokope/index.php/rest"];
//	NSURL *url = [NSURL URLWithString:@"https://www.cis.gvsu.edu/~prokope/index.php/rest/big"];
	NSData *data = [NSData dataWithContentsOfURL:url]; 
	NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data];
	
	// The current tag keeps track of what the current element is in the parser. 
	CurrentTag = @"";
	
	// Set the parser's delgate to this class, since it implements the NSXMLParserDelegate protocol.
	[parser setDelegate:self];
	[parser parse];
	[parser release];
	
	// This line initialized the navigation controller. 
	ProkopeNavigationController = [[UINavigationController alloc] init];
	
	[window addSubview:ProkopeNavigationController.view];
	
	// Calling the SetDataArray will give the next controller the data we got from parsing the XML file.
	// It is an essential method, and it is how controllers pass data to other controllers. 
	viewController = [[ProkopeViewController alloc] initWithNibName:@"ProkopeViewController" bundle:nil];
	[viewController SetDataArray:AuthorsArray];
	
	UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Prokope" style:UIBarButtonItemStylePlain target:nil action:nil];          
	viewController.navigationItem.backBarButtonItem = anotherButton;
	[anotherButton release];
	
	[ProkopeNavigationController pushViewController:viewController animated:NO];
	[viewController release];
	
    [self.window makeKeyAndVisible];
	
	return YES;
}

/******************************************************************************
 * This method is used by the NSXMLParserDelegate protocol and it populates all
 * the data from the XML file. The data is populated with Authors, Works, and
 * Chapters using NSMutableArrays for each of these XML tags.
 */
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
		newAuthor.bio =	@"Cicero was a <i>great</i> speaker. He had many important works, and was well liked by"
			"all of his peers. His works continue to inspire people. Check out his <strong> wikipedia </strong>"
			"page for more info.";
		
		[AuthorsArray addObject:newAuthor];
		CurrentTag = @"author";
		
	}
	else if ([elementName isEqualToString:@"work"])
	{	
		NSString *url = [attributeDict objectForKey:@"url"];
		NSString *name = [attributeDict objectForKey:@"name"]; 

		Work *w = [[Work alloc] init];
		w.name = name;
		w.workURL = url;
		
		Author *a = [AuthorsArray objectAtIndex:AuthorCount];
		[a.WorksArray addObject:w];
		[w release];
		CurrentTag = @"work";
	}
	else if ([elementName isEqualToString:@"chapter"])
	{	
		NSString *name = [attributeDict objectForKey:@"name"];
		NSString *url = [attributeDict objectForKey:@"url"]; 
		
		// This is the key to setting up the array. The counts are incremented as the XML file is being parsed.
		// That serves as a place holder to know where to insert the 'Chapters'.
		Author *a = [AuthorsArray objectAtIndex:AuthorCount];
		Work *w = [a.WorksArray objectAtIndex:WorkCount];
		
		Work *newOne = [[Work alloc] init];
		newOne.name = name;
		newOne.workURL = url;
		
		[w.ChaptersArray addObject:newOne];
		CurrentTag = @"chapter";
	}
	else if ([elementName isEqualToString:@"bio"])
	{
	    CurrentTag = @"bio";
	}
	else
	{
		CurrentTag = @"nothing";
	}
}

/******************************************************************************
 * This method is part of the NSXMLParserDelegate protocol. Whenever there is 
 * data found between the XML tags this method is called. This is part of the 
 * event driven parser model that the i-phone gives us.
 */
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if ([CurrentTag isEqualToString:@"bio"])
	{
	    Author *a = [AuthorsArray objectAtIndex:AuthorCount];
		a.bio = string;
		
		[AuthorsArray replaceObjectAtIndex:AuthorCount withObject:a];
		[a release];
	}
}
		 
/******************************************************************************
 * This method is used by the NSXMLParserDelegate protocol and it keeps track of
 * what the current author and work are. 
 */
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if([elementName isEqualToString:@"prokope"])
	{
	//	NSLog(@"Done Parsing Prokope");
	}
	else if ([elementName isEqualToString:@"author"])
	{
		// Since the NSXMLParserDelegate is an event driven parser these 'counts' are incremented
		// in order to know what the current author and work are. 
		AuthorCount ++;
	}
	else if ([elementName isEqualToString:@"work"])
	{
		WorkCount ++;
	}
	else if ([elementName isEqualToString:@"bio"])
	{
		CurrentTag = @"";
	}
}

/******************************************************************************
 * This is an autogenerated method.
 */
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

/******************************************************************************
 * This is an autogenerated method.
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

/******************************************************************************
 * This is an autogenerated method.
 */
- (void)applicationWillTerminate:(UIApplication *)application
{

}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

/******************************************************************************
 * This clears up our memory.
 */
- (void)dealloc
{
    [viewController release];
    [window release];
//	[AuthorsArray release];
    [super dealloc];
}





@end
