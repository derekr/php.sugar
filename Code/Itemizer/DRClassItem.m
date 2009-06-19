//
//  DRClassItem.m
//  PHP.sugar
//
//  Created by Derek Reynolds on 4/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DRClassItem.h"


@implementation DRClassItem

- (void)initializeWithCapturedZones:(NSDictionary *)captures recipeInfo:(NSDictionary *)recipeInfo
{
	[super initializeWithCapturedZones:captures recipeInfo:recipeInfo];
	
	name = [[[captures objectForKey:@"className"] text] retain];
	NSLog(@"captures: %@", captures);
	NSLog(@"capture zone: %@", name);
}

- (void)dealloc
{
	[name release];
	name = nil;
	[super dealloc];
}

- (BOOL)transformIntoItem:(DRClassItem *)otherItem
{
	// Note: the passed argument can actually be any item class, but casting it to this specific class makes it easy to write the transformation code. The default (super) implementation takes care of checking the class, so this is perfectly valid.
	if (![super transformIntoItem:otherItem])
		return NO;
	
	// Clean up our own old values
	[name release];
	name = nil;
	
	// Take over the new values from the other item
	name = [otherItem->name retain];
	
	return YES;
}

- (BOOL)isDecorator
{
	return YES;
}

- (CEItemDecorationType)decorationType
{
	return CEItemDecorationDefault;
}

- (NSColor *)backgroundColor
{
	return [NSColor yellowColor];
}

- (NSImage *)image
{
	NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"class" ofType:@"png"];
	NSImage *image = [[NSImage alloc] initWithContentsOfFile:path];
	[image autorelease];
	return image;
}

- (BOOL)isTextualizer
{
	return YES;
}

- (NSString *)title
{
	return name;
}

@end
