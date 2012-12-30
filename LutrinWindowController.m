//
//  LutrinWindowController.m
//  lutrin
//
//  Created by Shigeru Hagiwara on 2012/12/20.
//
//

#import <AppKit/AppKit.h>
#import "LutrinWindowController.h"
#import "SingleViewController.h"


@interface LutrinWindowController (Utils)

- (void)displayViewController:(ImageViewController *)vc;

@end


@implementation LutrinWindowController

@synthesize box;
@synthesize singleViewController;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        singleViewController = [[SingleViewController alloc] initWithWindowController:self];
    }
    
    return self;
}


- (void)dealloc
{
    [singleViewController release];
    [super dealloc];
}


- (void)displaySingleViewController
{
    
    [self displayViewController:self.singleViewController];
}


- (void)displayViewController:(ImageViewController *)vc
{
    NSLog(@"displayViewController");
    [self.box setContentView:vc.view];
    
    NSRect boxRect = [[self.box contentView] frame];
    NSLog(@"boxRect = %f, %f, %f, %f", boxRect.origin.x, boxRect.origin.y, boxRect.size.width, boxRect.size.height);

    NSRect vcViewRect = vc.view.frame;
    NSLog(@"vcViewRect = %f, %f, %f, %f", vcViewRect.origin.x, vcViewRect.origin.y, vcViewRect.size.width, vcViewRect.size.height);
}


- (void)windowDidResize:(NSNotification *)notification
{
    [self.singleViewController windowDidResize:notification];
}


- (IBAction)openFile:(id)sender
{
    [self.singleViewController openFile:sender];
}


- (IBAction)nextFile: (id)sender
{
    [self.singleViewController nextFile:sender];
}


- (IBAction)prevFile: (id)sender
{
    [self.singleViewController prevFile:sender];
}


- (IBAction)firstFile: (id)sender
{
    [self.singleViewController firstFile:sender];
}


- (IBAction)lastFile: (id)sender
{
    [self.singleViewController lastFile:sender];
}


- (IBAction)zoomActualSize: (id)sender
{
    [self.singleViewController zoomActualSize:sender];
}


- (IBAction)zoomFitToWindow: (id)sender
{
    [self.singleViewController zoomFitToWindow:sender];
}


- (IBAction)zoomIn: (id)sender {
    [self.singleViewController zoomIn:sender];
}


- (IBAction)zoomOut: (id)sender {
    [self.singleViewController zoomOut:sender];
}


@end
