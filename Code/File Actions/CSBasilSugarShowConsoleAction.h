//
//  CSBasilSugarShowConsoleAction.h
//  Basil.sugar
//
//  Created by Nicholas Penree on 4/10/09.
//  Copyright 2009 Conceited Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Growl/Growl.h>

@interface CSBasilSugarShowConsoleAction : NSObject <GrowlApplicationBridgeDelegate> {
	IBOutlet id logTextView;
	IBOutlet id panel;
	IBOutlet id scroller;
	
	NSTask *_task;
	NSFileHandle *_fileHandle;
	NSString *_fileName;
	NSDictionary *_fontAttributes;
	
	BOOL paused;
}

- (id)initWithDictionary:(NSDictionary *)dictionary bundlePath:(NSString *)bundlePath;
- (void)awakeFromNib;
- (void)dealloc;

- (BOOL)canPerformActionWithContext:(id)context;
- (BOOL)performActionWithContext:(id)context error:(NSError **)outError;

- (void)windowWillClose:(NSNotification *)notification;
- (void)readPipe:(NSNotification *)notification;

- (void)logText:(NSString *)textToLog;

- (IBAction)clearLogView:(id)sender;
- (IBAction)addMarkerToLogView:(id)sender;

- (NSDictionary *)registrationDictionaryForGrowl;

@property BOOL paused;

@end
