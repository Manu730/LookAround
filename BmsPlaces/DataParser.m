//
//  DataParser.m
//  BmsPlaces
//
//  Created by Manoj Kumar on 27/04/16.
//  Copyright © 2016 bms. All rights reserved.
//

#import "DataParser.h"
#import "PlaceDataObject.h"

@implementation DataParser{
    NSMutableArray *placeDataObjects;
}

static DataParser *this	= nil;
+ (id) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        this = [[DataParser alloc] init];
    });
    return this;
}

-(id)init{
    self = [super init];
    if (self) {
        placeDataObjects = [[NSMutableArray alloc]init];
    }
    return self;
}


-(NSArray *)getCurrentPlaceDataObjects{
    return [NSArray arrayWithArray:placeDataObjects];
}

-(void)createDataWithJson:(NSData *)jsonData{
    NSError *error;
    NSDictionary *dataJson = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    if (error != nil) {
        return;
    }
    
    if (placeDataObjects.count > 0) {
        [placeDataObjects removeAllObjects];
    }
    
    NSArray *placeObjects = [dataJson objectForKey:@"results"];
    for (NSDictionary *placeData in placeObjects) {
        PlaceDataObject *newPlaceObject = [[PlaceDataObject alloc]init];
        newPlaceObject.geometry = [placeData objectForKey:@"geometry"];
        newPlaceObject.icon = [placeData objectForKey:@"icon"];
        newPlaceObject.objId = [placeData objectForKey:@"id"];
        newPlaceObject.name = [placeData objectForKey:@"name"];
        newPlaceObject.photoArray = [placeData objectForKey:@"photos"];
        newPlaceObject.place_id = [placeData objectForKey:@"place_id"];
        newPlaceObject.placeRating = [placeData objectForKey:@"rating"];
        newPlaceObject.placeReference = [placeData objectForKey:@"reference"];
        newPlaceObject.scope = [placeData objectForKey:@"scope"];
        newPlaceObject.typeArray = [placeData objectForKey:@"types"];
        newPlaceObject.placeVicinity=[placeData objectForKey:@"vicinity"];
        newPlaceObject.opening_hours=[placeData objectForKey:@"opening_hours"];
        [placeDataObjects addObject:newPlaceObject];
    }
}

@end
