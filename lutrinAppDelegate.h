//
//  lutrinAppDelegate.h
//  lutrin
//
//  Created by Shigeru Hagiwara on 12/12/20.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class LutrinWindowController;

@interface lutrinAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    IBOutlet LutrinWindowController *windowController;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet LutrinWindowController *windowController;

@end
