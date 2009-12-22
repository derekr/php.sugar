//
//  CSBasilReferenceWindow.m
//  PHP.sugar
//
//  Created by Nicholas Penree on 12/21/09.
//  Copyright 2009 Conceited Software. All rights reserved.
//

#import "CSBasilReferenceWindow.h"


@implementation CSBasilReferenceWindow

- (void)keyDown: (NSEvent *) event {
	
	if ([event keyCode] == 53){
        [self orderOut:self];
	}
	
}

@end
