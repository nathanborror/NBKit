//
//  NBAppDelegate.m
//  NBKitExample
//
//  Created by Nathan Borror on 5/28/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import "NBAppDelegate.h"
#import "NBViewController.h"

@implementation NBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  // Override point for customization after application launch.

  NBViewController *viewController = [[NBViewController alloc] init];
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
  [self.window setRootViewController:navController];

  [self.window makeKeyAndVisible];
  return YES;
}

@end
