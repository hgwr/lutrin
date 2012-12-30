//
//  SingleViewController.m
//  lutrin
//
//  Created by Shigeru Hagiwara on 2012/12/30.
//
//

#import "RegexKitLite.h"
#import "SingleViewController.h"

@interface SingleViewController (Utils)

- (void)updateFileListAt:(NSURL *)directory recursively:(BOOL)doRecursively;
- (NSUInteger)getFileIndex;
- (void)setupCacheDir;
- (void)unzipFile:(NSString *)path;
- (NSMutableArray *)scanURLImages:(NSURL *)directoryToScan;

@end

@implementation SingleViewController

@synthesize windowController;
@synthesize imageView;
@synthesize imageProperties;
@synthesize currentFile;
@synthesize fileList;
@synthesize cacheDir;

- (id)initWithWindowController:(NSWindowController *)_windowController
{
    self = [super initWithNibName:@"SingleViewController" bundle:nil];
    if (self) {
        windowController = _windowController;
        [self setupCacheDir];
    }

    return self;
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
    @"tiff/tif/TIFF/TIF/jpg/jpeg/JPG/JPEG/gif/GIF/png/PNG/zip/ZIP";
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
        [self openImageURL:url];
        [self updateFileListAt:[url URLByDeletingLastPathComponent]
                   recursively:NO];
    }
}


- (void)openImageURL:(NSURL*)url
{
    self.currentFile = url;
    
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
        self.imageView.autoresizes = YES;
        [self.imageView setImage:image imageProperties:imageProperties];
        self.imageView.autoresizes = NO;
        CGImageRelease(image);
        [self.windowController.window setTitleWithRepresentedFilename:[url path]];
    }
}


- (void)windowDidResize:(NSNotification *)notification
{
    [self.imageView zoomImageToFit:self];
}


- (void)updateFileListAt:(NSURL *)directory recursively:(BOOL)doRecursively
{
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
                isMatchedByRegex:@"(TIFF|TIF|JPG|JPEG|GIF|PNG)"];
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
            [ext isMatchedByRegex:@"(TIFF|TIF|JPG|JPEG|GIF|PNG)"]) {
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
    NSURL *url = (NSURL *)[self.fileList objectAtIndex:0];
    if (url)
        [self openImageURL:url];
}


- (IBAction)lastFile: (id)sender
{
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

@end
