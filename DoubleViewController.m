//
//  DoubleViewController.m
//  lutrin
//
//  Created by Shigeru Hagiwara on 2012/12/30.
//
//

#import "DoubleViewController.h"

@interface DoubleViewController ()

@end

@implementation DoubleViewController

@synthesize windowController;
@synthesize leftImageView;
@synthesize rightImageView;
@synthesize imageProperties;
@synthesize currentFile;
@synthesize fileList;
@synthesize cacheDir;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
