//
//  FavoriteEventsAPI.m
//  Parsing JSON in Objective-C
//
//  Created by C4Q on 5/25/18.
//  Copyright © 2018 Melissa He @ C4Q. All rights reserved.
//

#import "FavoriteEventsAPI.h"
#define FILE_PATH @"favoriteEvents.plist"

@interface FavoriteEventsAPI ()
@property (nonatomic) NSMutableArray *favoriteEventsArray;
@end

@implementation FavoriteEventsAPI

+ (instancetype)sharedManager {
    static FavoriteEventsAPI *favoriteEventsAPI;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        favoriteEventsAPI = [[FavoriteEventsAPI alloc] init];
    });
    return favoriteEventsAPI;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _favoriteEventsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

//to get the path to the document directory
    //1. get the documents path
- (NSString *)getDocumentDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = paths[0];
    return documentDirectory;
}

    //2. then append our custom file name to the path
- (NSString *)getPathForFileName:(NSString *)fileName {
    NSString *documentDirectory = [self getDocumentDirectory];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:fileName];
    return filePath;
}

- (BOOL)loadEvents {
    NSString *filePath = [self getPathForFileName:FILE_PATH];
    
    NSMutableArray<Event *> *eventsArray = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    if (eventsArray) {
        self.favoriteEventsArray = eventsArray;
    } else {
        NSLog(@"fail to load and unarchive favorite events");
        return NO;
    }
    return YES;
}

- (NSArray<Event *> *)getEvents {
    return self.favoriteEventsArray;
}

- (BOOL)addEvent:(Event *)event {
    NSString *filePath = [self getPathForFileName:FILE_PATH];
    [self.favoriteEventsArray addObject:event];
    BOOL success = [NSKeyedArchiver archiveRootObject:self.favoriteEventsArray toFile:filePath];
    return success;
}

- (BOOL)removeEvent:(Event *)event {
    NSString *filePath = [self getPathForFileName:FILE_PATH];
    
    BOOL exist = [self.favoriteEventsArray containsObject:event];
    if (exist) {
        NSInteger index = [self.favoriteEventsArray indexOfObject:event];
        [self.favoriteEventsArray removeObjectAtIndex:index];
        BOOL success = [NSKeyedArchiver archiveRootObject:self.favoriteEventsArray toFile:filePath];
        return success;
    }
    return NO;
}

@end
