//
//  ImageCache.h
//  Parsing JSON in Objective-C
//
//  Created by C4Q on 5/24/18.
//  Copyright © 2018 Melissa He @ C4Q. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkHelper.h"

//Image Caching uses NSCache to store things, useful for making sure we don't store too much on the phone, it automatically starts getting rid of cached images if the limit is reached
//objects are stored with a key, like a dictionary
@interface ImageCache : NSObject

@property (nonatomic) NSCache *sharedCache;

+ (instancetype)sharedManager;
- (void)storeImage:(UIImage *)image withKey:(NSString *)key;
- (UIImage * _Nullable)retrieveImageWithKey:(NSString *)key;
- (void)downloadImageWithURLString:(NSString *)urlString completionHandler:(void(^)(NSError *error, UIImage *image))completion;

@end
