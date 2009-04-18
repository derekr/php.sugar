//
//  CSBasilSugarCheckSyntaxAction.m
//  Basil.sugar
//
//  Created by Nicholas Penree on 4/14/09.
//  Copyright 2009 Conceited Software. All rights reserved.
//

#import "CSBasilSugarCheckSyntaxAction.h"
#import <EspressoSDK.h>

@implementation CSBasilSugarCheckSyntaxAction

- (id)initWithDictionary:(NSDictionary *)dictionary bundlePath:(NSString *)bundlePath
{
	self = [super init];
	if (self == nil)
		return nil;
	
	phpPath = [[dictionary objectForKey:@"php-path"] copy]; //a.g.
	
	return self;
}

//------------------------------------------------------------------------------------------------------------------------------------------

- (void)dealloc
{	
	[phpPath release];
	[super dealloc];
}

//------------------------------------------------------------------------------------------------------------------------------------------

- (BOOL)canPerformActionWithContext:(id)context
{
	return ([[NSFileManager defaultManager] fileExistsAtPath:phpPath] && 
			[[NSFileManager defaultManager] fileExistsAtPath:[[[context documentContext] fileURL] path]]);
}

//------------------------------------------------------------------------------------------------------------------------------------------

- (BOOL)performActionWithContext:(id)context error:(NSError **)outError
{
	NSTask *task = [[NSTask alloc] init];
	NSPipe *pipe = [NSPipe pipe];
	NSString *string;
	NSAlert *sheet;
	NSDictionary *lintResults;
	NSString *tmpFile = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat: @"%.0f.%@", [NSDate timeIntervalSinceReferenceDate] * 1000.0, @"php"]];

	// write our current text to a temp file so we can pass it to php lint checker
	[[context string] writeToFile:tmpFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
	
    [task setLaunchPath:phpPath];
    [task setArguments:[NSArray arrayWithObjects: @"-l", tmpFile, nil]];
    [task setStandardOutput:pipe];
    [task launch];
		
    string = [[NSString alloc] initWithData:[[pipe fileHandleForReading] readDataToEndOfFile] encoding:NSUTF8StringEncoding];
	lintResults = [self parseLintResult:[string stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@" in %@", tmpFile] withString:@""]];
	[string release];
	[task release];
	
	// remove temp file just be be safe
	[[NSFileManager defaultManager] removeFileAtPath:tmpFile handler:nil];

	sheet = [NSAlert alertWithMessageText:[lintResults objectForKey:@"CSTitle"] defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:[lintResults objectForKey:@"CSMessage"]];   
	[sheet beginSheetModalForWindow:[context windowForSheet] modalDelegate:nil didEndSelector:nil contextInfo:nil];
		
	return YES;
}

//------------------------------------------------------------------------------------------------------------------------------------------

- (NSDictionary *)parseLintResult:(NSString *)result
{
	NSString *title;
	NSString *message;
	
	// only english support atm, otherwise it will just toss the output into a sheet
	
	if ([result hasPrefix:@"No syntax errors detected"]) {
		title = @"No syntax errors detected.";
		message = @"Please note that this is syntax checker, which will look for scripting tags and ensure the code within complies with the PHP language structure. It will not pick up runtime level errors.";
	} else if ([result containsString:@"Errors parsing"]) {
		NSRange r = [result rangeOfString:@"Errors parsing"];
		
		if (r.location != NSNotFound) {
			title = @"We've detected syntax errors during parsing.";
			message = [[result substringToIndex:r.location] stringByRemovingLeadingWhitespace];
		} else {
			title = @"PHP Syntax Check";
			message = result;
		}
	} else {
		title = @"PHP Syntax Check";
		message = result;
	}
	
	return [NSDictionary dictionaryWithObjectsAndKeys:title, @"CSTitle", message, @"CSMessage", nil];
}

@end
