//
//  lutrinAppDelegate.m
//  lutrin
//
//  Created by Shigeru Hagiwara on 12/12/20.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LutrinConstants.h"
#import "lutrinAppDelegate.h"
#import "LutrinWindowController.h"
#import "SingleViewController.h"


@interface lutrinAppDelegate (Utils)

@end


@implementation lutrinAppDelegate

@synthesize window, windowController;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self.windowController setupViewController];
}


- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}


- (BOOL)application:(NSApplication *)theApplication
           openFile:(NSString *)filename
{
    [self.windowController openFileImpl:[NSURL fileURLWithPath:filename]];
    return YES;
}

@end
