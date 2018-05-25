//
//  Person.h
//  Parsing JSON in Objective-C
//
//  Created by C4Q on 5/21/18.
//  Copyright © 2018 Melissa He @ C4Q. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSString *email;
@property (copy, nonatomic, readonly) NSString *phone;

//when you convert the json into a foundation object through JSONSerialization, you can pass that dictionary into this custom init to create your custom object from the dictionary
    //instancetype is more type safe than id, which means any
- (instancetype)initWithDict:(NSDictionary *)dict;
- (void)printPersonDescription;

@end
