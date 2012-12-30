//
//  ManagingViewController.m
//  lutrin
//
//  Created by Shigeru Hagiwara on 2012/12/30.
//
//

#import "ManagingViewController.h"

@interface ManagingViewController ()

@end

@implementation ManagingViewController

@synthesize managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [managedObjectContext release];
    [super dealloc];
}

@end
