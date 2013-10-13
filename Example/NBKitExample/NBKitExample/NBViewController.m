//
//  NBViewController.m
//  NBKitExample
//
//  Created by Nathan Borror on 5/28/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import "NBViewController.h"
#import "NBBounceViewController.h"
#import "NBCardTossViewController.h"
#import "DynamicSpringViewController.h"
#import "NBGridViewController.h"
#import "NBCollectionViewController.h"

@interface NBViewController ()
{
  UITableView *tableview;
  NSArray *controllers;
}
@end

@implementation NBViewController

- (id)init
{
  self = [super init];
  if (self) {
    [self.navigationItem setTitle:@"NBKit"];

    controllers = @[
      [[NBBounceViewController alloc] init],
      [[NBCardTossViewController alloc] init],
      [[DynamicSpringViewController alloc] init],
      [[NBGridViewController alloc] init],
      [[NBCollectionViewController alloc] init]
    ];

    tableview = [[UITableView alloc] initWithFrame:self.view.bounds];
    [tableview setDelegate:self];
    [tableview setDataSource:self];
    [self.view addSubview:tableview];
  }
  return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [controllers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:@"TableViewCell"];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewCell"];
  }

  UIViewController *viewController = [controllers objectAtIndex:indexPath.row];
  [cell.textLabel setText:viewController.navigationItem.title];
  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  UIViewController *viewController = [controllers objectAtIndex:indexPath.row];
  [self.navigationController pushViewController:viewController animated:YES];
}

@end
