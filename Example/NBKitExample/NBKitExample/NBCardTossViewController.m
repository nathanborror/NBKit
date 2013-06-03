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
static const CGFloat kButtonHeight = 44;
static const CGFloat kButtonMargin = 20;
static const CGFloat kCardWidth = 200;
static const CGFloat kCardHeight = 200;

@interface NBCardTossViewController ()
{
  UIView *card;

  CGPoint startPoint;
  CGPoint endPoint;
}
@end

@implementation NBCardTossViewController

- (id)init
{
  self = [super init];
  if (self) {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationItem setTitle:@"Card Toss"];
  }
  return self;
}

- (void)viewDidLoad
{
  UIButton *show = [[UIButton alloc] initWithFrame:CGRectMake(kButtonMargin, CGRectGetHeight(self.view.frame)-(kButtonHeight+kButtonMargin), (CGRectGetWidth(self.view.frame)/2)-kButtonMargin-(kButtonMargin/2), kButtonHeight)];
  [show addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
  [show setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
  [show setTitle:@"Show" forState:UIControlStateNormal];
  [show setBackgroundColor:[UIColor colorWithRed:.21 green:.51 blue:.89 alpha:1]];
  [show.layer setCornerRadius:4];
  [self.view addSubview:show];

  UIButton *hide = [[UIButton alloc] initWithFrame:CGRectOffset(show.bounds, CGRectGetMaxX(show.frame)+kButtonMargin, CGRectGetMinY(show.frame))];
  [hide addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
  [hide setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
  [hide setTitle:@"Hide" forState:UIControlStateNormal];
  [hide setBackgroundColor:[UIColor colorWithRed:.21 green:.51 blue:.89 alpha:1]];
  [hide.layer setCornerRadius:4];
  [self.view addSubview:hide];

  card = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)/2)-(kCardWidth/2), kCardWidth/2, kCardWidth, kCardHeight)];
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
  [NBAnimationHelper animatePosition:card from:startPoint to:endPoint forKey:@"position" delegate:nil];
  [NBAnimationHelper animateTransform:card
                                 from:CATransform3DRotate(card.layer.transform, radians(20), 0, 0, 1)
                                   to:card.layer.transform
                               forKey:@"rotate" delegate:nil];
}

- (void)hide
{
  [NBAnimationHelper animatePosition:card from:endPoint to:CGPointMake(endPoint.x, endPoint.y+450) forKey:@"position" delegate:self];
}

#pragma mark - CAAnimation

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
  [card setCenter:startPoint];
}

@end
