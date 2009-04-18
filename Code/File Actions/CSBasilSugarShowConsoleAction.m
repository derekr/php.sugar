//
//  CSBasilSugarShowConsoleAction.m
//  Basil.sugar
//
//  Created by Nicholas Penree on 4/10/09.
//  Copyright 2009 Conceited Software. All rights reserved.
//

#import "CSBasilSugarShowConsoleAction.h"
#import <EspressoSDK.h>
#import <Growl/Growl.h>

@implementation CSBasilSugarShowConsoleAction
	@synthesize paused;

+ (void)initialize
{
	NSData *defaultColor = [NSArchiver archivedDataWithRootObject:[NSColor whiteColor]];
	NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:defaultColor, @"fontColor", 
																		   @"Monaco", @"fontName", 
																		   [NSNumber numberWithDouble:9.0], @"fontSize", 
																		   nil];
	
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
}

//------------------------------------------------------------------------------------------------------------------------------------------

- (id)initWithDictionary:(NSDictionary *)dictionary bundlePath:(NSString *)bundlePath
{
	self = [super init];
	if (self == nil)
		return nil;
	
	if (![NSBundle loadNibNamed:@"CSBasilSugarConsole" owner:self])
		return nil;
	
	_fileName = [[dictionary objectForKey:@"filename"] retain];
	[GrowlApplicationBridge setGrowlDelegate:self];
	[panel setDelegate:self];
	[self clearLogView:self];
	self.paused = YES;
	
	NSColor *color = (NSColor *)[NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"fontColor"]];
	_fontAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:color, NSForegroundColorAttributeName,
							 [NSFont fontWithName:[[NSUserDefaults standardUserDefaults] stringForKey:@"fontName"] size:[[NSUserDefaults standardUserDefaults] doubleForKey:@"fontSize"]], NSFontAttributeName, nil];
	return self;
}

//------------------------------------------------------------------------------------------------------------------------------------------

- (void)windowWillClose:(NSNotification *)notification
{
	if ([notification object] == panel) {
		[_task terminate];
		[self clearLogView:self];
	}
}

//------------------------------------------------------------------------------------------------------------------------------------------

- (void)awakeFromNib
{	
	[self clearLogView:self];
}

//------------------------------------------------------------------------------------------------------------------------------------------

- (void)dealloc
{	
	[_fileName autorelease];
	[_task release];
	[_fileHandle release];
	[_fontAttributes release];
	[super dealloc];
}

//------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark Sugar Action methods
//------------------------------------------------------------------------------------------------------------------------------------------

- (BOOL)canPerformActionWithContext:(id)context
{
	return [[NSFileManager defaultManager] fileExistsAtPath:_fileName];
}

//------------------------------------------------------------------------------------------------------------------------------------------

- (BOOL)performActionWithContext:(id)context error:(NSError **)outError
{
	[panel setTitle:[NSString stringWithFormat:@"%@ - Basil Console", [_fileName lastPathComponent]]];
	
	[self clearLogView:self];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(readPipe:)
												 name:NSFileHandleReadCompletionNotification 
											   object:nil];
	
	NSPipe *pipe = [NSPipe pipe];
	
	_fileHandle = [pipe fileHandleForReading];
	[_fileHandle readInBackgroundAndNotify];
	
	_task = [[NSTask alloc] init];
	[_task setLaunchPath:@"/usr/bin/tail"];
	[_task setArguments: [NSArray arrayWithObjects:@"-f", _fileName, nil]];
	[_task setStandardOutput: pipe];
	[_task setStandardError: pipe];
	[_task launch];
	
	self.paused = NO;
	
	[panel makeKeyAndOrderFront:nil];

	return YES;
}

//------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark Utility methods
//------------------------------------------------------------------------------------------------------------------------------------------

- (void)logText:(NSString *)textToLog
{
	NSAttributedString *string = [[NSAttributedString alloc] initWithString:textToLog attributes:_fontAttributes];
	
	@try {
		[[logTextView textStorage] appendAttributedString:string];
	}
	@catch (NSException *e) {
		NSLog(@"omg fail - %@", e);
	}

	[string release];
}

//------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark Controller actions
//------------------------------------------------------------------------------------------------------------------------------------------

- (IBAction)clearLogView:(id)sender
{
	if (logTextView) {
		[logTextView setString:@""];
	}
}

//------------------------------------------------------------------------------------------------------------------------------------------

- (IBAction)addMarkerToLogView:(id)sender
{
	if (logTextView) {
		[self logText:@"◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼\n"];
		NSRange range = NSMakeRange ([[[logTextView textStorage] mutableString] length], 0);
		[logTextView scrollRangeToVisible:range];
	}
}

//------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark Growl Crap
//------------------------------------------------------------------------------------------------------------------------------------------

- (NSDictionary *)registrationDictionaryForGrowl
{
	NSArray *growlNotifications = [NSArray arrayWithObjects: @"Generic", @"Log Updated", nil];
	
	return [NSDictionary dictionaryWithObjectsAndKeys: growlNotifications, GROWL_NOTIFICATIONS_ALL,
			growlNotifications, GROWL_NOTIFICATIONS_DEFAULT,
			nil];
}

//------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark New Data Tailed notification
//------------------------------------------------------------------------------------------------------------------------------------------

- (void)readPipe:(NSNotification *)notification
{
	NSData *data;
	NSString *text;
	
	if([notification object] != _fileHandle)
		return;
	
	data = [[notification userInfo] objectForKey:NSFileHandleNotificationDataItem];
	text = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	
	@try {
		if (![[[logTextView textStorage] mutableString] isEqualToString:@""]) {
			[GrowlApplicationBridge 
			 notifyWithTitle:[NSString stringWithFormat:@"%@ Updated", [_fileName lastPathComponent]]
			 description:(([text length] > 20)? [NSString stringWithFormat:@"%@...", [text substringToIndex:19]] : text)
			 notificationName:@"Log Updated" 
			 iconData:nil
			 priority:0
			 isSticky:NO 
			 clickContext:nil];
		}
		
		float scrollPos = [[scroller verticalScroller] floatValue]; 
		
		[self logText:text];	
		
		if( scrollPos == 1.0 || scrollPos == 0.0) {
			NSRange range = NSMakeRange ([[[logTextView textStorage] mutableString] length], 0);
			[logTextView scrollRangeToVisible:range];
		}
	}
	@catch (NSException * e) {
		
	}
	[text release];
	
	if(data != 0)
		[_fileHandle readInBackgroundAndNotify];
}

@end
