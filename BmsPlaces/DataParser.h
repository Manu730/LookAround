//
//  DataParser.h
//  BmsPlaces
//
//  Created by Manoj Kumar on 27/04/16.
//  Copyright © 2016 bms. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataParser : NSObject
-(void)createDataWithJson:(NSData *)jsonData;
-(NSArray *)getCurrentPlaceDataObjects;
+ (id) sharedInstance;

@end
