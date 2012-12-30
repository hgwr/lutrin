//
//  DoubleViewController.h
//  lutrin
//
//  Created by Shigeru Hagiwara on 2012/12/30.
//
//

#import <Quartz/Quartz.h>
#import "SingleViewController.h"

@interface DoubleViewController : SingleViewController
{
    IBOutlet IKImageView *rightImageView;
    NSDictionary *rightImageProperties;
    BOOL leftToRight;
}


@property (assign) IKImageView *rightImageView;
@property (retain) NSDictionary *rightImageProperties;
@property (assign) BOOL leftToRight;


- (id)initWithWindowController:(NSWindowController *)_windowController;

- (void)openImageURL: (NSURL*)url;
- (void)windowDidResize:(NSNotification *)notification;
- (void)clearImageView;

- (IBAction)nextFile:(id)sender;
- (IBAction)prevFile:(id)sender;
- (IBAction)zoomActualSize: (id)sender;
- (IBAction)zoomFitToWindow: (id)sender;
- (IBAction)zoomIn: (id)sender;
- (IBAction)zoomOut: (id)sender;

@end
