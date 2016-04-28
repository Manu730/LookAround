//
//  PlaceDataObject.h
//  BmsPlaces
//
//  Created by Manoj Kumar on 27/04/16.
//  Copyright © 2016 bms. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceDataObject : NSObject
@property(strong, nonatomic) NSString *icon;
@property(strong, nonatomic) NSDictionary *geometry;
@property(strong, nonatomic) NSDictionary *opening_hours;
@property(strong, nonatomic) NSString *objId;
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSArray *photoArray;
@property(strong, nonatomic) NSNumber *placeRating;
@property(strong, nonatomic) NSString *placeVicinity;
@property(strong, nonatomic) NSString *scope;
@property(strong, nonatomic) NSString *placeReference;
@property(strong, nonatomic) NSArray *typeArray;
@property(strong, nonatomic) NSString *place_id;
@end
