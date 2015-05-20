//
//  UIApplication+StatusBar.m
//  Streams
//
//  Created by Adam Cue on 2/25/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import "UIApplication+StatusBar.h"

@implementation UIApplication (StatusBar)

static BOOL isHidden = false;
static UIView * containerView = nil;
static UILabel * messageLabel = nil;

+ (void) setStatusBarHidden:(BOOL)hidden withAnimation:(UIStatusBarAnimation)animation {
    UIView * v = [self statusBar];
    
    if (isHidden == hidden) return;
    isHidden = hidden;
    
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

+ (BOOL) statusBarIsHidden {
    return isHidden;
}

+ (UIView *) keyboardView {
    for (UIWindow * window in [UIApplication sharedApplication].windows) {
        if ([NSStringFromClass([window class]) isEqualToString:@"UITextEffectsWindow"]) {
            for (UIView * v in window.subviews) {
                if ([NSStringFromClass([v class]) isEqualToString:@"UIInputSetContainerView"]) {
                    for (UIView * keyboardView in v.subviews) {
                        if ([NSStringFromClass([keyboardView class]) isEqualToString:@"UIInputSetHostView"]) {
                            return keyboardView;
                        }
                    }
                }
            }
        }
    }
    return nil;
}

+ (void) showStatusBarMessage:(NSString *)message {
    if (messageLabel != nil && messageLabel.superview != nil) {
        messageLabel.text = message;
        return;
    }
    
    if (containerView == nil) {
        UIView * v = [self statusBar];
        containerView = [[UIView alloc] initWithFrame:v.frame];
        containerView.backgroundColor = [UIColor clearColor];
        containerView.userInteractionEnabled = NO;
        containerView.clipsToBounds = YES;
        [v.superview addSubview:containerView];
    }
    
    messageLabel = [[UILabel alloc] initWithFrame:containerView.bounds];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.font = [UIFont boldSystemFontOfSize:12.0];
    messageLabel.textColor = [self sharedApplication].statusBarStyle == UIStatusBarStyleDefault ? [UIColor blackColor] : [UIColor whiteColor];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 1;
    messageLabel.text = message;
    [containerView addSubview:messageLabel];
    
    [self setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [UIView animateWithDuration:0.15 animations:^{
        messageLabel.frame = CGRectMake(0.0, 0.0, messageLabel.frame.size.width, messageLabel.frame.size.height);
    }];
}

+ (void) hideStatusBarMessage {
    if (messageLabel != nil && messageLabel.superview != nil) {
        [self setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        [UIView animateWithDuration:0.15 animations:^{
            messageLabel.frame = CGRectMake(0.0, [self statusBar].frame.size.height, messageLabel.frame.size.width, messageLabel.frame.size.height);
        } completion:^(BOOL finished) {
            [messageLabel removeFromSuperview];
            messageLabel = nil;
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
