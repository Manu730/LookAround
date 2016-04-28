//
//  PlaceDetailViewController.m
//  BmsPlaces
//
//  Created by Manoj Kumar on 28/04/16.
//  Copyright © 2016 bms. All rights reserved.
//

#import "PlaceDetailViewController.h"
#import "Utilities.h"
#import "Downloader.h"
#import "MapViewController.h"
#import "DBManager.h"

@interface PlaceDetailViewController ()
@end

@implementation PlaceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"Place Details";
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    self.view.backgroundColor = [UIColor whiteColor];
    [self addPlaceImage];
    [self addOtherViews];
}

-(void)addPlaceImage{
    UIImageView *myPlaceImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height*0.6)];
    myPlaceImage.image = [UIImage imageNamed:@"default.jpg"];
    NSArray *placePhotoArray = self.placeDetaileDataObject.photoArray;
    NSDictionary *photoDict; //= placePhotoArray[0];
    NSString *photoReference; //= [photoDict objectForKey:@"photo_reference"];
    
    if (placePhotoArray != nil && placePhotoArray.count>0) {
        photoDict = placePhotoArray[0];
        photoReference = [photoDict objectForKey:@"photo_reference"];
    }
    
    if (photoReference!= nil && [[Utilities sharedInstance]imageExistsWithName:self.placeDetaileDataObject.name]) {
        myPlaceImage.image = [UIImage imageWithContentsOfFile:[[[Utilities sharedInstance]getImageDirectoryPath] stringByAppendingPathComponent:self.placeDetaileDataObject.name]];
    }else if(photoReference != nil){
        [[Downloader sharedInstance]downloadImage:[[Utilities sharedInstance]getImageUrlWithPhotoReference:photoReference] andImageName:self.placeDetaileDataObject.name];
    }
    [self.view addSubview:myPlaceImage];
}

-(void)addOtherViews{
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width*0.05, self.view.bounds.size.height*0.61, self.view.bounds.size.width*0.9, self.view.bounds.size.height*0.09)];
    title.text = self.placeDetaileDataObject.name;
    title.textAlignment=NSTextAlignmentLeft;
    title.numberOfLines=2;
    title.lineBreakMode=NSLineBreakByWordWrapping;
    title.textColor = [UIColor blackColor];
    title.font = [UIFont boldSystemFontOfSize:23.0];
    [self.view addSubview:title];

    
    UILabel *ratingLbl = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width*0.1, self.view.bounds.size.height*0.7, self.view.bounds.size.width*0.15, self.view.bounds.size.height*0.1)];
    ratingLbl.text=@"Rating : ";
    ratingLbl.font = [UIFont boldSystemFontOfSize:15.0];
    [self.view addSubview:ratingLbl];
    
    UILabel *ratingVal = [[UILabel alloc]initWithFrame:CGRectMake(ratingLbl.frame.origin.x+ratingLbl.frame.size.width+1, self.view.bounds.size.height*0.7, self.view.bounds.size.width*0.1, self.view.bounds.size.height*0.1)];
    ratingVal.text =[NSString stringWithFormat:@"%.1f",[self.placeDetaileDataObject.placeRating doubleValue]];
    ratingVal.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:ratingVal];
    
    
    UILabel *landMarkLbl = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width*0.45, self.view.bounds.size.height*0.7, self.view.bounds.size.width*0.2, self.view.bounds.size.height*0.1)];
    landMarkLbl.text=@"Address : ";
    landMarkLbl.font = [UIFont boldSystemFontOfSize:15.0];
    [self.view addSubview:landMarkLbl];
    
    UILabel *landMarkVal = [[UILabel alloc]initWithFrame:CGRectMake(landMarkLbl.frame.origin.x+landMarkLbl.frame.size.width+5, self.view.bounds.size.height*0.69, self.view.bounds.size.width*0.3, self.view.bounds.size.height*0.15)];
    landMarkVal.numberOfLines=3;
    landMarkVal.lineBreakMode=NSLineBreakByWordWrapping;
    landMarkVal.text=self.placeDetaileDataObject.placeVicinity;
    landMarkVal.font = [UIFont boldSystemFontOfSize:15.0];
    [self.view addSubview:landMarkVal];
    
    UIButton *favButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    favButton.frame = CGRectMake(self.view.bounds.size.width*0.1, self.view.bounds.size.height*0.85, 150, 30);
    [favButton addTarget:self action:@selector(savePlaceDataToLocal) forControlEvents:UIControlEventTouchUpInside];
    [favButton setTitle:@"Save As Favourite" forState:UIControlStateNormal];
    [self.view addSubview:favButton];

    UIButton *showMap = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    showMap.frame = CGRectMake(self.view.bounds.size.width*0.6, self.view.bounds.size.height*0.85, 100, 30);
    [showMap addTarget:self action:@selector(goToMapView) forControlEvents:UIControlEventTouchUpInside];
    [showMap setTitle:@"Show In Map" forState:UIControlStateNormal];
    [self.view addSubview:showMap];
}

-(void)goToMapView{
    MapViewController *mapView = [[MapViewController alloc]init];
    mapView.dataObject=self.placeDetaileDataObject;
    [self.navigationController pushViewController:mapView animated:YES];
    
}

-(void)savePlaceDataToLocal{
    [[DBManager sharedInstance]savePlaceDataObject:self.placeDetaileDataObject];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
