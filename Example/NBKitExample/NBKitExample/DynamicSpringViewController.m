//
//  DynamicSpringViewController.m
//  NBKitExample
//
//  Created by Nathan Borror on 7/23/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import "DynamicSpringViewController.h"

static const CGFloat kBallSize = 50.0;
static const CGFloat kBallTopMargin = 90.0;
static const CGFloat kInitialVelocity = .2;
static const CGFloat kInitialDamping = .6;

@interface DynamicSpringViewController ()
{
  UIButton *ball;
  UISlider *velocity;
  UISlider *damping;
  UILabel *dampingValue;
  UILabel *velocityValue;
  NSTimer *timer;
}
@end

@implementation DynamicSpringViewController

- (id)init
{
  if (self = [super init]) {
    [self setTitle:@"Spring Animation"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  ball = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.bounds)/2)-(kBallSize/2), kBallTopMargin, kBallSize, kBallSize)];
  [ball setBackgroundColor:[UIColor redColor]];
  [ball.layer setCornerRadius:kBallSize/2];
  [ball addTarget:self action:@selector(bounce) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:ball];

  // Sliders
  damping = [[UISlider alloc] initWithFrame:CGRectMake(20, CGRectGetHeight(self.view.frame)-70, CGRectGetWidth(self.view.bounds)-40, 50)];
  [damping setMaximumValue:1];
  [damping setMinimumValue:0];
  [damping setValue:kInitialDamping animated:YES];
  [damping addTarget:self action:@selector(dampingChange) forControlEvents:UIControlEventValueChanged];
  [self.view addSubview:damping];

  velocity = [[UISlider alloc] initWithFrame:CGRectMake(20, CGRectGetMinY(damping.frame)-50, CGRectGetWidth(self.view.bounds)-40, 50)];
  [velocity setMaximumValue:1];
  [velocity setMinimumValue:0];
  [velocity setValue:kInitialVelocity animated:YES];
  [velocity addTarget:self action:@selector(velocityChange) forControlEvents:UIControlEventValueChanged];
  [self.view addSubview:velocity];

  // Labels
  dampingValue = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 100, 50)];
  [dampingValue setText:[NSString stringWithFormat:@"D: %.2f", damping.value]];
  [dampingValue setTextColor:[UIColor grayColor]];
  [self.view addSubview:dampingValue];

  velocityValue = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, 100, 50)];
  [velocityValue setText:[NSString stringWithFormat:@"V: %.2f", velocity.value]];
  [velocityValue setTextColor:[UIColor grayColor]];
  [self.view addSubview:velocityValue];
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
  [UIView animateWithDuration:.9 delay:0 usingSpringWithDamping:damping.value initialSpringVelocity:velocity.value options:UIViewAnimationOptionCurveLinear animations:^{
    if (CGRectGetMaxY(ball.frame) > 150) {
      [ball setFrame:CGRectOffset(ball.bounds, (CGRectGetWidth(self.view.bounds)/2)-(kBallSize/2), kBallTopMargin)];
    } else {
      [ball setFrame:CGRectOffset(ball.bounds, (CGRectGetWidth(self.view.bounds)/2)-(kBallSize/2), 300)];
    }
  } completion:nil];
}

- (void)dampingChange
{
  [dampingValue setText:[NSString stringWithFormat:@"D: %.2f", damping.value]];
}

- (void)velocityChange
{
  [velocityValue setText:[NSString stringWithFormat:@"V: %.2f", velocity.value]];
}

@end
