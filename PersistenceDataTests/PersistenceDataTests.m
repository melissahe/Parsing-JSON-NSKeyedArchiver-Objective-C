//
//  PersistenceDataTests.m
//  PersistenceDataTests
//
//  Created by C4Q on 5/25/18.
//  Copyright © 2018 Melissa He @ C4Q. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FavoriteEventsAPI.h"

@interface PersistenceDataTests : XCTestCase

@end

@implementation PersistenceDataTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLoadData {
    BOOL eventLoaded = [[FavoriteEventsAPI sharedManager] loadEvents];
    NSArray *eventsArray = [[FavoriteEventsAPI sharedManager] getEvents];
    if (!eventLoaded && eventsArray.count != 0) {
        XCTFail(@"Events did not load");
    } else {
        XCTAssertTrue(eventLoaded, @"event did not load!");
    }
}

- (void)testAddRemoveData {
    Event *event = [Event testEvent];
    BOOL addEventSuccess = [[FavoriteEventsAPI sharedManager] addEvent:event];
    
    XCTAssertTrue(addEventSuccess, @"could not add event");
    
    BOOL removeEventSuccess = [[FavoriteEventsAPI sharedManager] removeEvent:event];
    XCTAssertTrue(removeEventSuccess, @"could not remove event");
}

@end
