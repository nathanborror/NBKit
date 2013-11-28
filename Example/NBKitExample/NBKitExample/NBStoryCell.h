//
//  NBStoryCell.h
//  NBKitExample
//
//  Created by Nathan Borror on 11/28/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface NBStoryCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *data;

+ (CGFloat)calculateHeightOf:(NSDictionary *)data;

@end
