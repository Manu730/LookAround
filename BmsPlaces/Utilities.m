//
//  Utilities.m
//  BmsPlaces
//
//  Created by Manoj Kumar on 28/04/16.
//  Copyright © 2016 bms. All rights reserved.
//

#import "Utilities.h"
#import "Constants.h"

@implementation Utilities

+ (id)sharedInstance
{
    static Utilities *instance_ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance_ = [[self alloc] init];
    });
    return instance_;
}

- (id)init
{
    if (self = [super init]) {
    }
    return self;
}

- (BOOL)createImageDirectoryPath
{
    NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = [documentPath objectAtIndex:0];
    NSString *imageDirectoryPath = [basePath stringByAppendingPathComponent:@"Images"];
    NSFileManager *fileMgr = [NSFileManager defaultManager];

    if ([fileMgr fileExistsAtPath:imageDirectoryPath]) {
        return YES;
    }
    else {
        [fileMgr createDirectoryAtPath:imageDirectoryPath withIntermediateDirectories:NO attributes:nil error:nil];
        return YES;
    }
    return NO;
}

- (NSString*)getImageDirectoryPath
{
    NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = [documentPath objectAtIndex:0];
    NSString *imageDirectoryPath = [basePath stringByAppendingPathComponent:@"Images"];

    return imageDirectoryPath;
}

-(NSString *)getImageUrlWithPhotoReference:(NSString *)photoReference{
    return [image_URL stringByAppendingString:[NSString stringWithFormat:@"photoreference=%@&key=%@",photoReference,API_KEY]];
}

- (BOOL)imageExistsWithName:(NSString *)imageName{
    NSFileManager *imgManager = [NSFileManager defaultManager];
    NSString *imgPath = [[[Utilities sharedInstance]getImageDirectoryPath] stringByAppendingPathComponent:imageName];
    
    if ([imgManager fileExistsAtPath:imgPath]) {
        return YES;
    }
    return NO;
}

@end
