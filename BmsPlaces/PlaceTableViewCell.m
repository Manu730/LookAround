//
//  PlaceTableViewCell.m
//  BmsPlaces
//
//  Created by Manoj Kumar on 28/04/16.
//  Copyright © 2016 bms. All rights reserved.
//

#import "PlaceTableViewCell.h"
#import "Utilities.h"
#import "Downloader.h"
#import <QuartzCore/QuartzCore.h>

@implementation PlaceTableViewCell{
    PlaceDataObject *cellDataObject;
    CGRect viewFrame;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initPlaceCellWithObject:(PlaceDataObject *)placeData{
    self = [super init];
    if (self) {
        cellDataObject = placeData;
        viewFrame = self.bounds;
        [self addViews];
    }
    return self;
}

-(void)addViews{
    NSArray *placePhotoArray = cellDataObject.photoArray;
    NSDictionary *photoDict;
    NSString *photoReference;
    
    if (placePhotoArray != nil && placePhotoArray.count>0) {
        photoDict = placePhotoArray[0];
        photoReference = [photoDict objectForKey:@"photo_reference"];
    }
    
    UIImageView *placeImage = [[UIImageView alloc]initWithFrame:CGRectMake(viewFrame.origin.x+viewFrame.size.width*0.1, 10, 100, 100)];
    placeImage.image = [UIImage imageNamed:@"default.jpg"];
    placeImage.layer.borderWidth=0.0f;
    placeImage.layer.cornerRadius = placeImage.bounds.size.width/2;
    placeImage.layer.masksToBounds=YES;
    if (photoReference!= nil && [[Utilities sharedInstance]imageExistsWithName:cellDataObject.name]) {
    placeImage.image = [UIImage imageWithContentsOfFile:[[[Utilities sharedInstance]getImageDirectoryPath] stringByAppendingPathComponent:cellDataObject.name]];
    }else if(photoReference != nil){
    [[Downloader sharedInstance]downloadImage:[[Utilities sharedInstance]getImageUrlWithPhotoReference:photoReference] andImageName:cellDataObject.name];
    }
    [self.contentView addSubview:placeImage];
    
    UILabel *placeTitle = [[UILabel alloc]initWithFrame:CGRectMake(placeImage.frame.origin.x+placeImage.frame.size.width+10, 10, 0.7*viewFrame.size.width, 60)];
    placeTitle.text = cellDataObject.name;
    placeTitle.numberOfLines=2;
    placeTitle.lineBreakMode=NSLineBreakByWordWrapping;
    placeTitle.font = [UIFont boldSystemFontOfSize:20.0];
    [self.contentView addSubview:placeTitle];
    
    UILabel *ratingLbl = [[UILabel alloc]initWithFrame:CGRectMake(placeImage.frame.origin.x+placeImage.frame.size.width+10, 90, 60, 30)];
    ratingLbl.text=@"Rating : ";
    ratingLbl.font = [UIFont boldSystemFontOfSize:15.0];
    [self.contentView addSubview:ratingLbl];
    
    UILabel *ratingVal = [[UILabel alloc]initWithFrame:CGRectMake(ratingLbl.frame.origin.x+ratingLbl.frame.size.width+10, 90, 50, 30)];
    ratingVal.text =[NSString stringWithFormat:@"%.1f",[cellDataObject.placeRating doubleValue]];
    //ratingVal.textColor = [UIColor blueColor];
    ratingVal.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:ratingVal];
    
    UIButton *goToMap = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    goToMap.frame = CGRectMake(ratingVal.frame.origin.x+ratingVal.frame.size.width+30, 90, viewFrame.size.width*0.4, 30);
    [goToMap addTarget:self action:@selector(goToMapView) forControlEvents:UIControlEventTouchUpInside];
    [goToMap setTitle:@"Show In Map" forState:UIControlStateNormal];
    [self.contentView addSubview:goToMap];
}

-(void)goToMapView{
    [self.cellDelegate goToMapViewWithObject:cellDataObject];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
