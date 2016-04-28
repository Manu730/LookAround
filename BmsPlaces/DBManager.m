//
//  DBManager.m
//  BmsPlaces
//
//  Created by Manoj Kumar on 29/04/16.
//  Copyright © 2016 bms. All rights reserved.
//

#import "DBManager.h"
#import "AppDelegate.h"

@implementation DBManager

+ (id)sharedInstance
{
    static DBManager *instance_ = nil;
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

- (NSManagedObjectContext *)getManagedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(NSArray *)getSavedPlaceDataObjects{
    NSManagedObjectContext *managedObjectContext = [[DBManager sharedInstance]getManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"PlaceObject"];
    return [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
}

-(void)savePlaceDataObject:(PlaceDataObject *)dataObject{
    NSManagedObjectContext *context = [[DBManager sharedInstance]getManagedObjectContext];
    NSManagedObject *newPlaceObj = [NSEntityDescription insertNewObjectForEntityForName:@"PlaceObject" inManagedObjectContext:context];
    
    [newPlaceObj setValue:dataObject.icon forKey:@"icon"];
    [newPlaceObj setValue:dataObject.placeRating forKey:@"placeRating"];
    [newPlaceObj setValue:dataObject.name forKey:@"name"];
    [newPlaceObj setValue:dataObject.objId forKey:@"objId"];
    [newPlaceObj setValue:dataObject.place_id forKey:@"place_id"];
    [newPlaceObj setValue:dataObject.placeReference forKey:@"placeReference"];
    [newPlaceObj setValue:dataObject.placeVicinity forKey:@"placeVicinity"];
    [newPlaceObj setValue:dataObject.scope forKey:@"scope"];
    [newPlaceObj setValue:dataObject.geometry forKey:@"geometry"];
    [newPlaceObj setValue:dataObject.opening_hours forKey:@"opening_hours"];
    [newPlaceObj setValue:dataObject.photoArray forKey:@"photoArray"];
    [newPlaceObj setValue:dataObject.typeArray forKey:@"typeArray"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}
@end
