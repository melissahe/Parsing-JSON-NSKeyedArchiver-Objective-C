//
//  EventTests.m
//  EventTests
//
//  Created by C4Q on 5/22/18.
//  Copyright © 2018 Melissa He @ C4Q. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Event.h"

@interface EventTests : XCTestCase

@end

@implementation EventTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreatingEventModel {
    NSString *path = [NSBundle.mainBundle pathForResource:@"Event" ofType:@"json"];
    NSError *error;
    
    if (path) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        
        if (data) {
            //casting the whole array as an event array
            NSMutableArray *eventArray = [[NSMutableArray alloc] init];
            NSArray *eventDictArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            if (error) {
                XCTFail(@"JSON Serialization failed with error: %@", error.localizedDescription);
            } else {
                for (NSDictionary *eventDict in eventDictArray) {
                    Event *event = [[Event alloc] initWithDict:eventDict];
                    [eventArray addObject:event];
                }
                XCTAssertGreaterThanOrEqual(eventArray.count, 1);
                Event *firstEvent = eventArray[0];
                XCTAssertEqualObjects(firstEvent.created, @1525190016000, @"The created properties are not equal");
                XCTAssertEqual(eventArray.count, 3, @"Not all the events were parsed.");
            }
        } else {
            XCTFail(@"No data found at path");
            return;
        }
    } else {
        XCTFail(@"No resource found at path");
    }
}

@end
