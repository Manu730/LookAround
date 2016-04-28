//
//  AsyncHttpRequestObject.h
//  BmsPlaces
//
//  Created by Manoj Kumar on 27/04/16.
//  Copyright © 2016 bms. All rights reserved.
//


#import <Foundation/Foundation.h>
typedef void (^requestCallBack)(void);
@interface AsyncHttpRequestObject : NSObject<NSURLConnectionDataDelegate>
@property(strong,nonatomic) NSError *error;
@property(strong,nonatomic) NSMutableData *responseData;
@property(strong,nonatomic) NSHTTPURLResponse *response;
@property(copy,nonatomic) requestCallBack successCallBack;
@property(copy,nonatomic) requestCallBack failureCallBack;

- (id)initWithRequest:(NSURLRequest *)request withSuccessCallBack:(requestCallBack)sucessCallBack withFailureCallBack:(requestCallBack)failureCallBack;
- (void)start;
- (void)stop;
- (void)clear;
@end

