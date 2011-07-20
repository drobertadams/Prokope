//
//  DocumentController.m
//  Prokope
//
//  Created by D. Robert Adams on 5/10/11.
//  Copyright 2011 Grand Valley State University. All rights reserved.
//

#import "DocumentController.h"
#import "DocumentViewerDelegate.h"
#import "WebViewController.h"

@implementation DocumentController

@synthesize document, commentary, vocabulary, sidebar, URL, Title, UserName;

/******************************************************************************
 * Closes this view.
 */
- (IBAction) close 
{
	[self dismissModalViewControllerAnimated:YES];
}


/******************************************************************************
 * Fetches and displays all the data related to a document.
 */
- (void)fetchDocumentData
{
	// Fetch the document from the server.
	//NSString *url = @"http://www.cis.gvsu.edu/~prokope/index.php/rest/document/1";
	//	NSString *url = @"http://localhost/~adams/Private/Prokope/index.php/rest/document/4";
	
	// Convert the NSMutable data into a normal string.
	NSError *error;
	NSString *data = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:URL] encoding:NSUTF8StringEncoding error:&error];

	// Make sure that links look like normal text.
	NSString *doc = @"<style type=\"text/css\">a { color: black; text-decoration: none; </style>";
	NSString *meta = @"<meta name='viewport' content='width=device-width; initial-scale=1.0; maximum-scale=4.0; user-scalable=1;' />";
	
	// This function highlights the specific <a> tag that the user just clicked. That word will remain highlighted until another
	// word is clicked. 
	NSString *script = 
	@"<script lang=\"text/javascript\">"
	"function highlightword(ref)"
	"{"
	"   var words = document.getElementsByTagName('a');"
	"   for(i = 0; i < words.length; i++)"
	"   {"
	"       if ( words[i].getAttribute('href') == ref )"
	"       {"       
	"	         words[i].style.backgroundColor = '#F5DEB3';"
	"       }"
	"       else"
	"       {"
	"            words[i].style.backgroundColor = '#FFFFFF';"
	"       }"
	"    }"
	"}"
	"</script>";

	NSString *scale_script = 
	@"<script lang=\"text/javascript\">"
	"function scale_images()"
	"{"
	"   for(i = 0; i < document.images.length; i++)"
	"   {"
	"       document.images[i].style.marginLeft = '5';"
	"       document.images[i].height = '11';"
	"   }"
	"}"
	"scale_images();"
	"</script>";
	
	doc = [doc stringByAppendingString:script];
	doc = [doc stringByAppendingString:meta];
	
	// Find the content of the document itself.
	doc = [doc stringByAppendingString:[self getXMLElement:@"<body>" endElement:@"</body>" fromData:data]];
	doc = [doc stringByAppendingString:scale_script];
	
	[document loadHTMLString:doc baseURL:nil];	

	// This javascript function highlights the coresponding li tag(s) that contain a match for a specific id
	// It then scrolls the window (in this case the UIWebView that holds it) to that li tag.
	NSString *js = 
	@"<script lang=\"text/javascript\">"
	"function show_only(ref)"
	"{"
	"	var comments = document.getElementsByTagName('li');"
	"   var found = false;"
	"	for (i = 0; i < comments.length; i++) {"
	"		comments[i].style.display = 'list-item';"
	"		if ( comments[i].getAttribute('ref') == ref) {"
	"            comments[i].style.backgroundColor = '#F5DEB3';"
//	"            comments[i].style.fontWeight = 'bold';"
	"            if(found == false)"
	"            {"
	"                var selectedPosX=0;"
	"			     var selectedPosY=0;"
	"                selectedPosX+=comments[i].offsetLeft;"
	"                selectedPosY+=comments[i].offsetTop;"
	"                window.scrollTo(selectedPosX,selectedPosY);"
	"                found = true;"
	"            }"
	"		}"
	"		else {"
	"			comments[i].style.backgroundColor = '#FFFFFF';"
	"           comments[i].style.fontWeight = 'normal';"
	"		}"
	"	}"
	"}"
	"</script>";
	
	NSString *hide_text =
	@"<script lang=\"text/javascript\">"
	"function hide_text()"
	"{   "
	"   var comments = document.getElementsByTagName('li');"
	"	for (i = 0; i < comments.length; i++)"
	"   {"
	"       comments[i].style.display = 'none';"
	"   }"
	"}   "
	"hide_text();"
	"    "
	"</script>";
	
	NSString *display_ratings = 
	@"<script lang=\"text/javascript\">"
	"function alert_me()"
	"{   "
	"    alert('hello me!');     "
	"}"
	"    "
	"function display_ratings()"
	"{"
	"	var comments = document.getElementsByTagName('li');"
	"   var i = 0;"
	"	for (i = 0; i < comments.length; i++)"
	"   {"
	"      var newdiv = document.createElement('div');"
//	"      newdiv.setAttribute('id', 'rate' + i);"
//	"      newdiv.innerHTML = '<a href=\"Like' + i +'\"><img src=\"http://www.justinantranikian.com/Photos/Like-Up.png\" /></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href=\"Dis-Like' + i +'\">Dis-Like</a>';"
	"      newdiv.innerHTML = '<a href=\"Like' + i +'\"><img width=25 height=25 src=\"http://www.justinantranikian.com/Photos/Like-Up.png\" /></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href=\"Dis-Like' + i +'\"><img width=25 height=25 src=\"http://www.justinantranikian.com/Photos/Dislike-Up.png\" /></a>';"
	"      comments[i].appendChild(newdiv);" 
	"	}"
	"}"
	"      "
	"function show_clear_link(int) "
	"{   "
	"      var test = document.getElementById('undo' + int);"
	"      if(!test)"
	"      {"
	"          var comments = document.getElementsByTagName('li');"
	"          var current = comments[int]; "
	"          current.setAttribute('id', 'undo' + int);"
	"          var newdiv = document.createElement('div');"
	"          newdiv.innerHTML = '<a href=\"Undo' + int +'\">UNDO</a>';"
	"          current.appendChild(newdiv);" 
	"      }"
	"      else"
	"      { "
	"          var comments = document.getElementsByTagName('li');"
	"          var current = comments[int]; "
    "          var children = current.childNodes;"
	"          var count = 1;  "
	"	       for (i = 0; i < children.length; i++)"
	"          {"
	"             if(children[i].tagName == 'DIV')   "
	"             {"
	"                 if(count == 2)"
	"                 { "
	"                     children[i].style.display = 'block'; "
	"                 }"
	"                 count += 1; "
	"             }"
	"          }"
	"      }"
	"}"
	"    "
	"function toggleLikeDislike(int, text)"
	"{"
	"      var comments = document.getElementsByTagName('li');"
	"      var current = comments[int]; "
	"      var children = current.childNodes;"
	"	   for (i = 0; i < children.length; i++)"
	"      {"
	"           if(children[i].tagName == 'DIV')   "
	"           {"
	"               var anchors = children[i].getElementsByTagName('img');"
    "               var like = anchors[0];"
	"               var dislike = anchors[1];"
	""
	"               var sentText = text + int;"
    "               var subSection = sentText.substring(0,4);"
	"               if(subSection == 'Like')"
	"               {"
	"                    like.src = 'http://www.justinantranikian.com/Photos/Like-Clicked.png';"
	"                    dislike.src = 'http://www.justinantranikian.com/Photos/Dislike-Up.png';"
	"               }"
	"               else"
	"               {"
	"                    like.src = 'http://www.justinantranikian.com/Photos/Like-Up.png';"
	"                    dislike.src = 'http://www.justinantranikian.com/Photos/Dislike-Clicked.png';"
	"               }"
	"               break;"
	"           }"
	"	    }"
	"}"
	"    "
	"function undo_button_clicked(int)"
	"{    "
	"      var comments = document.getElementsByTagName('li');"
	"      var current = comments[int]; "
	"      var children = current.childNodes;"
	"      var count = 1;  "
	"	   for (i = 0; i < children.length; i++)"
	"      {"
	"           if(children[i].tagName == 'DIV')   "
	"           {"
	"               if(count == 1)"
	"               {"
	"                   var anchors = children[i].getElementsByTagName('img');"
    "                   var like = anchors[0];"
	"                   var dislike = anchors[1];"
	"                                                          "
	"                   like.src = 'http://www.justinantranikian.com/Photos/Like-Up.png';"
	"                   dislike.src = 'http://www.justinantranikian.com/Photos/Dislike-Up.png';"
	"               }"
	"               if(count == 2)"
	"               { "
	"                   children[i].style.display = 'none';"
    "               } "
	"               count ++; "
	"           }"
	"      }"
	"}    "
	"display_ratings();"
	"</script>";
	
	
	// Find the content of the commentary.
	doc = [self getXMLElement:@"<commentary>" endElement:@"</commentary>" fromData:data];

	doc = [doc stringByAppendingString:js];
	doc = [doc stringByAppendingString:display_ratings];
	doc = [doc stringByAppendingString:meta];
	doc = [doc stringByAppendingString:hide_text];
	[commentary loadHTMLString:doc baseURL:nil];

	// Find the content of the vocabulary.
	doc = [self getXMLElement:@"<vocabulary>" endElement:@"</vocabulary>" fromData:data];
	doc = [doc stringByAppendingString:js];
	doc = [doc stringByAppendingString:hide_text];
	[vocabulary loadHTMLString:doc baseURL:nil];

	// Find the content of the sidebar.
	doc = [self getXMLElement:@"<sidebar>" endElement:@"</sidebar>" fromData:data];
	doc = [doc stringByAppendingString:meta];
	[sidebar loadHTMLString:doc baseURL:nil];
	
	[data release];
}

/******************************************************************************
 * Fetches an entire XML element. NOTE: This method uses substring operations,
 * not an XML parser. Therefore, all elements must be unique.
 */
- (NSString *) getXMLElement:(NSString *)startElement endElement:(NSString *)endElement fromData:(NSString *)data
{
	// Find where the start and end elements live.
	NSRange startRange = [data rangeOfString:startElement];	
	NSRange endRange = [data rangeOfString:endElement];
	
	// If we didn't find both elements, return an empty string.
	if (startRange.length == 0 || endRange.length == 0)
		return @"";
	
	// Create a range that subsumes the two elements and everything in between.
	NSRange dataRange;
	dataRange.location = startRange.location;
	dataRange.length = endRange.location - startRange.location + 1 + endRange.length;
	
	// Return the data between the two.
	return [data substringWithRange:dataRange];
}

/******************************************************************************
 * Force the application to remain in landscape mode.
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	return(interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

/******************************************************************************
 * Called after this view is loaded -- basically a constructor.
 */
- (void)viewDidLoad 
{
    [super viewDidLoad];
	RatingsArray = [[NSMutableArray alloc] initWithCapacity:100];
	
	// Create a delegate for the document viewer.
	document.delegate = [[DocumentViewerDelegate alloc] initWithController:self];

	// Make ourselves the delegate for the other web views.
	commentary.delegate = self;
	vocabulary.delegate = self;
	sidebar.delegate = self;
	
	// Go fetch and display the document.
	[self fetchDocumentData];
}


/* **********************************************************************************************************************
 * Called when any of the webviews (except document) wants to load a URL.
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	// "Other" means we are loading a page ourselves (i.e., not in response to click) -- probably a document.
	if (navigationType == UIWebViewNavigationTypeOther)
		return TRUE; // load the document
	
	// Did the user click on a link?
	else if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		
		// Get the URL begin requested and feed it to our imageViewController.
		NSString *StringRequest = [[request URL] absoluteString];
		if ( [StringRequest rangeOfString:@"http"].length == 0 )
		{
			NSRange theRange = [StringRequest rangeOfString:@"/" options:NSBackwardsSearch];
			NSString *path = [StringRequest substringFromIndex:theRange.location];
//			NSString *ending = [StringRequest substringFromIndex:StringRequest.length - 1];
			
			NSCharacterSet* nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
			NSString *ending = [path stringByTrimmingCharactersInSet:nonDigits];
			
			if([path hasPrefix:@"/Undo"])
			{
				NSString *js = [NSString stringWithFormat: @"undo_button_clicked('%@');", ending];
				[commentary stringByEvaluatingJavaScriptFromString:js];
				for (NSString *str in RatingsArray)
				{
					NSString *localend = [str stringByTrimmingCharactersInSet:nonDigits];
					if ([localend isEqualToString:ending])
					{
						[RatingsArray removeObject:str];
						break;
					}
				}
			}
			else
			{
				if ([path hasPrefix:@"/Like"])
				{
					NSString *jss = [NSString stringWithFormat: @"toggleLikeDislike('%@', 'Like');", ending];
					[commentary stringByEvaluatingJavaScriptFromString:jss];
				}
				else if([path hasPrefix:@"/Dis-Like"])
				{
					NSString *jss = [NSString stringWithFormat: @"toggleLikeDislike('%@', 'Dis-Like');", ending];
					[commentary stringByEvaluatingJavaScriptFromString:jss];
				}
				NSString *js = [NSString stringWithFormat: @"show_clear_link('%@');", ending];
				[commentary stringByEvaluatingJavaScriptFromString:js];
				NSString *found = @"false";
				int count = 0;
				for (NSString *str in RatingsArray)
				{
					NSString *localend = [str stringByTrimmingCharactersInSet:nonDigits];
					if ([localend isEqualToString:ending])
					{
						[RatingsArray replaceObjectAtIndex:count withObject:path];
						found = @"true";
						break;
					}
					count ++;
				}
				
				if([found isEqualToString:@"false"])
				{
					[RatingsArray addObject:path];
				}
				else
				{
					for (NSString *str in RatingsArray)
					{
						NSLog(str);
					}
				}
				return FALSE;
			}
		}
		// Meaning this was an actually http request. Therefore we have our own code that gets called, and we present a WebViewController
		// and show that with the contents of the request.
		else
		{
			// Load the image viewer nib and set the URL.
			WebViewController *webViewer = [[WebViewController alloc] initWithNibName:@"WebViewController"
																			   bundle:nil];
			webViewer.url = StringRequest;
			
			// If not using a popover, create a modal view.
			[self presentModalViewController:webViewer animated:YES];
			[webViewer release];
		}
	}
	
	// Ignore all other types of user interation.
	return FALSE;
}


/* **********************************************************************************************************************
 * Called by DocumentViewerDelegate when the user clicks on a word.
 */
- (void) wordClicked:(NSString *)id
{
	//[commentary loadHTMLString:id baseURL:nil];
	
	// Call the javascript show_only() function in the commentary UIWebView to display all comments associated with the
	// given id and hide all the others.
	NSString *js = [NSString stringWithFormat: 
							  @"show_only('%@');", id];
	[commentary stringByEvaluatingJavaScriptFromString:js];	
	[vocabulary stringByEvaluatingJavaScriptFromString:js];
	
	js = [NSString stringWithFormat:@"highlightword('%@')", id];
	[document stringByEvaluatingJavaScriptFromString:js];
	
	NSLog(@"Clicked was : %@", id);
	NSLog(@"On poem %@", URL);
	NSLog(@"By user : %@", UserName);
}


/******************************************************************************
 * This alert get shown when this view is first launched. There are two UITextFields
 * that are created and then added to the alert. Two buttons are also created in the 
 * initialization code. Furthermore the message is set to "\n\n\n..." to 'stretch' the 
 * alertView's boundries to include the two UITextFields.
 */
-(void)ShowAlert
{
	[log ShowAlert];
}

-(void)SetUpLoginButton
{
	self.navigationItem.rightBarButtonItem = nil;
	UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(ShowAlert)];          
	self.navigationItem.rightBarButtonItem = anotherButton;
	[anotherButton release];	
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */

@end
