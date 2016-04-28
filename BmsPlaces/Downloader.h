//
//  Downloader.h
//  BmsPlaces
//
//  Created by Manoj Kumar on 28/04/16.
//  Copyright © 2016 bms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Downloader : NSObject
{
    dispatch_queue_t downloadQueue_;
}

+ (id)sharedInstance;
- (void)downloadImage:(NSString *)url andImageName:(NSString*)imageName;

@end
