//
//  NBCollectionViewController.m
//  NBKitExample
//
//  Created by Nathan Borror on 10/12/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import "NBCollectionViewController.h"
#import "NBReorderableCollectionViewLayout.h"
#import "NBCell.h"

static const NSInteger kSectionCount = 5;
static const NSInteger kItemCount = 20;

@implementation NBCollectionViewController {
  NSMutableArray *_sections;
  UICollectionView *_collectionView;
}

- (id)init
{
  if (self = [super init]) {
    [self.navigationItem setTitle:@"Collections"];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  _sections = [[NSMutableArray alloc] initWithCapacity:kItemCount];
  for(int s = 0; s < kSectionCount; s++) {
    NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:kItemCount];
    for(int i = 0; i < kItemCount; i++) {
      [data addObject:[NSString stringWithFormat:@"%c %@", 65+s, @(i)]];
    }
    [_sections addObject:data];
  }

  NBReorderableCollectionViewLayout *layout = [[NBReorderableCollectionViewLayout alloc] init];
  [layout setMinimumLineSpacing:1];
  [layout setMinimumInteritemSpacing:1];
  [layout setItemSize:CGSizeMake(106, 106)];

  _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
  [_collectionView registerClass:[NBCell class] forCellWithReuseIdentifier:@"NBCell"];
  [_collectionView setDelegate:self];
  [_collectionView setDataSource:self];
  [_collectionView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
  [self.view addSubview:_collectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return _sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return [[_sections objectAtIndex:section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  NBCell *cell = (NBCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"NBCell" forIndexPath:indexPath];
  NSMutableArray *data = [_sections objectAtIndex:indexPath.section];
  [cell.label setText:[data objectAtIndex:indexPath.item]];
  return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
  return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)toIndexPath
{
  return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
  NSMutableArray *data1 = [_sections objectAtIndex:fromIndexPath.section];
  NSMutableArray *data2 = [_sections objectAtIndex:toIndexPath.section];
  NSString *index = [data1 objectAtIndex:fromIndexPath.item];

  [data1 removeObjectAtIndex:fromIndexPath.item];
  [data2 insertObject:index atIndex:toIndexPath.item];
}

@end
