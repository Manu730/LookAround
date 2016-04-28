//
//  DBManager.h
//  BmsPlaces
//
//  Created by Manoj Kumar on 29/04/16.
//  Copyright © 2016 bms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PlaceDataObject.h"

@interface DBManager : NSObject
+ (id)sharedInstance;
- (NSManagedObjectContext *)getManagedObjectContext;
- (void)savePlaceDataObject:(PlaceDataObject *)dataObject;
- (NSArray *)getSavedPlaceDataObjects;
@end
