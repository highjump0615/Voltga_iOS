	//
//  NetAPIClient.m
//
//  Created by iDeveloper on 7/6/13.
//  Copyright (c) 2013 iDevelopers. All rights reserved.
//

#import "NetAPIClient.h"
#import "AppDelegate.h"

//static NSString * const kNetAPIBaseURLString = @"http://...";

@implementation NetAPIClient

+ (NetAPIClient *)sharedClient
{
    __strong static NetAPIClient* _sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedClient = [[NetAPIClient alloc] init];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    });
    return _sharedClient;
    
}

- (id)init
{
    self = [super init];
    
    if (self) {
        
    }
    
    return self ;
}

#pragma mark - Web Service

// send text data
- (void)sendToServiceByPOST:(NSString *)serviceAPIURL
               params:(NSDictionary *)_params
              success:(void (^)(id _responseObject))_success
              failure:(void (^)(NSError *_error))_failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/json", @"application/json", nil];

    NSDictionary *parameters = _params;
    
    [manager POST:serviceAPIURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        // Success ;
        if (_success)
        {
            _success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog( @"Error : %@", error.description ) ;
        NSLog( @"failure response: %@", operation.responseString);
        // Failture ;
        if (_failure) {
            _failure(error);
        }
    }];
}


// get text data
- ( void ) sendToServiceByGET : (NSString *) serviceAPIURL
                      params  : ( NSDictionary* ) _params
                      success : ( void (^)( id _responseObject ) ) _success
                      failure : ( void (^)( NSError* _error ) ) _failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/json", @"application/json", nil];
    [manager GET:serviceAPIURL parameters:_params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appdelegate setBackgroundInvalid];
        
        // Success ;
        if (_success) {
            _success(responseObject);
        }
        
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appdelegate setBackgroundInvalid];
        
        NSLog( @"Error : %@", error.description ) ;
        NSLog(@"Respong: %@", operation.responseString);
        // Failture ;
        if (_failure) {
            _failure(error);
        }
    }];
}

//send photo/video data

- (void)sendToServiceByPOST:(NSString *)serviceAPIURL
               params:(NSDictionary *)_params
                media:(NSData* )_media
          media_thumb:(NSData* )_media_thumb
            mediaType:(MediaType)_mediaType // 0: photo, 1: video 2: audio
                    success:(void (^)(id _responseObject))_success
                    failure:(void (^)(NSError* _error))_failure
                   progress:(void(^)(NSUInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite))_progress
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/json", @"application/json", nil];
    NSDictionary *parameters = _params;

    AFHTTPRequestOperation* operation =
    [manager POST:serviceAPIURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        if (_media)
        {
            if (_mediaType == MediaTypePhoto)
            {
                [formData appendPartWithFileData:_media
                                              name:@"photo"
                                          fileName:@"photo"
                                          mimeType:@"image/jpeg" ] ;
                
                if (_media_thumb)
                {
                    [formData appendPartWithFileData:_media_thumb
                                                name:@"photo_thumb"
                                            fileName:@"photo_thumb"
                                            mimeType:@"image/jpeg" ] ;
                }
            }
            else if(_mediaType == MediaTypeVideo)
            {
                [formData appendPartWithFileData:_media
                                              name:@"video"
                                          fileName:@"video"
                                          mimeType:@"video/quicktime"];
            }
            else if(_mediaType == MediaTypeAudio)
            {
                [formData appendPartWithFileData:_media
                                            name:@"audio"
                                        fileName:@"audio"
                                        mimeType:@"audio/quicktime"];
            }
        }
    }
    success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog( @"response : %@", responseObject ) ;
        // Success ;
        if (_success)
        {
            _success(responseObject);
        }
        
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog( @"Error : %@", error.description ) ;
        NSLog(@"Respong: %@", operation.responseString);
        
        // Failture ;
        if (_failure) {
            _failure(error);
        }
    }];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Progress");
        if(_progress){
            _progress(bytesWritten, (NSInteger)totalBytesWritten, (NSInteger)totalBytesExpectedToWrite);
        }
        
    }];

}


@end
