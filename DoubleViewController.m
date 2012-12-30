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
@synthesize rightImageProperties;
@synthesize leftToRight;


- (id)initWithWindowController:(NSWindowController *)_windowController
{
    self = [super initWithWindowController:_windowController
                                   nibName:@"DoubleViewController"];
    if (self) {
        leftToRight = TRUE;
    }
    
    return self;
}


- (void)dealloc
{
    [rightImageProperties release];
    [super dealloc];
}


- (NSURL *)nextFileUrl
{
    NSUInteger index = [self getFileIndex];
    index += 1;
    if (index >= self.fileList.count) {
        return [self transparentImage];
    } else {
        NSURL *url = (NSURL *)[self.fileList objectAtIndex:index];
        if (url == nil)
            url = [self transparentImage];
        return url;
    }
}


- (void)openImageURL:(NSURL*)url
{
    self.currentFile = url;
    if (url == nil) {
        [self loadImageTo:self.imageView URL:[self transparentImage]
               properties:&imageProperties];
        [self loadImageTo:self.rightImageView URL:[self transparentImage]
               properties:&rightImageProperties];
        [self.windowController.window setTitle:@"no image"];
        return;
    }
    
    if (leftToRight) {
        if ([self getFileIndex] == 0) {
            [self loadImageTo:self.imageView URL:[self transparentImage]
                   properties:&imageProperties];
            [self loadImageTo:self.rightImageView URL:url properties:&rightImageProperties];
        } else {
            [self loadImageTo:self.imageView URL:url properties:&imageProperties];
            [self loadImageTo:self.rightImageView URL:[self nextFileUrl]
                   properties:&rightImageProperties];
        }
    } else {
        if ([self getFileIndex] == 0) {
            [self loadImageTo:self.imageView URL:url properties:&imageProperties];
            [self loadImageTo:self.rightImageView URL:[self transparentImage]
                   properties:&rightImageProperties];
        } else {
            [self loadImageTo:self.imageView URL:[self nextFileUrl]
                   properties:&imageProperties];
            [self loadImageTo:self.rightImageView URL:url
                   properties:&rightImageProperties];
        }
    }
    [self.windowController.window setTitleWithRepresentedFilename:[url path]];
}


- (void)windowDidResize:(NSNotification *)notification
{
    [self.imageView zoomImageToFit:self];
    [self.rightImageView zoomImageToFit:self];
}


- (IBAction)nextFile: (id)sender
{
    if (self.fileList.count == 0) return;
    NSUInteger index = [self getFileIndex];
    index += (index == 0) ? 1 : 2;
    if (index >= self.fileList.count)
        index = self.fileList.count - 1;
    NSURL *url = (NSURL *)[self.fileList objectAtIndex:index];
    if (url)
        [self openImageURL:url];
}


- (IBAction)prevFile: (id)sender
{
    if (self.fileList.count == 0) return;
    NSUInteger index = [self getFileIndex];
    if (index == 0 || index == 1)
        index = 0;
    else
        index -= 2;
    NSURL *url = (NSURL *)[self.fileList objectAtIndex:index];
    if (url)
        [self openImageURL:url];
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
