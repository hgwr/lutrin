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

- (void)setupDefaults;

@end


@implementation lutrinAppDelegate

@synthesize window, windowController;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    [self setupDefaults];
    NSString *viewType =
        [[NSUserDefaults standardUserDefaults] stringForKey:LT_VIEW_TYPE];
    if ([viewType isEqualToString:LT_SINGLE_VIEW]) {
        [self.windowController displaySingleViewController:nil];
    } else if ([viewType isEqualToString:LT_LEFT_TO_RIGHT]) {
        [self.windowController displayDoubleViewLeftToRight:nil];
    } else if ([viewType isEqualToString:LT_RIGHT_TO_LEFT]) {
        [self.windowController displayDoubleViewRightToLeft:nil];
    }
}


- (void)setupDefaults {
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
    [defaultValues setObject:LT_SINGLE_VIEW forKey:LT_VIEW_TYPE];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}


- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}


- (BOOL)application:(NSApplication *)theApplication
           openFile:(NSString *)filename
{
    [windowController openFileImpl:[NSURL fileURLWithPath:filename]];
    return YES;
}

@end
