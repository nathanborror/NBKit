//
//  NBGridViewController.m
//  NBKitExample
//
//  Created by Nathan Borror on 8/11/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import "NBGridViewController.h"
#import "NBBlock.h"

static const NSInteger kBlockCount = 28;
static const NSInteger kBlockAcross = 4;
static const CGFloat kBlockWidth = 80;
static const CGFloat kBlockHeight = kBlockWidth;
static const CGFloat kBlockMargin = .5;

@implementation NBGridViewController {
  NSMutableArray *blocks;
}

- (id)init
{
  if (self = [super init]) {
    blocks = [[NSMutableArray alloc] init];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self.view setBackgroundColor:[UIColor blackColor]];
  [self.navigationItem setTitle:@"Grid of Blocks"];

  NSInteger current = 0;
  NSInteger currentRow = 1;

  while (current < kBlockCount) {

    NBBlock *lastBlock;
    if (blocks.count > 0) {
      lastBlock = [blocks objectAtIndex:current-1];
    }

    CGFloat x = 0;
    CGFloat y = 0;

    if (lastBlock) {
      if (currentRow < kBlockAcross) {
        x = CGRectGetMaxX(lastBlock.frame) + kBlockMargin;
        y = CGRectGetMinY(lastBlock.frame);
        currentRow++;
      } else {
        x = 0;
        y = CGRectGetMaxY(lastBlock.frame) + kBlockMargin;
        currentRow = 1;
      }
    }

    NBBlock *block = [[NBBlock alloc] initWithFrame:CGRectMake(x, y, kBlockWidth, kBlockHeight)];
    [self.view addSubview:block];

    [blocks addObject:block];
    current++;
  }
}

#pragma mark - UIPanGestureRecognizer

- (void)pan:(UIPanGestureRecognizer *)gestureRecognizer
{
  
}

@end
