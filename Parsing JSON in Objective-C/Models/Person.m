//
//  Person.m
//  Parsing JSON in Objective-C
//
//  Created by C4Q on 5/21/18.
//  Copyright © 2018 Melissa He @ C4Q. All rights reserved.
//

#import "Person.h"

@implementation Person

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) { //if self is not nil, then initialize the rest
        //to check if values are possibly nil in dictionary, you must check if nil
        if (dict[@"name"]) {
            _name = dict[@"name"];
        } else {
            _name = @"N/A";
        }
        if (dict[@"email"]) {
            _email = dict[@"email"];
        } else {
            _email = @"N/A";
        }
        if (dict[@"phone"]) {
            _phone = dict[@"phone"];
        } else {
            _phone = @"N/A";
        }
    }
    return self;
}

- (void)printPersonDescription {
    NSLog(@"Name: %@, Email: %@, Phone: %@", self.name, self.email, self.phone);
}

@end
