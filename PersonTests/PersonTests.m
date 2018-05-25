//
//  PersonTests.m
//  PersonTests
//
//  Created by C4Q on 5/21/18.
//  Copyright © 2018 Melissa He @ C4Q. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Person.h"

@interface PersonTests : XCTestCase

@end

@implementation PersonTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//if JSON is coming from a .json file in the app bundle
- (void)testPerson {
    //1. get path to json file
        //use NSBundle (which represents the app and its files
    NSString *path = [NSBundle.mainBundle pathForResource:@"sample" ofType:@"json"];
    //declare an error variable here; it will be nil at first, and if there is an error, the value will be changed to non-nil
    NSError *error;
    
    //2. check if path is valid, it could be nil if the path doesn't exist, like wrong name or type xD
    if (path) {
        //3. then grab the data/json from the path
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        
        //4. check if data/json is valid
        if (data) {
            //5. use JSONSerialization to convert json to Foundation object (NSDictionary)
                //NSJSONReadingAllowFragments = TODO
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            //6. check if there was an error in json serialization
            if (error) {
                XCTFail(@"Could not initialize dictionary from json");
                return;
            }
            
            //7. create custom object with init that uses the dictionary
            Person *person = [[Person alloc] initWithDict:dict];
            XCTAssertEqualObjects(person.name, @"Jane", @"The names were not the same.");
            XCTAssertEqualObjects(person.email, @"jane@jane.com", @"The emails were not the same.");
            XCTAssertEqualObjects(person.phone, @"917-123-4567", @"The phones were not the same.");
            //[NSJSONSerialization isValidJSONObject:dict] - returns a bool on whether current object can be converted into valid json or not
            XCTAssertTrue([NSJSONSerialization isValidJSONObject:dict], @"This was not valid json");
            
            [person printPersonDescription];
        } else {
            XCTFail(@"Data was nil");
        }
    } else {
        //fail test if path does not exist
        XCTFail(@"resource not found at specified path");
    }
}

@end
