//
//  UIImage+LoadAsync.h
//  NBKit
//
//  Created by Nathan Borror on 7/17/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

@import UIKit;
@import QuartzCore;

@interface UIImage (LoadAsync)

+ (void)loadAsync:(NSURL *)url completion:(void (^)(UIImage *image))completion;

@end
