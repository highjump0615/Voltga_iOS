//
//  NetAPIClient.h
//
//  Created by iDeveloper on 7/6/13.
//  Copyright (c) 2013 iDevelopers. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"
#import "WebConfig.h"

typedef enum {
    MediaTypePhoto = 0,
    MediaTypeVideo,
    MediaTypeAudio
} MediaType;

@interface NetAPIClient : AFHTTPSessionManager

+ (NetAPIClient *)sharedClient;

// send text data
- (void)sendToServiceByPOST:(NSString *)serviceAPIURL
               params:(NSDictionary*)_params
              success:(void (^)(id _responseObject))_success
              failure:(void (^)(NSError* _error))_failure;

//send photo/video data
- (void)sendToServiceByPOST:(NSString *)serviceAPIURL
                     params:(NSDictionary *)_params
                      media:(NSData* )_media
                media_thumb:(NSData* )_media_thumb
                  mediaType:(MediaType)_mediaType // 0: photo, 1: video 2: audio
                    success:(void (^)(id _responseObject))_success
                    failure:(void (^)(NSError* _error))_failure
                   progress:(void(^)(NSUInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite))_progress;

// get text data
- (void)sendToServiceByGET:(NSString *)serviceAPIURL
                    params:(NSDictionary* )_params
                   success:(void (^)(id _responseObject))_success
                   failure:(void (^)(NSError* _error))_failure;
@end
