//
//  MyNSApplication.m
//  Lutrin
//
//  Created by Shigeru Hagiwara on 2014/06/29.
//
//

#import "MyNSApplication.h"

@implementation MyNSApplication

- (void)sendEvent:(NSEvent *) event
{
    if ([event type] == NSKeyDown) {
        // スペースキーのイベントを、右矢印キーイベントに置き換えます。
        if( [[event charactersIgnoringModifiers] isEqualToString:@" "] ) {
            const unichar right[1] = { NSRightArrowFunctionKey };
            NSString *characters = [NSString stringWithCharacters:right length:1];
            event = [NSEvent keyEventWithType:[event type]
                                     location:[event locationInWindow]
                                modifierFlags:[event modifierFlags]
                                    timestamp:[event timestamp]
                                 windowNumber:[event windowNumber]
                                      context:[event context]
                                   characters:characters
                  charactersIgnoringModifiers:characters
                                    isARepeat:[event isARepeat]
                                      keyCode:124 // Right key
                     ];
        }
    }
    
    [super sendEvent:event];
}

@end
