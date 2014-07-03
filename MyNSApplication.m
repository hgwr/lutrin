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
        // キーイベントを書き換えます。
        // スペースキー → 右矢印キー
        // j → 右矢印キー
        // k → 左矢印キー
        const unichar right[1] = { NSRightArrowFunctionKey };
        const unichar left[1] = { NSLeftArrowFunctionKey };
        NSString *rightChars = [NSString stringWithCharacters:right length:1];
        NSString *leftChars = [NSString stringWithCharacters:left length:1];

        if( [[event charactersIgnoringModifiers] isEqualToString:@" "] ||
            [[event charactersIgnoringModifiers] isEqualToString:@"j"] ) {
            event = [NSEvent keyEventWithType:[event type]
                                     location:[event locationInWindow]
                                modifierFlags:[event modifierFlags]
                                    timestamp:[event timestamp]
                                 windowNumber:[event windowNumber]
                                      context:[event context]
                                   characters:rightChars
                  charactersIgnoringModifiers:rightChars
                                    isARepeat:[event isARepeat]
                                      keyCode:124 // Right key
                     ];
        } else if( [[event charactersIgnoringModifiers] isEqualToString:@"k"] ) {
            event = [NSEvent keyEventWithType:[event type]
                                     location:[event locationInWindow]
                                modifierFlags:[event modifierFlags]
                                    timestamp:[event timestamp]
                                 windowNumber:[event windowNumber]
                                      context:[event context]
                                   characters:leftChars
                  charactersIgnoringModifiers:leftChars
                                    isARepeat:[event isARepeat]
                                      keyCode:123 // Left key
                     ];
        }
    }
    
    [super sendEvent:event];
}

@end
