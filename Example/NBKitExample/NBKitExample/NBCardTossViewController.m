//
//  NBCardTossViewController.m
//  NBKitExample
//
//  Created by Nathan Borror on 5/28/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import "NBCardTossViewController.h"
#import "NBAnimationHelper.h"

static inline double radians(double degrees) {return degrees * M_PI / 180;}

@interface NBCardTossViewController ()
{
  UIView *card;

  CGPoint startPoint;
  CGPoint endPoint;
}
@end

@implementation NBCardTossViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    [self.view setBackgroundColor:[UIColor whiteColor]];
  }
  return self;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

  UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetHeight(self.view.bounds)-64, CGRectGetWidth(self.view.bounds)-40, 44)];
  [button addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
  [button setTitle:@"Show" forState:UIControlStateNormal];
  [button setBackgroundColor:[UIColor colorWithWhite:.8 alpha:1]];
  [button.layer setCornerRadius:4];
  [self.view addSubview:button];

  card = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.bounds)/2)-100, 100, 200, 200)];
  [card setBackgroundColor:[UIColor whiteColor]];
  [card.layer setCornerRadius:4];
  [card.layer setShadowColor:[UIColor blackColor].CGColor];
  [card.layer setShadowOffset:CGSizeMake(0, 4)];
  [card.layer setShadowOpacity:.4];
  [card.layer setShadowRadius:8];
  [card.layer setBorderColor:[UIColor colorWithWhite:.65 alpha:1].CGColor];
  [card.layer setBorderWidth:.5];
  [self.view addSubview:card];

  startPoint = CGPointMake(card.center.x, -140);
  endPoint = card.center;

  [card setCenter:startPoint];
}

- (void)show
{
  if (card.center.y < endPoint.y) {
    [NBAnimationHelper animatePosition:card from:startPoint to:endPoint forKey:@"position" delegate:nil];
    [NBAnimationHelper animateTransform:card
                                   from:CATransform3DRotate(card.layer.transform, radians(20), 0, 0, 1)
                                     to:card.layer.transform
                                 forKey:@"rotate" delegate:nil];
  } else {
    [NBAnimationHelper animatePosition:card from:endPoint to:CGPointMake(endPoint.x, endPoint.y+450) forKey:@"position" delegate:self];
  }
}

#pragma mark - CAAnimation

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
  [card setCenter:startPoint];
}

@end
