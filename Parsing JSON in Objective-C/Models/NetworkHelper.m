//
//  NetworkHelper.m
//  Parsing JSON in Objective-C
//
//  Created by C4Q on 5/23/18.
//  Copyright © 2018 Melissa He @ C4Q. All rights reserved.
//

#import "NetworkHelper.h"

@interface NetworkHelper ()
@property (nonatomic) NSURLSession *urlSession;
@end

@implementation NetworkHelper

//instantiating the singleton
+ (instancetype)sharedManager {
    //static - a variable that has been allocated for "statically"; allocation lifetime is the entire run of the program
    static NetworkHelper *networkHelper; //create a constant of the class you want to make a singleton of
    //use dispatch_once to only execute code once!! - dispatch_once is a method provided by grand central dispatch that ensures that
    //this is a codesnippet provided by iOS SDK
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkHelper = [[NetworkHelper alloc] init];
    });
    return networkHelper;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //initialize self properties here
        //create the url session with default configuration or shared manager
        _urlSession = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration];
    }
    return self;
}

- (void)performRequest:(NSURLRequest *)request completionHandler:(void(^)(NSError *error, NSData *data))completion {
    //create the task
        //do we need the _Nullable stuff?
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        NSURLSessionDataTask *task = [self.urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    completion(error, nil);
                } else if (data) {
                    completion(nil, data);
                }
            });
        }];
        //resume the task
        [task resume];
    });
}

@end
