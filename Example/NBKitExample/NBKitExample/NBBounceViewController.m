//
//  NBBounceViewController.m
//  NBKitExample
//
//  Created by Nathan Borror on 5/28/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import "NBBounceViewController.h"
#import "NBAnimationHelper.h"

@interface NBBounceViewController ()
{
  UIButton *ball;

  CGPoint startPoint;
  CGPoint endPoint;
}
@end

@implementation NBBounceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    [self.view setBackgroundColor:[UIColor whiteColor]];

    ball = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.bounds)/2)-25, 20, 50, 50)];
    [ball addTarget:self action:@selector(drop) forControlEvents:UIControlEventTouchUpInside];
    [ball setBackgroundColor:[UIColor grayColor]];
    [ball.layer setCornerRadius:25];
    [self.view addSubview:ball];

    startPoint = ball.center;
    endPoint = CGPointMake(ball.center.x, CGRectGetHeight(self.view.bounds)-100);
  }
  return self;
}

- (void)drop
{
  if (ball.center.y < endPoint.y) {
    [NBAnimationHelper animatePosition:ball from:startPoint to:endPoint forKey:@"bounce" delegate:nil];
  } else {
    [NBAnimationHelper animatePosition:ball from:endPoint to:startPoint forKey:@"bounce" delegate:nil];
  }
}

@end
