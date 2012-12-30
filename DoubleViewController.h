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
}


@property (assign) IKImageView *rightImageView;

- (id)initWithWindowController:(NSWindowController *)_windowController;

- (void)openImageURL: (NSURL*)url;
- (void)windowDidResize:(NSNotification *)notification;

- (IBAction)zoomActualSize: (id)sender;
- (IBAction)zoomFitToWindow: (id)sender;
- (IBAction)zoomIn: (id)sender;
- (IBAction)zoomOut: (id)sender;

@end
