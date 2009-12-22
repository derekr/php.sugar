//
//  CSBasilSugarShowReferenceAction.m
//  Basil SDK
//
//  Created by Nicholas Penree on 4/15/09.
//  Copyright 2009 Conceited Software. All rights reserved.
//

#import "CSBasilSugarShowReferenceAction.h"
#import <EspressoSDK.h>
#import <WebKit/WebKit.h>

@implementation CSBasilSugarShowReferenceAction

- (id)initWithDictionary:(NSDictionary *)dictionary bundlePath:(NSString *)bundlePath
{
	self = [super init];
	if (self == nil)
		return nil;
	
	if (![NSBundle loadNibNamed:@"CSBasilSugarReference" owner:self])
		return nil;
	
	[searchField setDelegate:self];
	
	return self;
}

//------------------------------------------------------------------------------------------------------------------------------------------

- (void)awakeFromNib
{
	[webView setPolicyDelegate:self];
	[webView setDownloadDelegate:self];
	[webView setFrameLoadDelegate:self];
	[webView setApplicationNameForUserAgent:@"Espresso PHP.sugar"];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noteFromWebView:) name:WebViewProgressFinishedNotification object:webView];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noteFromWebView:) name:WebViewProgressStartedNotification object:webView];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noteFromWebView:) name:WebViewProgressEstimateChangedNotification object:webView];	
}

//------------------------------------------------------------------------------------------------------------------------------------------

- (void)dealloc
{	
    [[NSNotificationCenter defaultCenter] removeObserver:self];

	[super dealloc];
}

//------------------------------------------------------------------------------------------------------------------------------------------

- (BOOL)canPerformActionWithContext:(id)context
{
	return ([[context selectedRanges] count] > 0);
}

//------------------------------------------------------------------------------------------------------------------------------------------

- (BOOL)performActionWithContext:(id)context error:(NSError **)outError
{
	NSString *string = [[context string] substringWithRange:[[[context selectedRanges] objectAtIndex:0] rangeValue]];
	
	if (![string isEqualToString:@""]) {
		//NSLog(@"-- %@", [[context selectedRanges] objectAtIndex:0]);
		[panel setTitle:[NSString stringWithFormat:@"%@ - PHP Reference", string]];
		
		//NSLog(@"%@", string);
		[webView setMainFrameURL:[self urlStringForWord:string]];
		[panel makeKeyAndOrderFront:nil];
	} else {
		//NSLog(@"nothing selected");
		[lookupPanel makeKeyAndOrderFront:nil];
	}
	
	return YES;
}

//------------------------------------------------------------------------------------------------------------------------------------------

- (IBAction)navigationPressed:(id)sender
{	
	int selectedSegment = [sender selectedSegment];
	
	if (selectedSegment == 0) {
		[self goBack:sender];
	} else if (selectedSegment == 1) {
		[self goForward:sender];
	}
}

//------------------------------------------------------------------------------------------------------------------------------------------

- (NSString *)urlStringForWord:(NSString *)word
{
	if ([word hasPrefix:@"BS"]) {
		return [NSString stringWithFormat:@"http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Classes/%@_Class/", [word stringByReplacingOccurrencesOfString:@"BS" withString:@"NS"]];
	}
	return [NSString stringWithFormat:@"http://php.net/%@", word];
}

//------------------------------------------------------------------------------------------------------------------------------------------

- (BOOL)canGoBack
{
	return [webView canGoBack];
}

//------------------------------------------------------------------------------------------------------------------------------------------

- (BOOL)canGoForward
{
	return [webView canGoForward];
}

//------------------------------------------------------------------------------------------------------------------------------------------

- (void)setCanGoBack:(BOOL)value
{
	
}

//------------------------------------------------------------------------------------------------------------------------------------------

- (void)setCanGoForward:(BOOL)value
{
	
}

//------------------------------------------------------------------------------------------------------------------------------------------

- (IBAction)goBack:(id)sender
{
	[webView goBack:sender];
}

//------------------------------------------------------------------------------------------------------------------------------------------

- (IBAction)goForward:(id)sender
{
	[webView goForward:sender];
}

//------------------------------------------------------------------------------------------------------------------------------------------

-(BOOL)control:(NSControl*)control textView:(NSTextView*)textView doCommandBySelector:(SEL)commandSelector
{
    BOOL result = NO;
	
    if (commandSelector == @selector(insertNewline:)) {
		// enter pressed
		NSLog(@"enter");
		
		if (control == lookupSearchField) {
			[self performLookup:self];
			
			result = YES;
		}
		
		return NO;
    }
	else if(commandSelector == @selector(moveLeft:)) {
		// left arrow pressed
		NSLog(@"left");
		result = NO;
	}
	else if(commandSelector == @selector(moveRight:)) {
		// rigth arrow pressed
		NSLog(@"right");
		result = NO;
	}
	else if(commandSelector == @selector(moveUp:)) {
		// up arrow pressed
		NSLog(@"up");
		result = YES;
	}
	else if(commandSelector == @selector(moveDown:)) {
		// down arrow pressed
		NSLog(@"down");
		result = YES;
	}
    return result;
}

- (void)webView:(WebView *)sender mouseDidMoveOverElement:(NSDictionary *)elementInformation modifierFlags:(NSUInteger)modifierFlags
{
	NSString *status = @"";
	NSURL *link = [elementInformation objectForKey: WebElementLinkURLKey];
	if (link) {
		// If the Command key is held down, the link will open in the web browser:
		NSString *browserName;
		browserName = @"browser";
		
		status = [NSString stringWithFormat:@"Open \"%@\" in %@", [link absoluteString], browserName];
	}
	[statusText setString:status];
	[statusText setNeedsDisplay:YES];
}

//------------------------------------------------------------------------------------------------------------------------------------------

- (IBAction)cancelLookup:(id)sender
{
	[lookupPanel orderOut:sender];
}

//------------------------------------------------------------------------------------------------------------------------------------------

- (IBAction)performLookup:(id)sender
{
	NSString *string;
	
	[panel setTitle:[NSString stringWithFormat:@"%@ - PHP Reference", [lookupSearchField stringValue]]];
	NSLog(@"%@", [providerPopup selectedItem]);
	if ([[[providerPopup selectedItem] title] isEqualToString:@"Google"]) {
		string = [NSString stringWithFormat:@"http://google.com/search?q=%@", [lookupSearchField stringValue]];
	} else if ([[[providerPopup selectedItem] title] isEqualToString:@"Apple"]) {
		string = [NSString stringWithFormat:@"http://developer.apple.com/search.php?&q=%@&as_q=filetype:html%20OR%20filetype:htm&num=10&lr=lang_en&site=(guides)|(releasenotes)|(reference)|(samplecode)|(technicalnotes)|(technicalqas)", [lookupSearchField stringValue]];
	} else if ([[[providerPopup selectedItem] title] isEqualToString:@"PHP"]) {
		string = [NSString stringWithFormat:@"http://php.net/%@", [lookupSearchField stringValue]];
	} else {
		return;
	}
	
	[webView setMainFrameURL:string];
	[lookupPanel orderOut:sender];
	[panel makeKeyAndOrderFront:nil];
}

-(void)noteFromWebView:(NSNotification*)notification
{
	NSString *name = [notification name];
	
	if([name isEqualToString:WebViewProgressFinishedNotification]){
		DOMDocument *doc = [[webView mainFrame] DOMDocument];    
		NSString *style = [[NSBundle bundleForClass:[CSBasilSugarShowReferenceAction class]] pathForResource:@"phpref" ofType:@"css"];
		
		if ([[NSFileManager defaultManager] fileExistsAtPath:style]) {
			DOMElement *newStyle = [doc createElement:@"style"];
			[newStyle setAttribute:@"type" value:@"text/css"];
			[newStyle setTextContent:[NSString stringWithContentsOfFile:style encoding:NSUTF8StringEncoding error:nil]];
			[[[doc getElementsByTagName:@"head"] item:0] appendChild:newStyle];
		}
	}
}


@end
