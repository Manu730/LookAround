//
//  PlaceTableViewCell.h
//  BmsPlaces
//
//  Created by Manoj Kumar on 28/04/16.
//  Copyright © 2016 bms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceDataObject.h"

@protocol PlaceTableViewCellDelagate <NSObject>

-(void)goToMapViewWithObject:(PlaceDataObject *)placeObject;

@end

@interface PlaceTableViewCell : UITableViewCell
@property (strong, nonatomic) id<PlaceTableViewCellDelagate> cellDelegate;
-(id)initPlaceCellWithObject:(PlaceDataObject *)placeData;

@end
