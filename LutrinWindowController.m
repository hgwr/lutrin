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

@end


@implementation LutrinWindowController

@synthesize box;
@synthesize singleMenuItem;
@synthesize leftToRightMenuItem;
@synthesize rightToLeftMenuItem;
@synthesize singleViewController;
@synthesize doubleViewController;


- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        singleViewController = [[SingleViewController alloc] initWithWindowController:self];
        doubleViewController = [[DoubleViewController alloc] initWithWindowController:self];
        currentViewController = nil;
    }
    
    return self;
}


- (void)dealloc
{
    [singleViewController release];
    [doubleViewController release];
    [super dealloc];
}


- (void)openFileImpl:(NSURL*)url
{
    [currentViewController openFileImpl:url];
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
    [self displayViewController:self.doubleViewController];
    self.doubleViewController.leftToRight = TRUE;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:LT_LEFT_TO_RIGHT forKey:LT_VIEW_TYPE];
    self.singleMenuItem.state = NSOffState;
    self.leftToRightMenuItem.state = NSOnState;
    self.rightToLeftMenuItem.state = NSOffState;
}


- (IBAction)displayDoubleViewRightToLeft:(id)sender
{
    [self displayViewController:self.doubleViewController];
    self.doubleViewController.leftToRight = FALSE;
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


@end
