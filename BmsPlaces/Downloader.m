//
//  Downloader.h
//  BmsPlaces
//
//  Created by Manoj Kumar on 28/04/16.
//  Copyright © 2016 bms. All rights reserved.
//

#import "Downloader.h"
#import "Utilities.h"

@implementation Downloader
+ (id)sharedInstance
{
    static Downloader *instance_ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance_ = [[self alloc] init];
    });
    return instance_;
}

- (id)init
{
    self = [super init];
    if (self) {        
        downloadQueue_ = dispatch_queue_create("BMS.IMAGE.DOWNLOAD.QUEUE", NULL);
        [[Utilities sharedInstance] createImageDirectoryPath];
    }
    return self;
}

- (void)downloadImage:(NSString *)url andImageName:(NSString*)imageName
{
    dispatch_async(downloadQueue_, ^{
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        NSData *pngImageData = [NSData dataWithData:UIImagePNGRepresentation(image)];

        NSString *imgPath = [[[Utilities sharedInstance] getImageDirectoryPath] stringByAppendingPathComponent:
                             [NSString stringWithFormat:@"%@", imageName]];
        [pngImageData writeToFile:imgPath atomically:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ImageDownloaded" object:nil];
    });
}
@end
