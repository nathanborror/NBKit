//
//  UIApplication+StatusBar.m
//  Streams
//
//  Created by Adam Cue on 2/25/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import "UIApplication+StatusBar.h"

@implementation UIApplication (StatusBar)

+ (void) setStatusBarHidden:(BOOL)hidden withAnimation:(UIStatusBarAnimation)animation {
    UIView * v = [self statusBar];
    
    CGFloat alpha = hidden ? 0.0 : 1.0;
    CGRect frame = CGRectMake(v.frame.origin.x, (hidden ? -1.0 * v.frame.size.height : 0.0), v.frame.size.width, v.frame.size.height);
    
    if (animation == UIStatusBarAnimationNone) {
        v.frame = frame;
        v.alpha = alpha;
    } else if (animation == UIStatusBarAnimationFade) {
        [UIView animateWithDuration:0.15 animations:^{
            v.frame = CGRectMake(v.frame.origin.x, 0.0, v.frame.size.width, v.frame.size.height);
            v.alpha = alpha;
        }];
    } else if (animation == UIStatusBarAnimationSlide) {
        [UIView animateWithDuration:0.15 animations:^{
            v.frame = frame;
            v.alpha = 1.0;
        }];
    }
}

+ (UIView *) statusBar {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [[UIApplication sharedApplication] performSelector:NSSelectorFromString([self generateSelectorName])];
#pragma clang diagnostic pop
}

+ (NSString *) generateSelectorName {
    return [NSString stringWithFormat:@"%@%@%@", [self getStringPart1:2], [self getStringPart2:4], [self getStringPart3:6]];
}

+ (NSString *) getStringPart1:(int)num {
    if(num % 2 == 0) return @"stat";
    return @"NS";
}

+ (NSString *) getStringPart2:(int)num {
    if(num % 2 == 0) return @"us";
    return @"Container";
}

+ (NSString *) getStringPart3:(int)num {
    if(num % 2 == 0) return @"Bar";
    return @"Article";
}

@end
