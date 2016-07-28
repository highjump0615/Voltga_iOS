//
//  CommAPIManager.m
//  Voltga
//
//  Created by JackQuan on 8/6/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import "CommAPIManager.h"
#import "GlobalData.h"

@implementation CommAPIManager

+ (CommAPIManager *)sharedCommAPIManager
{
    static CommAPIManager *_commAPIManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _commAPIManager = [[self alloc] init];
    });
    return _commAPIManager;
}

- (void)userSignInWithUserEmail:(NSString*)user_email
                   UserPassword:(NSString*)user_password
                      UserToken:(NSString*)user_token
                      successed:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    
    [params setObject:VOLTGA_API_SIGNIN     forKey:@"action"];
    [params setObject:user_email            forKey:@"user_email"];
    [params setObject:user_password         forKey:@"user_password"];
    [params setObject:user_token            forKey:@"user_token"];
    
    NSLog(@"Register Request Params : %@", params);
    
    //call Web Service
    [[NetAPIClient sharedClient] sendToServiceByPOST:VOLTGA_BASE_URL
                                              params:params
                                             success:success
                                             failure:failure];
    
}

- (void)userSignUpWithUserName:(NSString*)user_name
                     UserEmail:(NSString*)user_email
                  UserPassword:(NSString*)user_password
                     UserToken:(NSString*)user_token
                   PublicPhoto:(NSData*)public_photo
              PublicPhotoThumb:(NSData*)public_photo_thumb
                     successed:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    //set Parameters
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    
    [params setObject:VOLTGA_API_SIGNUP     forKey:@"action"];
    [params setObject:user_name             forKey:@"user_name"];
    [params setObject:user_email            forKey:@"user_email"];
    [params setObject:user_password         forKey:@"user_password"];
    [params setObject:user_token            forKey:@"user_token"];

    NSLog(@"Register Request Params : %@", params);
    
    //call Web Service
    [[NetAPIClient sharedClient] sendToServiceByPOST:VOLTGA_BASE_URL
                                              params:params
                                               media:public_photo
                                         media_thumb:public_photo_thumb
                                           mediaType:MediaTypePhoto
                                             success:success
                                             failure:failure
                                            progress:nil];
}

-(void) getUserWithUserID:(NSString*)user_id
                successed:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure{
    
    
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    
    [params setObject:VOLTGA_API_GETUSER    forKey:@"action"];
    [params setObject:user_id             forKey:@"user_id"];
    
    NSLog(@"Register Request Params : %@", params);
    
    //call Web Service
    [[NetAPIClient sharedClient] sendToServiceByPOST:VOLTGA_BASE_URL
                                              params:params
                                             success:success
                                             failure:failure];
}

- (void)setUserOnlineWithUserID:(NSNumber*)user_id
                    OnlineState:(NSNumber*)bState
                      successed:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    
    [params setObject:VOLTGA_API_SETONLINESTATE                 forKey:@"action"];
    [params setObject:user_id                                   forKey:@"user_id"];
    [params setObject:bState                                    forKey:@"user_is_active"];
    
    NSLog(@"Register Request Params : %@", params);
    
    //call Web Service
    [[NetAPIClient sharedClient] sendToServiceByPOST:VOLTGA_BASE_URL
                                              params:params
                                             success:success
                                             failure:failure];
    
}


- (void)getPasswordWithUserEmail:(NSString*)user_email
                       successed:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    
    [params setObject:VOLTGA_API_GETPASSWORD    forKey:@"action"];
    [params setObject:user_email                forKey:@"user_email"];
    
    NSLog(@"Register Request Params : %@", params);
    
    //call Web Service
    [[NetAPIClient sharedClient] sendToServiceByPOST:VOLTGA_BASE_URL
                                              params:params
                                             success:success
                                             failure:failure];
    
    
}

-(void)saveUserProfileWithUserObj:(UserObj*)userobj
                        successed:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] initWithDictionary:userobj.currentDict];
    
    [params setObject:VOLTGA_API_SAVEUSERPROFILE    forKey:@"action"];
    
    NSLog(@"Register Request Params : %@", params);
    
    //call Web Service
    [[NetAPIClient sharedClient] sendToServiceByPOST:VOLTGA_BASE_URL
                                              params:params
                                             success:success
                                             failure:failure];
    
    
}

- (void)uploadePublicPhotoWithUserName:(NSString*)user_name
                          oldPhotoName:(NSString*)user_public_photo_old
                           PublicPhoto:(NSData*)public_photo
                      PublicPhotoThumb:(NSData*)public_photo_thumb
                             successed:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure{

    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    
    [params setObject:VOLTGA_API_UPLOADPUBLICPHOTO      forKey:@"action"];
    [params setObject:user_name                         forKey:@"user_name"];
    [params setObject:user_public_photo_old             forKey:@"user_public_photo"];
    
    NSLog(@"Register Request Params : %@", params);
    
    //call Web Service
    [[NetAPIClient sharedClient] sendToServiceByPOST:VOLTGA_BASE_URL
                                              params:params
                                               media:public_photo
                                         media_thumb:public_photo_thumb
                                           mediaType:MediaTypePhoto
                                             success:success
                                             failure:failure
                                            progress:nil];
    
}

- (void)uploadePrivatePhotoWithUserName:(NSString*)user_name
                           oldPhotoName:(NSString*)user_private_photo_old
                             PhotoIndex:(NSString*)photo_index
                           PrivatePhoto:(NSData*)private_photo
                      PrivatePhotoThumb:(NSData*)private_photo_thumb
                              successed:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure
{
    
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    
    [params setObject:VOLTGA_API_UPLOADPRIVATEPHOTO     forKey:@"action"];
    [params setObject:user_name                         forKey:@"user_name"];
    [params setObject:photo_index                       forKey:@"photo_index"];
    [params setObject:user_private_photo_old            forKey:@"user_private_photo"];
    
    NSLog(@"Register Request Params : %@", params);
    
    //call Web Service
    [[NetAPIClient sharedClient] sendToServiceByPOST:VOLTGA_BASE_URL
                                              params:params
                                               media:private_photo
                                         media_thumb:private_photo_thumb
                                           mediaType:MediaTypePhoto
                                             success:success
                                             failure:failure
                                            progress:nil];
    
}

- (void)getPlacesWithsuccessed:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    GlobalData *gData = [GlobalData sharedData];
    
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    
    [params setObject:VOLTGA_API_GETPLACES      forKey:@"action"];
//    [params setObject:gData.g_strState          forKey:@"place_state"];
    
//    if (gData.g_currentLocation)
//    {
        [params setObject:[NSNumber numberWithDouble:39.26]   forKey:@"place_latitude"];
        [params setObject:[NSNumber numberWithDouble:115.25]  forKey:@"place_longitude"];

//        [params setObject:[NSNumber numberWithDouble:gData.g_currentLocation.coordinate.latitude]   forKey:@"place_latitude"];
//        [params setObject:[NSNumber numberWithDouble:gData.g_currentLocation.coordinate.longitude]  forKey:@"place_longitude"];
//    }
    
    NSLog(@"Register Request Params : %@", params);
    
    //call Web Service
    [[NetAPIClient sharedClient] sendToServiceByPOST:VOLTGA_BASE_URL
                                              params:params
                                             success:success
                                             failure:failure];
}

- (void)setCurrentPlaceWithUserID:(NSString*)user_id
                          PlaceID:(NSString*)place_id
                        successed:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    
    [params setObject:VOLTGA_API_SETCURRENTPLACE    forKey:@"action"];
    [params setObject:user_id                       forKey:@"user_id"];
    [params setObject:place_id                      forKey:@"place_id"];

    
    NSLog(@"Register Request Params : %@", params);
    
    //call Web Service
    [[NetAPIClient sharedClient] sendToServiceByPOST:VOLTGA_BASE_URL
                                              params:params
                                             success:success
                                             failure:failure];
}

- (void)getPeopleWithUserID:(NSString*)user_id
                    PlaceID:(NSString*)place_id
                  successed:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    
    [params setObject:VOLTGA_API_GETPEOPLE          forKey:@"action"];
    [params setObject:user_id                       forKey:@"user_id"];
    [params setObject:place_id                      forKey:@"place_id"];
    
    
    NSLog(@"Register Request Params : %@", params);
    
    //call Web Service
    [[NetAPIClient sharedClient] sendToServiceByPOST:VOLTGA_BASE_URL
                                              params:params
                                             success:success
                                             failure:failure];
}

- (void)likeWithUserID:(NSString*)user_id
              userName:(NSString*)user_name
            OpponentID:(NSString*)opponent_id
               PlaceID:(NSString*)place_id
           NotifyValue:(NSString*)notify_value
             successed:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    
    [params setObject:VOLTGA_API_LIKEUSER           forKey:@"action"];
    [params setObject:user_id                       forKey:@"user_id"];
    [params setObject:user_name                     forKey:@"user_name"];
    [params setObject:opponent_id                   forKey:@"opponent_id"];
    [params setObject:place_id                      forKey:@"place_id"];
    [params setObject:notify_value                  forKey:@"notify_value"];
    
    NSLog(@"Like User Params : %@", params);
    
    //call Web Service
    [[NetAPIClient sharedClient] sendToServiceByPOST:VOLTGA_BASE_URL
                                              params:params
                                             success:success
                                             failure:failure];
}

- (void)unlockWithUserID:(NSString*)user_id
                userName:(NSString*)user_name
              OpponentID:(NSString*)opponent_id
                 PlaceID:(NSString*)place_id
             NotifyValue:(NSString*)notify_value
              UnlockType:(NSString*)unlock_type
               successed:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    
    [params setObject:VOLTGA_API_UNLOCKUSER         forKey:@"action"];
    [params setObject:user_id                       forKey:@"user_id"];
    [params setObject:user_name                     forKey:@"user_name"];
    [params setObject:opponent_id                   forKey:@"opponent_id"];
    [params setObject:place_id                      forKey:@"place_id"];
    [params setObject:notify_value                  forKey:@"notify_value"];
    [params setObject:unlock_type                   forKey:@"unlock_type"];
    
    NSLog(@"Unlock User Params : %@", params);
    
    //call Web Service
    [[NetAPIClient sharedClient] sendToServiceByPOST:VOLTGA_BASE_URL
                                              params:params
                                             success:success
                                             failure:failure];
}

- (void)blockWithUserID:(NSString*)user_id
             OpponentID:(NSString*)opponent_id
                PlaceID:(NSString*)place_id
            NotifyValue:(NSString*)notify_value
              BlockType:(NSString*)block_type
              successed:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    
    [params setObject:VOLTGA_API_BLOCKUSER          forKey:@"action"];
    [params setObject:user_id                       forKey:@"user_id"];
    [params setObject:opponent_id                   forKey:@"opponent_id"];
    [params setObject:place_id                      forKey:@"place_id"];
    [params setObject:notify_value                  forKey:@"notify_value"];
    [params setObject:block_type                    forKey:@"block_type"];
    
    NSLog(@"Unlock User Params : %@", params);
    
    //call Web Service
    [[NetAPIClient sharedClient] sendToServiceByPOST:VOLTGA_BASE_URL
                                              params:params
                                             success:success
                                             failure:failure];
}


- (void)addNotificationWithUserID:(NSString*)user_id
                       OpponentID:(NSString*)opponent_id
                          PlaceID:(NSString*)place_id
                 NotificationType:(NSString*)notification_type
                        successed:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    
    [params setObject:VOLTGA_API_ADDNOTIFICATION    forKey:@"action"];
    [params setObject:user_id                       forKey:@"user_id"];
    [params setObject:opponent_id                   forKey:@"opponent_id"];
    [params setObject:place_id                      forKey:@"place_id"];
    [params setObject:notification_type             forKey:@"notification_type"];
    
    
    NSLog(@"Register Request Params : %@", params);
    
    //call Web Service
    [[NetAPIClient sharedClient] sendToServiceByPOST:VOLTGA_BASE_URL
                                              params:params
                                             success:success
                                             failure:failure];
}

- (void)getBadgesWithUserID:(NSString*)user_id
                    PlaceID:(NSString*)place_id
                  successed:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure{
    
    
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    
    [params setObject:VOLTGA_API_GETBADGES          forKey:@"action"];
    [params setObject:user_id                       forKey:@"user_id"];
    [params setObject:place_id                      forKey:@"place_id"];
    
    
    NSLog(@"Register Request Params : %@", params);
    
    //call Web Service
    [[NetAPIClient sharedClient] sendToServiceByPOST:VOLTGA_BASE_URL
                                              params:params
                                             success:success
                                             failure:failure];

}

- (void)removeBadgesWithUserID:(NSString*)user_id
                       PlaceID:(NSString*)place_id
                     successed:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    
    [params setObject:VOLTGA_API_REMOVEBADGES       forKey:@"action"];
    [params setObject:user_id                       forKey:@"user_id"];
    [params setObject:place_id                      forKey:@"place_id"];
    
    
    NSLog(@"Register Request Params : %@", params);
    
    //call Web Service
    [[NetAPIClient sharedClient] sendToServiceByPOST:VOLTGA_BASE_URL
                                              params:params
                                             success:success
                                             failure:failure];
    
    
}

- (void)getNotificationsWithUserID:(NSString*)user_id
                           PlaceID:(NSString*)place_id
                         successed:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    
    [params setObject:VOLTGA_API_GETNOTIFICATIONS   forKey:@"action"];
    [params setObject:user_id                       forKey:@"user_id"];
    [params setObject:place_id                      forKey:@"place_id"];
    
    
    NSLog(@"Register Request Params : %@", params);
    
    //call Web Service
    [[NetAPIClient sharedClient] sendToServiceByPOST:VOLTGA_BASE_URL
                                              params:params
                                             success:success
                                             failure:failure];
    
}

- (void)getAllChatsWithUserID:(NSString*)user_id
                      PlaceID:(NSString*)place_id
                   BaseChatID:(NSString*)base_id
                    successed:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    
    [params setObject:VOLTGA_API_GETALLCHATS        forKey:@"action"];
    [params setObject:user_id                       forKey:@"user_id"];
    [params setObject:place_id                      forKey:@"place_id"];
    [params setObject:base_id                       forKey:@"base_id"];
    
    
    NSLog(@"Register Request Params : %@", params);
    
    //call Web Service
    [[NetAPIClient sharedClient] sendToServiceByPOST:VOLTGA_BASE_URL
                                              params:params
                                             success:success
                                             failure:failure];
    
    
}

- (void)uploadMediaOnlyWithUserID:(NSString*)user_id
                          PlaceID:(NSString*)place_id
                        MediaType:(MediaType)media_type
                        MediaData:(NSData*)media_data
                        successed:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure{
    
    
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    
    [params setObject:VOLTGA_API_UPLOADMEDIAONLY    forKey:@"action"];
    [params setObject:user_id                       forKey:@"user_id"];
    [params setObject:place_id                      forKey:@"place_id"];
    
    
    NSLog(@"Register Request Params : %@", params);
    
    //call Web Service
    [[NetAPIClient sharedClient] sendToServiceByPOST:VOLTGA_BASE_URL
                                              params:params
                                               media:media_data
                                         media_thumb:nil
                                           mediaType:media_type
                                             success:success
                                             failure:failure
                                            progress:nil];
    
}

- (void)sendChatWithChatObj:(ChatObj*)chat_obj
                  successed:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] initWithDictionary:[chat_obj currentDict]];
    
    [params setObject:VOLTGA_API_SENDCHAT        forKey:@"action"];
    [params setObject:chat_obj.chat_user.user_name forKey:@"chat_user_name"];
    
    NSLog(@"Register Request Params : %@", params);
    
    //call Web Service
    [[NetAPIClient sharedClient] sendToServiceByPOST:VOLTGA_BASE_URL
                                              params:params
                                             success:success
                                             failure:failure];
}

- (void)getBaseChatNoWithPlaceID:(NSString*)place_id
                          BaseNo:(NSString*)base_no
                       successed:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure{
    
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    
    [params setObject:VOLTGA_API_GETBASECHATNO      forKey:@"action"];
    [params setObject:place_id                      forKey:@"place_id"];
    [params setObject:base_no                       forKey:@"base_no"];
    
    
    NSLog(@"Register Request Params : %@", params);
    
    //call Web Service
    [[NetAPIClient sharedClient] sendToServiceByPOST:VOLTGA_BASE_URL
                                              params:params
                                             success:success
                                             failure:failure];
    
}


@end
