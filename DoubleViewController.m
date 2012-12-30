//
//  DoubleViewController.m
//  lutrin
//
//  Created by Shigeru Hagiwara on 2012/12/30.
//
//

#import "DoubleViewController.h"

@interface DoubleViewController ()

@end


@implementation DoubleViewController


@synthesize rightImageView;


- (id)initWithWindowController:(NSWindowController *)_windowController
{
    self = [super initWithWindowController:_windowController nibName:@"DoubleViewController"];
    if (self) {

    }
    
    return self;
}


- (void)openImageURL:(NSURL*)url
{
    // TODO override
    [self loadImageTo:self.imageView URL:url];
    [self.windowController.window setTitleWithRepresentedFilename:[url path]];
}


- (void)windowDidResize:(NSNotification *)notification
{
    [self.imageView zoomImageToFit:self];
    [self.rightImageView zoomImageToFit:self];
}


- (IBAction)zoomActualSize: (id)sender
{
    [super zoomActualSize:sender];
    [self.rightImageView zoomImageToActualSize:sender];
}


- (IBAction)zoomFitToWindow: (id)sender
{
    [super zoomFitToWindow:sender];
    [self.rightImageView zoomImageToFit:sender];
}


- (IBAction)zoomIn: (id)sender
{
    [super zoomIn:sender];
    [self.rightImageView zoomIn:sender];
}


- (IBAction)zoomOut: (id)sender
{
    [super zoomOut:sender];
    [self.rightImageView zoomOut:sender];
}


@end
