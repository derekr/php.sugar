//
//  CSBasilSugarShowReferenceAction.h
//  Basil SDK
//
//  Created by Nicholas Penree on 4/15/09.
//  Copyright 2009 Conceited Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CSBasilSugarShowReferenceAction : NSObject {
	IBOutlet id webView;
	IBOutlet id panel;
	IBOutlet id searchField;
	
	IBOutlet id lookupPanel;
	IBOutlet id lookupSearchField;
	IBOutlet id providerPopup;
}

- (id)initWithDictionary:(NSDictionary *)dictionary bundlePath:(NSString *)bundlePath;
- (void)dealloc;

- (BOOL)canPerformActionWithContext:(id)context;
- (BOOL)performActionWithContext:(id)context error:(NSError **)outError;

- (NSString *)urlStringForWord:(NSString *)word;

- (BOOL)canGoBack;
- (BOOL)canGoForward;

- (void)setCanGoBack:(BOOL)value;
- (void)setCanGoForward:(BOOL)value;

- (IBAction)goBack:(id)sender;
- (IBAction)goForward:(id)sender;

- (IBAction)cancelLookup:(id)sender;
- (IBAction)performLookup:(id)sender;

@end
