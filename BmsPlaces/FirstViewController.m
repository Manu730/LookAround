//
//  FirstViewController.m
//  BmsPlaces
//
//  Created by Manoj Kumar on 27/04/16.
//  Copyright © 2016 bms. All rights reserved.
//

#import "FirstViewController.h"
#import "AsyncHttpRequestObject.h"
#import "Constants.h"
#import "DataParser.h"
#import "SecondViewController.h"
#import "PlaceTableViewCell.h"
#import "MapViewController.h"
#import "PlaceDetailViewController.h"
#import "MBProgressHUD.h"
#import <CoreLocation/CoreLocation.h>


@interface FirstViewController ()<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,PlaceTableViewCellDelagate>
@property(strong, nonatomic) CLLocationManager *userLocationManager;
@property(assign) BOOL isSubviewsLoaded;
@end

@implementation FirstViewController{
    NSString *userLongitude;
    NSString *userLatitude;
    BOOL isUserLocationUpdated;
    UITableView *placesTableView;
    NSArray *placeDataArray;
    UIImageView *backGroundImage;
    UIButton *typeFilterButton;
    UIButton *rangeFilterButton;
    NSString *currentSelectedPlaceType;
    NSString *currentSelectedRange;

}

#pragma mark - view load methods

- (void)viewDidLoad {
    [super viewDidLoad];
    userLatitude = [NSString stringWithFormat:@"%f",12.928267]; //test values if location not enabled in simulator
    userLongitude = [NSString stringWithFormat:@"%f",77.621659];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableData) name:@"ImageDownloaded" object:nil];
}

-(void)reloadTableData{
    [placesTableView reloadData];
}
-(void)viewWillAppear:(BOOL)animated{
    self.title=@"Places Around";
    currentSelectedPlaceType=PLACE_TYPE_ALL;
    currentSelectedRange=@"5000";
    if ([CLLocationManager locationServicesEnabled]) {
        self.userLocationManager = [[CLLocationManager alloc] init];
        self.userLocationManager.delegate = self;
        self.userLocationManager.desiredAccuracy=kCLLocationAccuracyKilometer;
        if ([self.userLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.userLocationManager requestWhenInUseAuthorization];
        }
        [self.userLocationManager startUpdatingLocation];
    } else {
        NSLog(@"Location services are not enabled");
    }
    [self loadViews];
    [self performSelector:@selector(checkIfUserLocationUpdatedAndShowDataAccordingly) withObject:nil afterDelay:4.0];
}


#pragma mark - Data Related methods

-(NSString *)createDataUrlWithType:(NSString *)placeType withInDistance:(NSString *)radiusDistance{
   return [data_URL stringByAppendingString:[NSString stringWithFormat:@"location=%f,%f&radius=%d&type=%@&key=%@",[userLatitude floatValue],[userLongitude floatValue],[radiusDistance intValue],placeType,API_KEY]];
}

-(void)loadDatafromUrl:(NSString *)dataUrl{
    MBProgressHUD *loadingDataAnim = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    loadingDataAnim.labelText = @"Loading Data";
    NSURLRequest *dataRequest = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[dataUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    __block AsyncHttpRequestObject *asyncRequest = [[AsyncHttpRequestObject alloc]initWithRequest:dataRequest withSuccessCallBack:^(){
        [loadingDataAnim hide:YES];
        NSError *error;
        NSDictionary *reslutJson = [NSJSONSerialization JSONObjectWithData:asyncRequest.responseData options:kNilOptions error:&error];
        if ([[reslutJson objectForKey:@"status"] isEqualToString:@"OVER_QUERY_LIMIT"]) {
            [self showAlertWithMessage:@"Query Limit Exceeded" withTitle:@"QUERY_LIMIT"];
            return ;
        }
        [[DataParser sharedInstance]createDataWithJson:asyncRequest.responseData];
        placeDataArray = [NSArray arrayWithArray:[[DataParser sharedInstance]getCurrentPlaceDataObjects]];
        NSLog(@"current data array is %@",placeDataArray);
        [placesTableView reloadData];
    }withFailureCallBack:^(){
        [loadingDataAnim hide:YES];
        if (asyncRequest.response.statusCode==404) {
            [self showAlertWithMessage:@"Server Not Found, Please try Again Later" withTitle:@"Error"];
        }else if (asyncRequest.response.statusCode==503){
            [self showAlertWithMessage:@"Service Unavailable, Please try Again Later" withTitle:@"Error"];
        }else if (asyncRequest.response.statusCode==500){
            [self showAlertWithMessage:@"Some Error Occuured, Please try Again Later" withTitle:@"Error"];
        }else{
            [self showAlertWithMessage:@"Unknown Error Occured, Please try Again Later" withTitle:@"Error"];
        }
    }];
    [asyncRequest start];
    

}

-(void)showPlacesWithType:(UIAlertAction *)userAction{
    NSString *currentDataURL;
    if ([userAction.title isEqualToString:PLACE_TYPE_FOOD]) {
        currentDataURL = [self createDataUrlWithType:PLACE_TYPE_FOOD withInDistance:currentSelectedRange];
    }else if ([userAction.title isEqualToString:PLACE_TYPE_GYM]){
        currentDataURL = [self createDataUrlWithType:PLACE_TYPE_GYM withInDistance:currentSelectedRange];
    }else if ([userAction.title isEqualToString:PLACE_TYPE_SCHOOL]){
        currentDataURL = [self createDataUrlWithType:PLACE_TYPE_SCHOOL withInDistance:currentSelectedRange];
    }else if ([userAction.title isEqualToString:PLACE_TYPE_HOSPITAL]){
        currentDataURL = [self createDataUrlWithType:PLACE_TYPE_HOSPITAL withInDistance:currentSelectedRange];
    }else if ([userAction.title isEqualToString:PLACE_TYPE_SPA]){
        currentDataURL = [self createDataUrlWithType:PLACE_TYPE_SPA withInDistance:currentSelectedRange];
    }else if ([userAction.title isEqualToString:PLACE_TYPE_RESTAURANT]){
        currentDataURL = [self createDataUrlWithType:PLACE_TYPE_RESTAURANT withInDistance:currentSelectedRange];
    }else if([userAction.title isEqualToString:@"All"]){
        currentDataURL = [self createDataUrlWithType:PLACE_TYPE_ALL withInDistance:currentSelectedRange];
    }
    currentSelectedPlaceType = userAction.title;
    [self loadDatafromUrl:currentDataURL];
}

-(void)showPlacesInRange:(UIAlertAction *)userAction{
    NSString *rangeDataURL;
    if ([userAction.title isEqualToString:@"< 1 KM"]) {
        currentSelectedRange=@"1000";
        rangeDataURL = [self createDataUrlWithType:currentSelectedPlaceType withInDistance:@"1000"];
    }else if ([userAction.title isEqualToString:@"< 5 KM"]){
        currentSelectedRange=@"5000";
        rangeDataURL = [self createDataUrlWithType:currentSelectedPlaceType withInDistance:@"5000"];
    }else if ([userAction.title isEqualToString:@"< 10 KM"]){
        currentSelectedRange=@"10000";
        rangeDataURL = [self createDataUrlWithType:currentSelectedPlaceType withInDistance:@"10000"];
    }else if ([userAction.title isEqualToString:@"< 20 KM"]){
        currentSelectedRange=@"20000";
        rangeDataURL = [self createDataUrlWithType:currentSelectedPlaceType withInDistance:@"20000"];
    }else if ([userAction.title isEqualToString:@"< 50 KM"]){
        currentSelectedRange=@"50000";
        rangeDataURL = [self createDataUrlWithType:currentSelectedPlaceType withInDistance:@"50000"];
    }
    [self loadDatafromUrl:rangeDataURL];
    
}


-(void)loadViews{
    self.navigationItem.title =@"Places Around";
    typeFilterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [typeFilterButton setFrame:CGRectMake(self.view.bounds.origin.x+0.1*self.view.bounds.size.width, 70, 100, 50)];
    [typeFilterButton setTitle:@"Place Type" forState:UIControlStateNormal];
    [typeFilterButton addTarget:self action:@selector(typeFilterButtonClikced) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:typeFilterButton];
    
    rangeFilterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rangeFilterButton setFrame:CGRectMake(self.view.bounds.origin.x+0.7*self.view.bounds.size.width, 70, 100, 50)];
    [rangeFilterButton setTitle:@"In Range" forState:UIControlStateNormal];
    [rangeFilterButton addTarget:self action:@selector(rangeFilterButtonClikced) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rangeFilterButton];
    
    
    placesTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.size.height-180) style:UITableViewStylePlain];
    placesTableView.delegate=self;
    placesTableView.dataSource=self;
    [self.view addSubview:placesTableView];
}

#pragma Alert related methods

-(void)typeFilterButtonClikced{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *allPlaces = [UIAlertAction actionWithTitle:@"All"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          [self showPlacesWithType:action];
                                                      }];
    UIAlertAction *foodPlaces = [UIAlertAction actionWithTitle:PLACE_TYPE_FOOD
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
                                                            [self showPlacesWithType:action];
                                                            }];
    UIAlertAction *gymPlaces = [UIAlertAction actionWithTitle:PLACE_TYPE_GYM
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
                                                            [self showPlacesWithType:action];
                                                        }];
    
    UIAlertAction *schoolPlaces = [UIAlertAction actionWithTitle:PLACE_TYPE_SCHOOL
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
                                                            [self showPlacesWithType:action];
                                                        }];

    UIAlertAction *hospitalPlaces = [UIAlertAction actionWithTitle:PLACE_TYPE_HOSPITAL
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
                                                            [self showPlacesWithType:action];
                                                        }];
    UIAlertAction *spaPlaces = [UIAlertAction actionWithTitle:PLACE_TYPE_SPA
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
                                                            [self showPlacesWithType:action];
                                                        }];
    UIAlertAction *restaurantPlaces = [UIAlertAction actionWithTitle:PLACE_TYPE_RESTAURANT
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
                                                            [self showPlacesWithType:action];
                                                        }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action) {
                                        [alertController dismissViewControllerAnimated:YES completion:nil];
                                                             }];
    [alertController addAction:allPlaces];
    [alertController addAction:foodPlaces];
    [alertController addAction:gymPlaces];
    [alertController addAction:schoolPlaces];
    [alertController addAction:hospitalPlaces];
    [alertController addAction:spaPlaces];
    [alertController addAction:restaurantPlaces];
    [alertController addAction:cancel];
    [alertController setModalPresentationStyle:UIModalPresentationPopover];
    UIPopoverPresentationController *popPresenter = [alertController
                                                     popoverPresentationController];
    popPresenter.sourceView = typeFilterButton;
    popPresenter.sourceRect = typeFilterButton.bounds;
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)rangeFilterButtonClikced{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *range1 = [UIAlertAction actionWithTitle:@"< 1 KM"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          [self showPlacesInRange:action];
                                                      }];
    UIAlertAction *range2 = [UIAlertAction actionWithTitle:@"< 5 KM"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
                                                           [self showPlacesInRange:action];
                                                       }];
    UIAlertAction *range3 = [UIAlertAction actionWithTitle:@"< 10 KM"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          [self showPlacesInRange:action];
                                                      }];
    
    UIAlertAction *range4 = [UIAlertAction actionWithTitle:@"< 20 KM"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action) {
                                                           [self showPlacesInRange:action];
                                                         }];
    
    UIAlertAction *range5 = [UIAlertAction actionWithTitle:@"< 50 KM"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action) {
                                                            [self showPlacesInRange:action];
                                                           }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       [alertController dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    [alertController addAction:range1];
    [alertController addAction:range2];
    [alertController addAction:range3];
    [alertController addAction:range4];
    [alertController addAction:range5];
    [alertController addAction:cancel];
    [alertController setModalPresentationStyle:UIModalPresentationPopover];
    UIPopoverPresentationController *popPresenter = [alertController
                                                     popoverPresentationController];
    popPresenter.sourceView = rangeFilterButton;
    popPresenter.sourceRect = rangeFilterButton.bounds;
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

-(void)showAlertWithMessage:(NSString *)message withTitle:(NSString *)alertTitle{
    UIAlertView *dataUpdateErrorAlert = [[UIAlertView alloc]initWithTitle:alertTitle message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [dataUpdateErrorAlert show];
}

#pragma mark - location manager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    if (!isUserLocationUpdated) {
        userLongitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
        userLatitude = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
        NSLog(@"user co-cordinates are %@,%@",[NSString stringWithFormat:@"%f", location.coordinate.latitude],[NSString stringWithFormat:@"%f", location.coordinate.longitude]);
        isUserLocationUpdated = !isUserLocationUpdated;
        [self loadDatafromUrl:[self createDataUrlWithType:currentSelectedPlaceType withInDistance:currentSelectedRange]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tableview DataSource Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return placeDataArray.count;
};

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier=@"flightCell";
    PlaceTableViewCell *placeDataCell;
    placeDataCell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (placeDataCell == nil) {
        placeDataCell = [[PlaceTableViewCell alloc]initPlaceCellWithObject:[placeDataArray objectAtIndex:indexPath.section]];
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
    placeDetailVC.placeDetaileDataObject = [placeDataArray objectAtIndex:indexPath.section];
    [self.navigationController pushViewController:placeDetailVC animated:YES];
}


#pragma mark - Cell Delegate Methods

-(void)goToMapViewWithObject:(PlaceDataObject *)placeObject{
    MapViewController *mapView = [[MapViewController alloc]init];
    mapView.dataObject=placeObject;
    [self.navigationController pushViewController:mapView animated:YES];
}


-(void)checkIfUserLocationUpdatedAndShowDataAccordingly{
    if (!isUserLocationUpdated) {
        [self loadDatafromUrl:[self createDataUrlWithType:currentSelectedPlaceType withInDistance:currentSelectedRange]];
    }
}

@end
