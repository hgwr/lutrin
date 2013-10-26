//
//  SingleViewController.m
//  lutrin
//
//  Created by Shigeru Hagiwara on 2012/12/30.
//
//

#import "RegexKitLite.h"
#import "SingleViewController.h"
#import "LutrinWindowController.h"

@interface SingleViewController (Utils)

@end


@implementation SingleViewController


@synthesize windowController;
@synthesize imageView;
@synthesize imageProperties;
@synthesize currentFile;
@synthesize fileList;
@synthesize cacheDir;


- (id)initWithWindowController:(LutrinWindowController *)_windowController
                       nibName:(NSString *)nibNameOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        windowController = _windowController;
        [self setupCacheDir];
    }
    
    return self;
}


- (id)initWithWindowController:(LutrinWindowController *)_windowController
{
    return [self initWithWindowController:_windowController
                                  nibName:@"SingleViewController"];
}


- (void)dealloc
{
    [imageProperties release];
    [currentFile release];
    [fileList release];
    [cacheDir release];
    
    [super dealloc];
}


- (IBAction)openFile:(id)sender
{
    NSString *extensions =
    @"tiff/tif/TIFF/TIF/bmp/BMP/jpg/jpeg/JPG/JPEG/gif/GIF/png/PNG/zip/ZIP";
    NSArray *types = [extensions pathComponents];
    
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowedFileTypes:types];
    [openPanel setCanSelectHiddenExtension:YES];
    [openPanel beginSheetModalForWindow:self.windowController.window
                      completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            [self openFileImpl:[openPanel URL]];
        }
    }];
}


- (void)openFileImpl:(NSURL *)url
{
    NSString *ext = [url.pathExtension uppercaseString];
    if ([ext isEqualToString:@"ZIP"]) {
        [self unzipFile:[url path]];
        [self updateFileListAt:self.cacheDir recursively:YES];
        if (self.fileList.count > 0) {
            [self openImageURL:(NSURL *)[self.fileList objectAtIndex:0]];
        }
    } else {
        [self updateFileListAt:[url URLByDeletingLastPathComponent]
                   recursively:NO];
        [self openImageURL:url];
    }
}


- (void)openImageURL:(NSURL *)url
{
    self.currentFile = url;
    if (url == nil) {
        [self loadImageTo:self.imageView URL:[self transparentImage]
               properties:&imageProperties];
        [self.windowController setWindowTitle:@"no image"];
        return;
    }
    [self loadImageTo:self.imageView URL:url properties:&imageProperties];
    NSString *title = [NSString stringWithFormat:@"%@ (%ld/%ld)",
                       [url lastPathComponent],
                       ([self getFileIndex] + 1), self.fileList.count];
    [self.windowController setWindowTitle:title];
}


- (void)loadImageTo:(IKImageView *)imageView_
                URL:(NSURL *)url_
         properties:(NSDictionary **)imagePropRef_
{
    
    CGImageRef image = NULL;
    CGImageSourceRef isr = CGImageSourceCreateWithURL((CFURLRef)url_, NULL);
    
    if (isr) {
        NSDictionary *options =
        [NSDictionary dictionaryWithObject:(id)kCFBooleanTrue
                                    forKey:(id)kCGImageSourceShouldCache];
        image = CGImageSourceCreateImageAtIndex(isr, 0, (CFDictionaryRef)options);
        if (image) {
            *imagePropRef_ = (NSDictionary *)CGImageSourceCopyPropertiesAtIndex(isr, 0, (CFDictionaryRef)(*imagePropRef_));
        }
        CFRelease(isr);
    }
    
    if (image) {
        imageView_.autoresizes = YES;
        [imageView_ setImage:image imageProperties:*imagePropRef_];
        NSNumber *pixelHeight = [*imagePropRef_ valueForKey:@"PixelHeight"];
        NSNumber *pixelWidth = [*imagePropRef_ valueForKey:@"PixelWidth"];
        if (imageView_.frame.size.height < pixelHeight.floatValue ||
            imageView_.frame.size.width < pixelWidth.floatValue) {
            [imageView_ zoomImageToFit:nil];
        } else {
            [imageView_ zoomImageToActualSize:nil];
        }
        imageView_.autoresizes = NO;
        CGImageRelease(image);
    }
}


- (void)windowDidResize:(NSNotification *)notification
{
    [self.imageView zoomImageToFit:self];
}


- (void)clearImageView
{
    [self loadImageTo:self.imageView URL:[self transparentImage]
           properties:&imageProperties];
}


- (void)updateFileListAt:(NSURL *)directory recursively:(BOOL)doRecursively
{
    if (directory == nil) {
        self.fileList = [NSArray array];
        return;
    }
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *urls;
    if (doRecursively) {
        urls = [self scanURLImages:directory];
    } else {
        urls = [fm contentsOfDirectoryAtURL:directory
                 includingPropertiesForKeys:nil
                                    options:NSDirectoryEnumerationSkipsHiddenFiles
                                      error:nil];
    }
    
    NSPredicate *predicate =
    [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [[[(NSURL *)evaluatedObject pathExtension] uppercaseString]
                isMatchedByRegex:@"(TIFF|TIF|BMP|JPG|JPEG|GIF|PNG)"];
    }];
    
    self.fileList = [[urls filteredArrayUsingPredicate:predicate]
                     sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                         NSURL *a = (NSURL *)obj1;
                         NSURL *b = (NSURL *)obj2;
                         return [a.lastPathComponent compare:b.lastPathComponent];
                     }];
}


- (NSMutableArray *)scanURLImages:(NSURL *)directoryToScan
{
    NSMutableArray *urls = [NSMutableArray array];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnumerator =
    [fm enumeratorAtURL:directoryToScan
includingPropertiesForKeys:[NSArray arrayWithObjects:NSURLIsDirectoryKey,nil]
                options:NSDirectoryEnumerationSkipsHiddenFiles
           errorHandler:nil];
    
    for (NSURL *theURL in dirEnumerator) {
        NSNumber *isDirectory;
        [theURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];
        NSString *ext = [[(NSURL *)theURL pathExtension] uppercaseString];
        if ([isDirectory boolValue] == NO &&
            [ext isMatchedByRegex:@"(TIFF|TIF|BMP|JPG|JPEG|GIF|PNG)"]) {
            [urls addObject:theURL];
        }
    }
    return urls;
}


- (NSUInteger)getFileIndex
{
    NSUInteger index = [self.fileList indexOfObject:self.currentFile];
    if (index == NSNotFound) {
        NSLog(@"not found %@ in file list", self.currentFile);
        index = 0;
    }
    return index;
}


- (IBAction)nextFile: (id)sender
{
    if (self.fileList.count == 0) return;
    NSUInteger index = [self getFileIndex];
    index += 1;
    if (index >= self.fileList.count)
        index = 0;
    NSURL *url = (NSURL *)[self.fileList objectAtIndex:index];
    if (url)
        [self openImageURL:url];
}


- (IBAction)prevFile: (id)sender
{
    if (self.fileList.count == 0) return;
    NSUInteger index = [self getFileIndex];
    if (index == 0)
        index = self.fileList.count - 1;
    else
        index -= 1;
    NSURL *url = (NSURL *)[self.fileList objectAtIndex:index];
    if (url)
        [self openImageURL:url];
}


- (IBAction)firstFile: (id)sender
{
    if (self.fileList.count == 0) return;
    NSURL *url = (NSURL *)[self.fileList objectAtIndex:0];
    if (url)
        [self openImageURL:url];
}


- (IBAction)lastFile: (id)sender
{
    if (self.fileList.count == 0) return;
    NSURL *url = (NSURL *)[self.fileList objectAtIndex:(self.fileList.count - 1)];
    if (url)
        [self openImageURL:url];
}


- (IBAction)zoomActualSize: (id)sender
{
    [self.imageView zoomImageToActualSize:sender];
}


- (IBAction)zoomFitToWindow: (id)sender
{
    [self.imageView zoomImageToFit:sender];
}


- (IBAction)zoomIn: (id)sender
{
    [self.imageView zoomIn:sender];
}


- (IBAction)zoomOut: (id)sender
{
    [self.imageView zoomOut:sender];
}


- (void)setupCacheDir {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString* appBundleID = [[NSBundle mainBundle] bundleIdentifier];
    NSArray *urls = [fm URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
    self.cacheDir = [(NSURL *)[urls lastObject] URLByAppendingPathComponent:appBundleID];
    [fm createDirectoryAtPath:[self.cacheDir path] withIntermediateDirectories:YES
				   attributes:nil error:nil];
}


- (void)unzipFile:(NSString *)path
{
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtURL:self.cacheDir error:nil];
    [fm createDirectoryAtPath:[self.cacheDir path] withIntermediateDirectories:YES
                   attributes:nil error:nil];
    
    NSArray *arguments = [NSArray arrayWithObject:path];
    
    NSTask *unzipTask = [[NSTask alloc] init];
    [unzipTask setLaunchPath:@"/usr/bin/unzip"];
    [unzipTask setCurrentDirectoryPath:[self.cacheDir path]];
    [unzipTask setArguments:arguments];
    [unzipTask launch];
    [unzipTask waitUntilExit];
    int status = [unzipTask terminationStatus];
    [unzipTask release];
    
    if (status != 0)
        NSLog(@"unzip %@ failed.", path);
}


- (NSURL *)transparentImage
{
    return [[NSBundle mainBundle] URLForResource:@"transparent1x1" withExtension:@"png"];
}

@end
