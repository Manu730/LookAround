//
//  SecondViewController.m
//  BmsPlaces
//
//  Created by Manoj Kumar on 27/04/16.
//  Copyright © 2016 bms. All rights reserved.
//

#import "SecondViewController.h"
#import "DBManager.h"
#import "PlaceDataObject.h"
#import "PlaceTableViewCell.h"
#import "PlaceDetailViewController.h"
#import "MapViewController.h"

@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource,PlaceTableViewCellDelagate>

@end

@implementation SecondViewController{
    NSMutableArray *savedPlaceObjects;
    UITableView *savedPlacesTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    savedPlaceObjects = [[NSMutableArray alloc]init];
    self.navigationItem.title=@"Favourites";
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [self loadTableView];
}

-(void)viewDidAppear:(BOOL)animated{
    if ([[DBManager sharedInstance]getSavedPlaceDataObjects].count > 0) {
        [self convertManagedDataModelToDataObjects];
        [savedPlacesTableView reloadData];
    }else{
        [self addNoFavouritesLabel];
    }
}

-(void)loadTableView{
    savedPlacesTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height-60) style:UITableViewStylePlain];
    savedPlacesTableView.delegate=self;
    savedPlacesTableView.dataSource=self;
    [self.view addSubview:savedPlacesTableView];
}

-(void)convertManagedDataModelToDataObjects{
    BOOL isPlaceNotExists;
    for (NSManagedObject *placeData in [[DBManager sharedInstance]getSavedPlaceDataObjects]) {
        isPlaceNotExists=NO;
        PlaceDataObject *savedDataObject = [[PlaceDataObject alloc]init];
        savedDataObject.icon = [placeData valueForKey:@"icon"];
        savedDataObject.placeRating = [placeData valueForKey:@"placeRating"];
        savedDataObject.name = [placeData valueForKey:@"name"];
        savedDataObject.objId = [placeData valueForKey:@"objId"];
        savedDataObject.place_id = [placeData valueForKey:@"place_id"];
        savedDataObject.placeReference = [placeData valueForKey:@"placeReference"];
        savedDataObject.placeVicinity = [placeData valueForKey:@"placeVicinity"];
        savedDataObject.scope = [placeData valueForKey:@"scope"];
        savedDataObject.geometry = [placeData valueForKey:@"geometry"];
        savedDataObject.opening_hours = [placeData valueForKey:@"opening_hours"];
        savedDataObject.photoArray = [placeData valueForKey:@"photoArray"];
        savedDataObject.typeArray = [placeData valueForKey:@"typeArray"];
        if (savedPlaceObjects.count>0) {
            for (PlaceDataObject *existingObject in savedPlaceObjects) {
                if (![existingObject.name isEqualToString:savedDataObject.name]) {
                    isPlaceNotExists=YES;
                }
            }
        }else{
            [savedPlaceObjects addObject:savedDataObject];
        }
        
        if (isPlaceNotExists) {
            [savedPlaceObjects addObject:savedDataObject];
        }
    }
}
-(void)addNoFavouritesLabel{
    UILabel *noFavText = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height*0.45, self.view.bounds.size.width, self.view.bounds.size.height*0.1)];
    noFavText.text=@"You did not save any favourites yet";
    noFavText.font = [UIFont boldSystemFontOfSize:25.0f];
    noFavText.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:noFavText];
}

#pragma mark - Tableview DataSource Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return savedPlaceObjects.count;
};

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier=@"flightCell";
    PlaceTableViewCell *placeDataCell;
    placeDataCell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (placeDataCell == nil) {
        placeDataCell = [[PlaceTableViewCell alloc]initPlaceCellWithObject:[savedPlaceObjects objectAtIndex:indexPath.section]];
    }
    placeDataCell.cellDelegate=self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    return placeDataCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0f;
}

#pragma mark - TableView Delegate Methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PlaceDetailViewController *placeDetailVC = [[PlaceDetailViewController alloc]init];
    placeDetailVC.placeDetaileDataObject = [savedPlaceObjects objectAtIndex:indexPath.section];
    [self.navigationController pushViewController:placeDetailVC animated:YES];
}


#pragma mark - Cell Delegate Methods

-(void)goToMapViewWithObject:(PlaceDataObject *)placeObject{
    MapViewController *mapView = [[MapViewController alloc]init];
    mapView.dataObject=placeObject;
    [self.navigationController pushViewController:mapView animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
