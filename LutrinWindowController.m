//
//  LutrinWindowController.m
//  lutrin
//
//  Created by Shigeru Hagiwara on 2012/12/20.
//
//

#import <AppKit/AppKit.h>
#import "LutrinConstants.h"
#import "LutrinWindowController.h"
#import "SingleViewController.h"
#import "DoubleViewController.h"


@interface LutrinWindowController (Utils)

- (void)displayViewController:(SingleViewController *)vc;
- (void)startFullScreen;
- (void)stopFullScreen;

@end


@implementation LutrinWindowController

@synthesize box;
@synthesize singleMenuItem;
@synthesize leftToRightMenuItem;
@synthesize rightToLeftMenuItem;
@synthesize singleViewController;
@synthesize doubleViewController;
@synthesize originalTitle;


- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        singleViewController = [[SingleViewController alloc] initWithWindowController:self];
        doubleViewController = [[DoubleViewController alloc] initWithWindowController:self];
        currentViewController = nil;
        isFullScreen = FALSE;
    }
    
    return self;
}


- (void)dealloc
{
    [singleViewController release];
    [doubleViewController release];
    [originalTitle release];
    [super dealloc];
}


- (void)openFileImpl:(NSURL*)url
{
    [currentViewController openFileImpl:url];
}


- (void)clearImageView
{
    [currentViewController clearImageView];
}


- (void)setWindowTitle:(NSString *)newTitle
{
    self.originalTitle = newTitle;
    [self.window setTitle:newTitle];
}


- (IBAction)displaySingleViewController:(id)sender
{
    [self displayViewController:self.singleViewController];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:LT_SINGLE_VIEW forKey:LT_VIEW_TYPE];
    self.singleMenuItem.state = NSOnState;
    self.leftToRightMenuItem.state = NSOffState;
    self.rightToLeftMenuItem.state = NSOffState;
}


- (IBAction)displayDoubleViewLeftToRight:(id)sender
{
    self.doubleViewController.leftToRight = TRUE;
    [self displayViewController:self.doubleViewController];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:LT_LEFT_TO_RIGHT forKey:LT_VIEW_TYPE];
    self.singleMenuItem.state = NSOffState;
    self.leftToRightMenuItem.state = NSOnState;
    self.rightToLeftMenuItem.state = NSOffState;
}


- (IBAction)displayDoubleViewRightToLeft:(id)sender
{
    self.doubleViewController.leftToRight = FALSE;
    [self displayViewController:self.doubleViewController];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:LT_RIGHT_TO_LEFT forKey:LT_VIEW_TYPE];
    self.singleMenuItem.state = NSOffState;
    self.leftToRightMenuItem.state = NSOffState;
    self.rightToLeftMenuItem.state = NSOnState;
}


- (void)displayViewController:(SingleViewController *)vc
{
    NSURL *currentFile = currentViewController.currentFile;
    currentViewController = vc;
    [self.box setContentView:vc.view];
    [currentViewController openFileImpl:currentFile];
}


- (void)windowDidResize:(NSNotification *)notification
{
    [currentViewController windowDidResize:notification];
}


- (IBAction)openFile:(id)sender
{
    [currentViewController openFile:sender];
}


- (IBAction)nextFile: (id)sender
{
    [currentViewController nextFile:sender];
}


- (IBAction)prevFile: (id)sender
{
    [currentViewController prevFile:sender];
}


- (IBAction)firstFile: (id)sender
{
    [currentViewController firstFile:sender];
}


- (IBAction)lastFile: (id)sender
{
    [currentViewController lastFile:sender];
}


- (IBAction)zoomActualSize: (id)sender
{
    [currentViewController zoomActualSize:sender];
}


- (IBAction)zoomFitToWindow: (id)sender
{
    [currentViewController zoomFitToWindow:sender];
}


- (IBAction)zoomIn: (id)sender {
    [currentViewController zoomIn:sender];
}


- (IBAction)zoomOut: (id)sender {
    [currentViewController zoomOut:sender];
}


- (IBAction)toggleFullScreen:(id)sender
{
    if (isFullScreen) {
        isFullScreen = FALSE;
        [self stopFullScreen];
    } else {
        isFullScreen = TRUE;
        [self startFullScreen];
    }
}


- (void)startFullScreen
{
    // see also:
    // http://cocoadevcentral.com/articles/000028.php
    // http://stackoverflow.com/questions/4921910/how-to-make-a-mac-osx-cocoa-application-fullscreen
    
    originalWindowRect = self.window.frame;
    originalStyleMask = self.window.styleMask;
    originalWindowLevel = self.window.level;
    self.originalTitle = self.window.title;
    
    if (CGDisplayCapture( kCGDirectMainDisplay ) != kCGErrorSuccess) {
        NSLog( @"Couldn't capture the main display!" );
    }
    
    int windowLevel = CGShieldingWindowLevel();
    NSRect screenRect = [[NSScreen mainScreen] frame];
    
    NSLog(@"full screen window size ");
    [self.window setStyleMask:NSBorderlessWindowMask];
    [self.window setFrame:screenRect display:YES];
    [self.window setLevel:windowLevel];
    [self.window makeKeyAndOrderFront:nil];
}


- (void)stopFullScreen
{
    if (CGDisplayRelease( kCGDirectMainDisplay ) != kCGErrorSuccess) {
        NSLog( @"Couldn't release the display(s)!" );
    }
    NSLog(@"restore window size ");
    [self.window setStyleMask:originalStyleMask];
    [self.window setLevel:originalWindowLevel];
    [self.window setFrame:originalWindowRect display:YES];
    [self.window setTitle:self.originalTitle];
}

@end
