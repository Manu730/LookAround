//
//  AsyncHttpRequestObject.m
//  BmsPlaces
//
//  Created by Manoj Kumar on 27/04/16.
//  Copyright © 2016 bms. All rights reserved.
//


#import "AsyncHttpRequestObject.h"

@interface AsyncHttpRequestObject(){
    //NSMutableData *_responseData;
    NSURLConnection *connection;
    NSURLRequest *requestObject;
    NSOperationQueue *delegateQueue;
}
@end

@implementation AsyncHttpRequestObject


-(id)initWithRequest:(NSURLRequest *)request withSuccessCallBack:(requestCallBack)sucessCallBack withFailureCallBack:(requestCallBack)failureCallBack{
    self = [super init];
    if (self) {
        requestObject = request;
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        self.successCallBack = [sucessCallBack copy];
        self.failureCallBack = [failureCallBack copy];
        self.responseData = [[NSMutableData alloc] init];
    }
    return self;
    
}
- (void)start
{
    //NSLog(@"Current Run Loop Is %d",[NSThread isMainThread]);
    [connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [connection start];
    //NSLog(@"Started Async Http Connection %@",request_.URL.URLByStandardizingPath);
}

- (void)stop
{
    [connection cancel];
    [self clear];
    //NSLog(@"Cancelled Async Http Connection %@",request_.URL.URLByStandardizingPath);
}

- (void)clear
{
    _error = nil;
    self.responseData = nil;
    self.response = nil;
    self.successCallBack = nil;
    self.failureCallBack = nil;
    requestObject = nil;
}

#pragma mark NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.response = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.successCallBack();
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.failureCallBack();
    _error = error;
}
@end
