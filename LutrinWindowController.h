//
//  LutrinWindowController.h
//  lutrin
//
//  Created by Shigeru Hagiwara on 2012/12/20.
//
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@class IKImageView;

@interface LutrinWindowController : NSWindowController
{
    IBOutlet IKImageView *imageView;
}

@end
