//
//  CSBasilSugarCheckSyntaxAction.h
//  Basil.sugar
//
//  Created by Nicholas Penree on 4/14/09.
//  Copyright 2009 Conceited Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CSBasilSugarCheckSyntaxAction : NSObject {
	NSString *phpPath;
}

- (id)initWithDictionary:(NSDictionary *)dictionary bundlePath:(NSString *)bundlePath;
- (void)dealloc;

- (BOOL)canPerformActionWithContext:(id)context;
- (BOOL)performActionWithContext:(id)context error:(NSError **)outError;

- (NSDictionary *)parseLintResult:(NSString *)result;

@end
