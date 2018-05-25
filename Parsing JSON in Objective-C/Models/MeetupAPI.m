//
//  MeetupAPI.m
//  Parsing JSON in Objective-C
//
//  Created by C4Q on 5/24/18.
//  Copyright © 2018 Melissa He @ C4Q. All rights reserved.
//

#import "MeetupAPI.h"
#import "APIKEY.h"

@implementation MeetupAPI

+ (instancetype)sharedManager {
    static MeetupAPI *meetupAPI;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        meetupAPI = [[MeetupAPI alloc] init];
    });
    return meetupAPI;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //to do
    }
    return self;
}

- (void)searchEventsForKeyword:(NSString *)keyword completionHandler:(void (^)(NSError *, NSArray <Event *> *))completion {
    NSString *formattedKeyword = [keyword stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"https://api.meetup.com/find/events?key=%@&fields=group_photo&text=%@&lat=40.72&lon=-73.84", API_KEY, formattedKeyword]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [[NetworkHelper sharedManager] performRequest:request completionHandler:^(NSError *error, NSData *data) {
        if (error) {
            completion(error, nil);
        } else if (data) {
            NSError *error;
            NSArray *eventDictArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            if (error) {
                completion(error, nil);
            } else {
                //how you explicitly cast arrays
                NSMutableArray<Event *> *eventArray = [[NSMutableArray alloc] init];
                
                for (NSDictionary *dict in eventDictArray) {
                    Event *event = [[Event alloc] initWithDict:dict];
                    [eventArray addObject:event];
                }
                
                completion(nil, eventArray);
            }
        }
    }];
}

@end
