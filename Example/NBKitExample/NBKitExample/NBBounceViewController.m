//
//  NBBounceViewController.m
//  NBKitExample
//
//  Created by Nathan Borror on 5/28/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import "NBBounceViewController.h"
#import "NBAnimationHelper.h"

static const CGFloat kBallWidth = 50;
static const CGFloat kBallHeight = kBallWidth;

@interface NBBounceViewController ()
{
  UIButton *ball;
}
@end

@implementation NBBounceViewController

- (id)init
{
  self = [super init];
  if (self) {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationItem setTitle:@"Bounce"];
  }
  return self;
}

- (void)viewDidLoad
{
  ball = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)/2)-(kBallWidth/2), kBallHeight/2, kBallWidth, kBallHeight)];
  [ball setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
  [ball addTarget:self action:@selector(drop) forControlEvents:UIControlEventTouchUpInside];
  [ball setBackgroundColor:[UIColor colorWithRed:.21 green:.51 blue:.89 alpha:1]];
  [ball.layer setCornerRadius:25];
  [self.view addSubview:ball];
}

- (void)drop
{
  if (ball.center.y < CGRectGetHeight(self.view.frame)/2) {
    CGPoint endPoint = CGPointMake(ball.center.x, CGRectGetHeight(self.view.frame)-kBallHeight);
    [NBAnimationHelper animatePosition:ball from:ball.center to:endPoint forKey:@"bounce" delegate:nil];
  } else {
    CGPoint endPoint = CGPointMake(ball.center.x, kBallHeight);
    [NBAnimationHelper animatePosition:ball from:ball.center to:endPoint forKey:@"bounce" delegate:nil];
  }
}

@end
