//
//  EventCell.h
//  Parsing JSON in Objective-C
//
//  Created by C4Q on 5/24/18.
//  Copyright © 2018 Melissa He @ C4Q. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "ImageCache.h"

@interface EventCell : UITableViewCell

- (void)configureCellWithEvent:(Event *)event;

@end
