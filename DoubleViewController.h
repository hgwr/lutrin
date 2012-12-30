//
//  DoubleViewController.h
//  lutrin
//
//  Created by Shigeru Hagiwara on 2012/12/30.
//
//

#import <Quartz/Quartz.h>
#import "ImageViewController.h"

@interface DoubleViewController : ImageViewController
{
    NSWindowController *windowController;
    IBOutlet IKImageView *leftImageView;
    IBOutlet IKImageView *rightImageView;
    NSDictionary *imageProperties;
    NSURL *currentFile;
    NSArray *fileList;
    NSURL *cacheDir;
}

@property (assign) NSWindowController *windowController;
@property (assign) IKImageView *leftImageView;
@property (assign) IKImageView *rightImageView;
@property (retain) NSDictionary *imageProperties;
@property (retain) NSURL *currentFile;
@property (retain) NSArray *fileList;
@property (retain) NSURL *cacheDir;

- (id)initWithWindowController:(NSWindowController *)_windowController;

- (IBAction)openFile: (id)sender;
- (IBAction)nextFile: (id)sender;
- (IBAction)prevFile: (id)sender;
- (IBAction)firstFile: (id)sender;
- (IBAction)lastFile: (id)sender;
- (void)openFileImpl: (NSURL*)url;
- (void)openImageURL: (NSURL*)url;
- (void)windowDidResize:(NSNotification *)notification;

- (IBAction)zoomActualSize: (id)sender;
- (IBAction)zoomFitToWindow: (id)sender;
- (IBAction)zoomIn: (id)sender;
- (IBAction)zoomOut: (id)sender;

@end
