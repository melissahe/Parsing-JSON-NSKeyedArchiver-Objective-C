//
//  NetworkHelper.h
//  Parsing JSON in Objective-C
//
//  Created by C4Q on 5/23/18.
//  Copyright © 2018 Melissa He @ C4Q. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkHelper : NSObject
//returns the singleton used to manage the API
+ (instancetype)sharedManager;
//method used to handle network requests
    //completion handler takes in a block, remember block syntax
- (void)performRequest:(NSURLRequest *)request completionHandler:(void(^)(NSError *error, NSData *data))completion;

@end
