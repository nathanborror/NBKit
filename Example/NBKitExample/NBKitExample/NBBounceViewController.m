//
//  NBBounceViewController.m
//  NBKitExample
//
//  Created by Nathan Borror on 5/28/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import "NBBounceViewController.h"
#import "NBAnimationHelper.h"

static const CGFloat kBallSize = 50.0;

@interface NBBounceViewController ()
{
  UIButton *ball;
  NSTimer *timer;
}
@end

@implementation NBBounceViewController

- (id)init
{
  self = [super init];
  if (self) {
    [self.navigationItem setTitle:@"Bounce"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setEdgesForExtendedLayout:UIExtendedEdgeNone];
  }
  return self;
}

- (void)viewDidLoad
{
  ball = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)/2)-(kBallSize/2), kBallSize/2, kBallSize, kBallSize)];
  [ball setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
  [ball addTarget:self action:@selector(bounce) forControlEvents:UIControlEventTouchUpInside];
  [ball setBackgroundColor:[UIColor redColor]];
  [ball.layer setCornerRadius:kBallSize/2];
  [self.view addSubview:ball];
}

- (void)viewDidAppear:(BOOL)animated
{
  timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(bounce) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
  [timer invalidate];
}

- (void)bounce
{
  if (ball.center.y < CGRectGetHeight(self.view.frame)/2) {
    CGPoint endPoint = CGPointMake(ball.center.x, CGRectGetHeight(self.view.frame)-kBallSize);
    [NBAnimationHelper animatePosition:ball from:ball.center to:endPoint forKey:@"bounce" delegate:nil];
  } else {
    CGPoint endPoint = CGPointMake(ball.center.x, kBallSize);
    [NBAnimationHelper animatePosition:ball from:ball.center to:endPoint forKey:@"bounce" delegate:nil];
  }
}

@end
