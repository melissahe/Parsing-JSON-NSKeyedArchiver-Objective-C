//
//  Event.h
//  Parsing JSON in Objective-C
//
//  Created by C4Q on 5/22/18.
//  Copyright © 2018 Melissa He @ C4Q. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Event : NSObject <NSCoding>

//root - at the root of the json
//you can use NSNumber if you're not sure what you'll be using the number for, like dates work with NSNumber
@property (nonatomic) NSString *eventDate;
@property (nonatomic) NSString *eventId;
@property (nonatomic) NSInteger rsvpCount;
@property (nonatomic, copy) NSString *eventName;
@property (nonatomic, copy) NSString *eventDescription;

//venue
@property (nonatomic) NSDictionary *venueDict;
@property (nonatomic) NSNumber *venueId;
@property (nonatomic, copy) NSString *venueName;
@property (nonatomic) CLLocationCoordinate2D venueCoordinate;

//group
@property (nonatomic) NSDictionary *groupDict;
@property (nonatomic) NSNumber *groupCreated;
@property (nonatomic) NSNumber *groupId;
@property (nonatomic, copy) NSString *groupName;
@property (nonatomic) CLLocationCoordinate2D groupCoordinate;

//photo
@property (nonatomic) NSDictionary *photoDict;
@property (nonatomic) NSNumber *photoId;
@property (nonatomic, copy) NSString *highResLink;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (Event *)testEvent;

@end
