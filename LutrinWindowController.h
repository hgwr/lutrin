//
//  LutrinWindowController.h
//  lutrin
//
//  Created by Shigeru Hagiwara on 2012/12/20.
//
//

#import <Cocoa/Cocoa.h>

@class SingleViewController;
@class DoubleViewController;

@interface LutrinWindowController : NSWindowController <NSWindowDelegate>
{
    IBOutlet NSBox *box;
    IBOutlet NSMenuItem *singleMenuItem;
    IBOutlet NSMenuItem *leftToRightMenuItem;
    IBOutlet NSMenuItem *rightToLeftMenuItem;
    SingleViewController *singleViewController;
    DoubleViewController *doubleViewController;
    SingleViewController *currentViewController;
}

@property (assign) NSBox *box;
@property (assign) NSMenuItem *singleMenuItem;
@property (assign) NSMenuItem *leftToRightMenuItem;
@property (assign) NSMenuItem *rightToLeftMenuItem;
@property (retain) SingleViewController *singleViewController;
@property (retain) DoubleViewController *doubleViewController;

- (void)openFileImpl:(NSURL*)url;

- (IBAction)displaySingleViewController:(id)sender;
- (IBAction)displayDoubleViewLeftToRight:(id)sender;
- (IBAction)displayDoubleViewRightToLeft:(id)sender;

- (IBAction)openFile:(id)sender;
- (IBAction)nextFile:(id)sender;
- (IBAction)prevFile:(id)sender;
- (IBAction)firstFile:(id)sender;
- (IBAction)lastFile:(id)sender;

- (IBAction)zoomActualSize:(id)sender;
- (IBAction)zoomFitToWindow:(id)sender;
- (IBAction)zoomIn:(id)sender;
- (IBAction)zoomOut:(id)sender;

@end
