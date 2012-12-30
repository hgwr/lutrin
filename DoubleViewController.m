//
//  DoubleViewController.m
//  lutrin
//
//  Created by Shigeru Hagiwara on 2012/12/30.
//
//

#import "DoubleViewController.h"
#import "LutrinWindowController.h"


@interface DoubleViewController (Util)

- (NSString *)makeTitle:(NSURL *)leftUrl right:(NSURL *)rightUrl;

@end


@implementation DoubleViewController


@synthesize rightImageView;
@synthesize rightImageProperties;
@synthesize leftToRight;


- (id)initWithWindowController:(LutrinWindowController *)_windowController
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


- (NSString *)makeTitle:(NSURL *)leftUrl right:(NSURL *)rightUrl
{
    NSString *leftName = [leftUrl lastPathComponent];
    if ([leftUrl isEqual:[self transparentImage]])
        leftName = @"";
    NSString *rightName = [rightUrl lastPathComponent];
    if ([rightUrl isEqual:[self transparentImage]])
         rightName = @"";
    NSString *title = [NSString stringWithFormat:@"%@ | %@ (%ld/%ld)",
                       leftName, rightName,
                       ([self getFileIndex] + 1), self.fileList.count];
    return title;
}


- (void)clearImageView
{
    [super clearImageView];
    [self loadImageTo:self.rightImageView URL:[self transparentImage]
           properties:&rightImageProperties];
}


- (void)openImageURL:(NSURL *)url
{
    self.currentFile = url;
    if (url == nil) {
        [self loadImageTo:self.imageView URL:[self transparentImage]
               properties:&imageProperties];
        [self loadImageTo:self.rightImageView URL:[self transparentImage]
               properties:&rightImageProperties];
        [self.windowController setWindowTitle:@"no image"];
        return;
    }

    NSURL *leftUrl = nil;
    NSURL *rightUrl = nil;
    if (leftToRight) {
        if ([self getFileIndex] == 0) {
            leftUrl = [self transparentImage];
            rightUrl = url;
        } else {
            leftUrl = url;
            rightUrl = [self nextFileUrl];
        }
    } else {
        if ([self getFileIndex] == 0) {
            leftUrl = url;
            rightUrl = [self transparentImage];
        } else {
            leftUrl = [self nextFileUrl];
            rightUrl = url;
        }
    }
    [self loadImageTo:self.imageView URL:leftUrl properties:&imageProperties];
    [self loadImageTo:self.rightImageView URL:rightUrl properties:&rightImageProperties];
    [self.windowController setWindowTitle:[self makeTitle:leftUrl right:rightUrl]];
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
