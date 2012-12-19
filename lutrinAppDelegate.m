//
//  lutrinAppDelegate.m
//  lutrin
//
//  Created by Shigeru Hagiwara on 12/12/20.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "lutrinAppDelegate.h"

@implementation lutrinAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	
}


- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

@end
