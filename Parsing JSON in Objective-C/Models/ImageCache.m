//
//  ImageCache.m
//  Parsing JSON in Objective-C
//
//  Created by C4Q on 5/24/18.
//  Copyright © 2018 Melissa He @ C4Q. All rights reserved.
//

#import "ImageCache.h"

@implementation ImageCache

+ (instancetype)sharedManager {
    static ImageCache *imageCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageCache = [[ImageCache alloc] init];
    });
    return imageCache;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sharedCache = [[NSCache alloc] init];
    }
    return self;
}

- (void)storeImage:(UIImage *)image withKey:(NSString *)key {
    [self.sharedCache setObject:image forKey:key];
}

- (UIImage *)retrieveImageWithKey:(NSString *)key {
    return [self.sharedCache objectForKey:key];
}

- (void)downloadImageWithURLString:(NSString *)urlString completionHandler:(void(^)(NSError *error, UIImage *image))completion {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[NetworkHelper sharedManager] performRequest:request completionHandler:^(NSError *error, NSData *data) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else if (data) {
            UIImage *image = [UIImage imageWithData:data];
            [self storeImage:image withKey:urlString];
            completion(nil, image);
        }
    }];
}

@end
