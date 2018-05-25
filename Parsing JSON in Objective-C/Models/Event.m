//
//  Event.m
//  Parsing JSON in Objective-C
//
//  Created by C4Q on 5/22/18.
//  Copyright © 2018 Melissa He @ C4Q. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
#import "CONSTANTS.h"

@implementation Event

//for comparison
- (BOOL)isEqual:(Event *)object {
    return ([self.eventId isEqual:object.eventId]);
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        //root
        if (dict[DATE]) {
            _eventDate = dict[DATE];
        } else {
            _eventDate = @"No Date Found";
        }
        _eventId = dict[ID];
        _rsvpCount = [dict[RSVP_COUNT] integerValue];
        if (dict[NAME]) {
            _eventName = dict[NAME];
        } else {
            _eventName = @"No event name available";
        }
        if (dict[DESCRIPTION]) {
            _eventDescription = dict[DESCRIPTION];
        } else {
            _eventDescription = @"No event description available.";
        }
        
        //venue
        if (dict[@"venue"]) {
            _venueDict = dict[@"venue"];
            _venueId = self.venueDict[ID];
            _venueName = self.venueDict[NAME];
            if (self.venueDict[LAT] && self.venueDict[LON]) {
                double lat = [self.venueDict[LAT] doubleValue];
                double lon = [self.venueDict[LON] doubleValue];
                _venueCoordinate = CLLocationCoordinate2DMake(lat, lon);
            }
        }
        
        //group
        if (dict[@"group"]) {
            _groupDict = dict[@"group"];
            _groupCreated = self.groupDict[CREATED];
            _groupId = self.groupDict[ID];
            _groupName = self.groupDict[NAME];
            if (self.groupDict[LAT] && self.groupDict[LON]) {
                double lat = [self.groupDict[LAT] doubleValue];
                double lon = [self.groupDict[LON] doubleValue];
                _groupCoordinate = CLLocationCoordinate2DMake(lat, lon);
            }
            
            //photo
            if (self.groupDict[@"photo"]) {
                _photoDict = self.groupDict[@"photo"];
                _photoId = self.photoDict[ID];
                _highResLink = self.photoDict[HIGHRES_LINK];
            }
            
        }
    }
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    //use encoder to archive all the properties you want to save
    //root
    [aCoder encodeObject:_eventDate forKey:DATE];
    [aCoder encodeObject:_eventId forKey:@"event_id"];
    [aCoder encodeInteger:_rsvpCount forKey:RSVP_COUNT];
    [aCoder encodeObject:_eventName forKey:@"event_name"];
    [aCoder encodeObject:_eventDescription forKey:DESCRIPTION];
    
    //venue
    [aCoder encodeObject:_venueId forKey:@"venue_id"];
    [aCoder encodeObject:_venueName forKey:@"venue_name"];
    
    //group
    [aCoder encodeObject:_groupId forKey:@"group_id"];
    [aCoder encodeObject:_groupName forKey:@"group_name"];
    
    //photo
    [aCoder encodeObject:_highResLink forKey:HIGHRES_LINK];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        //use decoder to decode all properties from archive
        //root
        _eventDate = [aDecoder decodeObjectForKey:DATE];
        _eventId = [aDecoder decodeObjectForKey:@"event_id"];
        _rsvpCount = [aDecoder decodeIntegerForKey:RSVP_COUNT];
        _eventName = [aDecoder decodeObjectForKey:@"event_name"];
        _eventDescription = [aDecoder decodeObjectForKey:DESCRIPTION];
        
        //venue
        _venueId = [aDecoder decodeObjectForKey:@"venue_id"];
        _venueName = [aDecoder decodeObjectForKey:@"venue_name"];
        
        //group
        _groupId = [aDecoder decodeObjectForKey:@"group_id"];
        _groupName = [aDecoder decodeObjectForKey:@"group_name"];
        
        //photo
        _highResLink = [aDecoder decodeObjectForKey:HIGHRES_LINK];
    }
    return self;
}

+ (Event *)testEvent {
    NSDictionary *eventDictionary = @{
                                      @"local_date": @"11/11/11",
                                      @"id": @"12345",
                                      @"yes_rsvp_count" : @34
                                      };
    Event *event = [[Event alloc] initWithDict:eventDictionary];
    return event;
}

@end
