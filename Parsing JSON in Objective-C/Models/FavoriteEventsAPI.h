//
//  FavoriteEventsAPI.h
//  Parsing JSON in Objective-C
//
//  Created by C4Q on 5/25/18.
//  Copyright © 2018 Melissa He @ C4Q. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"

@interface FavoriteEventsAPI : NSObject

+ (instancetype) sharedManager;
- (BOOL)loadEvents;
- (NSArray<Event *> *)getEvents;
- (BOOL)addEvent:(Event *)event;
- (BOOL)removeEvent:(Event *)event;

@end
