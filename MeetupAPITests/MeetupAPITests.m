//
//  MeetupAPITests.m
//  MeetupAPITests
//
//  Created by C4Q on 5/23/18.
//  Copyright © 2018 Melissa He @ C4Q. All rights reserved.
//

#import <XCTest/XCTest.h>
//should import apikey into its own header file for more privacy
#define APIKEY @"1e54781d1a16a77602e22a174c7430"
#import "NetworkHelper.h"
#import "Event.h"
#import "MeetupAPI.h"

@interface MeetupAPITests : XCTestCase

@end

@implementation MeetupAPITests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMeetupAPI {
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"events found"];
    
    NSURL *url = [[NSURL alloc] initWithString: [NSString stringWithFormat:@"https://api.meetup.com/find/events?key=%@&fields=group_photo&lat=40.72&lon=-73.84", APIKEY]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [[NetworkHelper sharedManager] performRequest:request completionHandler:^(NSError *error, NSData *data) {
        if (error) {
            XCTFail(@"could not get data with error: %@", error.localizedDescription);
        } else if (data) {
            NSError *error;
            NSArray *eventDictArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            if (error) {
                XCTFail(@"could not parse json with error: %@", error.localizedDescription);
            } else {
                //how you explicitly cast arrays
                NSMutableArray<Event *> *eventArray = [[NSMutableArray alloc] init];
                
                for (NSDictionary *dict in eventDictArray) {
                    Event *event = [[Event alloc] initWithDict:dict];
                    [eventArray addObject:event];
                }
                
                [expectation fulfill];
                Event *firstEvent = eventArray[0];
                
                //tests
                XCTAssertEqual(eventArray.count, 16, @"The event count is not equal.");
                XCTAssertEqualObjects(firstEvent.eventDate, @1512008338000, @"The event created dates are not equal.");
            }
        }
    }];
    
    [self waitForExpectations:@[expectation] timeout:10];
}

- (void)testSearchEventWithKeyword {
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"events found"];
    
    NSString *keyword = [@"memorial day" stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSURL *url = [[NSURL alloc] initWithString: [NSString stringWithFormat:@"https://api.meetup.com/find/events?key=%@&fields=group_photo&text=%@&lat=40.72&lon=-73.84", APIKEY, keyword]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [[NetworkHelper sharedManager] performRequest:request completionHandler:^(NSError *error, NSData *data) {
        if (error) {
            XCTFail(@"could not get data with error: %@", error.localizedDescription);
        } else if (data) {
            NSError *error;
            NSArray *eventDictArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            if (error) {
                XCTFail(@"could not parse json with error: %@", error.localizedDescription);
            } else {
                //how you explicitly cast arrays
                NSMutableArray <Event *> *eventArray = [[NSMutableArray alloc] init];
                
                for (NSDictionary *dict in eventDictArray) {
                    Event *event = [[Event alloc] initWithDict:dict];
                    [eventArray addObject:event];
                }
                
                [expectation fulfill];
                Event *firstEvent = eventArray[0];
                
//                //tests
//                XCTAssertEqual(eventArray.count, 16, @"The event count is not equal.");
//                XCTAssertEqualObjects(firstEvent.created, @1512008338000, @"The event created dates are not equal.");
            }
        }
    }];
    
    [self waitForExpectations:@[expectation] timeout:10];
}

@end
