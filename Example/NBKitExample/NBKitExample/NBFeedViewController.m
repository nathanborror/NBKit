//
//  NBFeedViewController.m
//  NBKitExample
//
//  Created by Nathan Borror on 11/28/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import "NBFeedViewController.h"
#import "NBStoryCell.h"
#import "NBJSON.h"

@implementation NBFeedViewController {
  UITableView *_feedTable;
  NSArray *_feedStories;
}

- (id)init
{
  if (self = [super init]) {
    [self setTitle:@"Feed"];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  // Load in the story data
  _feedStories = [NBJSON fetchLocalIntoList:@"feedData"];

  _feedTable = [[UITableView alloc] initWithFrame:CGRectZero];
  [_feedTable registerClass:[NBStoryCell class] forCellReuseIdentifier:@"NBStoryCell"];
  [_feedTable setDelegate:self];
  [_feedTable setDataSource:self];
  [self.view addSubview:_feedTable];
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  [_feedTable setFrame:self.view.bounds];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [_feedStories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NBStoryCell *cell = (NBStoryCell *)[tableView dequeueReusableCellWithIdentifier:@"NBStoryCell"];
  NSDictionary *story = [_feedStories objectAtIndex:indexPath.item];
  [cell setData:story];
  return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSDictionary *story = [_feedStories objectAtIndex:indexPath.item];
  return [NBStoryCell calculateHeightOf:story];
}

@end
