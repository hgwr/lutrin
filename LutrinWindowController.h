//
//  LutrinWindowController.h
//  lutrin
//
//  Created by Shigeru Hagiwara on 2012/12/20.
//
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@class IKImageView;

@interface LutrinWindowController : NSWindowController <NSWindowDelegate>
{
    IBOutlet IKImageView *imageView;
    NSDictionary *imageProperties;
    NSURL *currentFile;
    NSArray *fileList;
}

@property (assign) IKImageView *imageView;
@property (retain) NSDictionary *imageProperties;
@property (retain) NSURL *currentFile;
@property (retain) NSArray *fileList;


- (IBAction)openFile: (id)sender;
- (void)openImageURL: (NSURL*)url;
- (void)windowDidResize:(NSNotification *)notification;

@end
