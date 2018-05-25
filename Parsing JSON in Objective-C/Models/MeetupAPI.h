//
//  MeetupAPI.h
//  Parsing JSON in Objective-C
//
//  Created by C4Q on 5/24/18.
//  Copyright © 2018 Melissa He @ C4Q. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
#import "APIKEY.h"
#import "NetworkHelper.h"

@interface MeetupAPI : NSObject

+ (instancetype)sharedManager;

- (void)searchEventsForKeyword:(NSString *)keyword completionHandler:(void(^)(NSError *error, NSArray<Event *> *eventsArray))completion;

@end
