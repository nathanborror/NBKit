//
//  NBCell.m
//  NBKitExample
//
//  Created by Nathan Borror on 10/12/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import "NBCell.h"

@implementation NBCell

- (id)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    [_label setText:@"test"];
    [_label setTextColor:[UIColor blackColor]];
    [_label setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:_label];
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  [self setBackgroundColor:[UIColor whiteColor]];

  [_label setFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
}

- (void)setHighlighted:(BOOL)highlighted
{
  [super setHighlighted:highlighted];
  if (highlighted) {
    self.alpha = 0.5;
  }
  else {
    self.alpha = 1;
  }
}

@end
