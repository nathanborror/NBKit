//
//  NBBlock.m
//  NBKitExample
//
//  Created by Nathan Borror on 8/11/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import "NBBlock.h"

#define INACTIVE [UIColor colorWithRed:.11 green:.67 blue:.84 alpha:1]
#define ACTIVE [UIColor colorWithRed:.17 green:.57 blue:.79 alpha:1]

static const CGFloat kShrinkAmount = 3;
static const CGFloat kShrinkDuration = .3;

@implementation NBBlock

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self setBackgroundColor:INACTIVE];
  }
  return self;
}

- (void)activate
{
  [UIView animateWithDuration:kShrinkDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    CGFloat x = CGRectGetMinX(self.frame)+kShrinkAmount;
    CGFloat y = CGRectGetMinY(self.frame)+kShrinkAmount;
    CGFloat w = CGRectGetWidth(self.frame)-(kShrinkAmount*2);
    CGFloat h = CGRectGetHeight(self.frame)-(kShrinkAmount*2);

    [self setFrame:CGRectMake(x, y, w, h)];
    [self setBackgroundColor:ACTIVE];
  } completion:nil];
}

- (void)inactivate
{
  [UIView animateWithDuration:kShrinkDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    CGFloat x = CGRectGetMinX(self.frame)-kShrinkAmount;
    CGFloat y = CGRectGetMinY(self.frame)-kShrinkAmount;
    CGFloat w = CGRectGetWidth(self.frame)+(kShrinkAmount*2);
    CGFloat h = CGRectGetHeight(self.frame)+(kShrinkAmount*2);

    [self setFrame:CGRectMake(x, y, w, h)];
    [self setBackgroundColor:INACTIVE];
  } completion:nil];
}

#pragma mark - TouchEvents

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self activate];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self inactivate];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self inactivate];
}

@end
