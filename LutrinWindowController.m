//
//  LutrinWindowController.m
//  lutrin
//
//  Created by Shigeru Hagiwara on 2012/12/20.
//
//

#import <AppKit/AppKit.h>
#import "LutrinWindowController.h"


@interface LutrinWindowController ()


@end


@implementation LutrinWindowController


- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


- (IBAction)openFile:(id)sender
{
    NSString *extensions =
        @"tiff/tif/TIFF/TIF/jpg/jpeg/JPG/JPEG"
        @"/gif/GIF/bmp/BMP/png/PNG"
        @"/zip/ZIP/rar/RAR";
    NSArray *types = [extensions pathComponents];
    
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowedFileTypes:types];
    [openPanel setCanSelectHiddenExtension:YES];
    [openPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            [self openImageURL: [openPanel URL]];
        }
    }];
}


- (void)openImageURL: (NSURL*)url
{
    // use ImageIO to get the CGImage, image properties, and the image-UTType
    //
    CGImageRef image = NULL;
    CGImageSourceRef isr = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    
    if (isr) {
        NSDictionary *options =
            [NSDictionary dictionaryWithObject:(id)kCFBooleanTrue
                                        forKey:(id)kCGImageSourceShouldCache];
        image = CGImageSourceCreateImageAtIndex(isr, 0, (CFDictionaryRef)options);
        if (image) {
            imageProperties = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(isr, 0, (CFDictionaryRef)imageProperties));
            imageUTType = (NSString *)CGImageSourceGetType(isr);
        }
        CFRelease(isr);
    }
    
    if (image) {
        [imageView setImage:image imageProperties:imageProperties];
        CGImageRelease(image);
        [self.window setTitleWithRepresentedFilename:[url path]];
    }
}

@end
