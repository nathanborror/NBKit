//
//  NBJSON.m
//  NBKit
//
//  Created by Nathan Borror on 10/31/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import "NBJSON.h"

@implementation NBJSON

+ (NSArray *)fetchLocalIntoList:(NSString *)resource
{
  NSString *filePath = [[NSBundle mainBundle] pathForResource:resource ofType:@"json"];
  NSData *fileContents = [NSData dataWithContentsOfFile:filePath];
  NSError *error;
  NSDictionary *data = [NSJSONSerialization JSONObjectWithData:fileContents options:kNilOptions error:&error];

  if (error) {
    NSLog(@"Error fetching JSON: %@", error.localizedDescription);
  }

  NSMutableArray *items = [[NSMutableArray alloc] init];
  for (NSDictionary *dict in data) {
    [items addObject:dict];
  }
  return items;
}

+ (NSDictionary *)fetchLocal:(NSString *)resource
{
  NSString *filePath = [[NSBundle mainBundle] pathForResource:resource ofType:@"json"];
  NSData *fileContents = [NSData dataWithContentsOfFile:filePath];
  NSError *error;
  NSDictionary *data = [NSJSONSerialization JSONObjectWithData:fileContents options:kNilOptions error:&error];

  if (error) {
    NSLog(@"Error fetching JSON: %@", error.localizedDescription);
  }

  return data;
}

@end
