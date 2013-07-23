//
//  UIImage+LoadAsync.m
//  NBKit
//
//  Created by Nathan Borror on 7/17/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import "UIImage+LoadAsync.h"

@implementation UIImage (LoadAsync)

+ (void)loadAsync:(NSURL *)url completion:(void (^)(UIImage *))completion
{
  dispatch_queue_t downloadQueue = dispatch_queue_create("com.feed.loadimagequeue", nil);
  dispatch_async(downloadQueue, ^{
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    dispatch_async(dispatch_get_main_queue(), ^{
      completion([UIImage imageWithData:imageData]);
    });
  });
}

@end
