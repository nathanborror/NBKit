//
//  NBJSON.m
//  NBKit
//
//  Created by Nathan Borror on 10/31/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import "NBJSON.h"

@implementation NBJSON

+ (NSArray *)fetchLocal:(NSString *)resource
{
  NSString *filePath = [[NSBundle mainBundle] pathForResource:resource ofType:@"json"];
  NSData *fileContents = [NSData dataWithContentsOfFile:filePath];
  NSDictionary *data = [NSJSONSerialization JSONObjectWithData:fileContents options:kNilOptions error:nil];
  NSMutableArray *items = [[NSMutableArray alloc] init];
  for (NSDictionary *dict in data) {
    [items addObject:dict];
  }
  return items;
}

@end
