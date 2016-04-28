//
//  MapViewController.m
//  BmsPlaces
//
//  Created by Manoj Kumar on 28/04/16.
//  Copyright © 2016 bms. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController ()

@end

@implementation MapViewController{
    MKMapView *locationMapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"Map";
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [self showMapView];
}

-(void)showMapView{
    NSDictionary *location = [self.dataObject.geometry objectForKey:@"location"];
    NSNumber *latitude = [location objectForKey:@"lat"];
    NSNumber *longitude = [location objectForKey:@"lng"];
    locationMapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    locationMapView.mapType = MKMapTypeHybrid;
    
    CLLocationCoordinate2D coord = {.latitude =  [latitude doubleValue], .longitude =  [longitude doubleValue]};
    MKCoordinateSpan span = {.latitudeDelta =  0.2, .longitudeDelta =  0.2};
    MKCoordinateRegion region = {coord, span};
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    [annotation setCoordinate:coord];
    [annotation setTitle:self.dataObject.name];
    [locationMapView addAnnotation:annotation];
    [locationMapView setRegion:region];
    [self.view addSubview:locationMapView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
