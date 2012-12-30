//
//  LutrinWindowController.h
//  lutrin
//
//  Created by Shigeru Hagiwara on 2012/12/20.
//
//

#import <Cocoa/Cocoa.h>

@class SingleViewController;

@interface LutrinWindowController : NSWindowController <NSWindowDelegate>
{
    IBOutlet NSBox *box;
    SingleViewController *singleViewController;
}

@property (assign) NSBox *box;
@property (retain) SingleViewController *singleViewController;

- (void)displaySingleViewController;

- (IBAction)openFile: (id)sender;
- (IBAction)nextFile: (id)sender;
- (IBAction)prevFile: (id)sender;
- (IBAction)firstFile: (id)sender;
- (IBAction)lastFile: (id)sender;

- (IBAction)zoomActualSize: (id)sender;
- (IBAction)zoomFitToWindow: (id)sender;
- (IBAction)zoomIn: (id)sender;
- (IBAction)zoomOut: (id)sender;

@end
