//
//  LutrinWindowController.m
//  lutrin
//
//  Created by Shigeru Hagiwara on 2012/12/20.
//
//

#import <AppKit/AppKit.h>
#import "RegexKitLite.h"
#import "LutrinWindowController.h"


@interface LutrinWindowController (Utils)

- (void)updateFileListAt:(NSURL *)directory;

@end


@implementation LutrinWindowController


@synthesize imageView;
@synthesize imageProperties;
@synthesize currentFile;
@synthesize fileList;


- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


- (void)dealloc
{
    [imageProperties release];
    [fileList release];
    
    [super dealloc];
}


- (IBAction)openFile:(id)sender
{
    NSString *extensions =
        @"tiff/tif/TIFF/TIF/jpg/jpeg/JPG/JPEG"
        @"/gif/GIF/png/PNG"
        @"/zip/ZIP/rar/RAR";
    NSArray *types = [extensions pathComponents];
    
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowedFileTypes:types];
    [openPanel setCanSelectHiddenExtension:YES];
    [openPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            NSURL *url = [openPanel URL];
            NSString *ext = [url.pathExtension uppercaseString];
            if ([ext isEqualToString:@"ZIP"] || [ext isEqualToString:@"RAR"]) {
                // TODO open zip or rar file
                NSLog(@"TODO: open zip/rar file");
            } else {
                self.currentFile = url;
                NSLog(@"currentFile = %@", url);
                [self openImageURL:url];
                [self updateFileListAt:[url URLByDeletingLastPathComponent]];
            }
        }
    }];
}


- (void)openImageURL:(NSURL*)url
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
            self.imageProperties = (NSDictionary *)CGImageSourceCopyPropertiesAtIndex(isr, 0, (CFDictionaryRef)imageProperties);
        }
        CFRelease(isr);
    }
    
    if (image) {
        [imageView setImage:image imageProperties:imageProperties];
        CGImageRelease(image);
        [imageView zoomImageToFit:self];
        [self.window setTitleWithRepresentedFilename:[url path]];
    }
}


- (void)windowDidResize:(NSNotification *)notification
{
    [imageView zoomImageToFit:self];
}


- (void)updateFileListAt:(NSURL *)directory {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *urls =
        [fm contentsOfDirectoryAtURL:directory
          includingPropertiesForKeys:nil
                             options:NSDirectoryEnumerationSkipsHiddenFiles
                               error:nil];
    NSPredicate *predicate =
    [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [[[(NSURL *)evaluatedObject pathExtension] uppercaseString]
                isMatchedByRegex:@"(TIFF|TIF|JPG|JPEG|GIF|PNG)"];
    }];
    self.fileList = [[urls filteredArrayUsingPredicate:predicate]
                     sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                         NSURL *a = (NSURL *)obj1;
                         NSURL *b = (NSURL *)obj2;
                         return [a.lastPathComponent compare:b.lastPathComponent];
                     }];
    NSLog(@"fileList = %@", self.fileList);
}


@end