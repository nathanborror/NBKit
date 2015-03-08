//
//  UIApplication+StatusBar.h
//  Streams
//
//  Created by Adam Cue on 2/25/15.
//  Copyright (c) 2015 Dropbox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (StatusBar)

+ (void) setStatusBarHidden:(BOOL)hidden withAnimation:(UIStatusBarAnimation)animation;

@end
