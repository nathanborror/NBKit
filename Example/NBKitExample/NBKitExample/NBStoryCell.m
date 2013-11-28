//
//  NBStoryCell.m
//  NBKitExample
//
//  Created by Nathan Borror on 11/28/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import "NBStoryCell.h"

static const CGFloat kStoryFontSize = 14;
static const CGFloat kStoryMargin = 16;
static const CGFloat kStoryWidth = 320 - (kStoryMargin*2);

CGRect CGRectForText(NSString *text, UIFont *font) {
  NSDictionary *attrs = @{NSFontAttributeName: font};
  return [text boundingRectWithSize:CGSizeMake(kStoryWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
}

@implementation NBStoryCell {
  UILabel *_name;
  UILabel *_message;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];

    _name = [[UILabel alloc] initWithFrame:CGRectZero];
    [_name setFont:[UIFont boldSystemFontOfSize:kStoryFontSize]];
    [_name setNumberOfLines:0];
    [self addSubview:_name];

    _message = [[UILabel alloc] initWithFrame:CGRectZero];
    [_message setFont:[UIFont systemFontOfSize:kStoryFontSize]];
    [_message setNumberOfLines:0];
    [self addSubview:_message];
  }
  return self;
}

+ (CGFloat)calculateHeightOf:(NSDictionary *)data
{
  CGFloat height = 0;

  // Calculate the height of the name
  CGRect nameRect = CGRectForText(data[@"name"], [UIFont boldSystemFontOfSize:kStoryFontSize]);
  height += CGRectGetHeight(nameRect);

  // Calculate the height of the message
  CGRect messageRect = CGRectForText(data[@"message"], [UIFont systemFontOfSize:kStoryFontSize]);
  height += CGRectGetHeight(messageRect);

  return kStoryMargin + height + kStoryMargin;
}

- (void)setData:(NSDictionary *)data
{
  _data = data;

  // Set the name
  CGRect nameRect = CGRectForText(_data[@"name"], [UIFont boldSystemFontOfSize:kStoryFontSize]);
  [_name setFrame:CGRectOffset(nameRect, kStoryMargin, kStoryMargin)];
  [_name setText:_data[@"name"]];

  // Set the message
  CGRect messageRect = CGRectForText(_data[@"message"], [UIFont systemFontOfSize:kStoryFontSize]);
  [_message setFrame:CGRectOffset(messageRect, kStoryMargin, CGRectGetMaxY(_name.frame))];
  [_message setText:_data[@"message"]];
}

- (void)prepareForReuse
{
  [_name setText:nil];
  [_name setFrame:CGRectZero];
  [_message setText:nil];
  [_message setFrame:CGRectZero];
}

- (CGRect)rectForText:(NSString *)text
{
  NSDictionary *attrs = @{NSFontAttributeName: [UIFont systemFontOfSize:kStoryFontSize]};
  CGRect rect = [text boundingRectWithSize:CGSizeMake(kStoryWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
  return rect;
}

@end
