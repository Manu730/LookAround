//
//  Utilities.h
//  BmsPlaces
//
//  Created by Manoj Kumar on 28/04/16.
//  Copyright © 2016 bms. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject
{
}

+ (id)sharedInstance;
- (BOOL)createImageDirectoryPath;
- (NSString*)getImageDirectoryPath;
- (BOOL)imageExistsWithName:(NSString *)imageName;
- (NSString *)getImageUrlWithPhotoReference:(NSString *)photoReference;
@end
