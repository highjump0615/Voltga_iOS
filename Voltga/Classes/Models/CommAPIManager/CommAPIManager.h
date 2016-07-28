//
//  CommAPIManager.h
//  Voltga
//
//  Created by JackQuan on 8/6/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WebConfig.h"
#import "NetAPIClient.h"

#import "PlaceObj.h"
#import "UserObj.h"
#import "ChatObj.h"
#import "NotificationObj.h"
#import "RelationObj.h"
#import "PictureObj.h"

@interface CommAPIManager : NSObject

+ (CommAPIManager *)sharedCommAPIManager;

- (void)userSignInWithUserEmail:(NSString*)user_email
                   UserPassword:(NSString*)user_password
                      UserToken:(NSString*)user_token
                      successed:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;

- (void)userSignUpWithUserName:(NSString*)user_name
                      UserEmail:(NSString*)user_email
                   UserPassword:(NSString*)user_password
                      UserToken:(NSString*)user_token
                    PublicPhoto:(NSData*)public_photo
              PublicPhotoThumb:(NSData*)public_photo_thumb
                      successed:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;

- (void)getUserWithUserID:(NSString*)user_id
                successed:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

- (void)getPasswordWithUserEmail:(NSString*)user_email
                       successed:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;

- (void)saveUserProfileWithUserObj:(UserObj*)userobj
                        successed:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;

- (void)uploadePublicPhotoWithUserName:(NSString*)user_name
                          oldPhotoName:(NSString*)user_public_photo_old
                           PublicPhoto:(NSData*)public_photo
                      PublicPhotoThumb:(NSData*)public_photo_thumb
                             successed:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure;

- (void)uploadePrivatePhotoWithUserName:(NSString*)user_name
                           oldPhotoName:(NSString*)user_private_photo_old
                             PhotoIndex:(NSString*)photo_index
                           PrivatePhoto:(NSData*)private_photo
                      PrivatePhotoThumb:(NSData*)private_photo_thumb
                              successed:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure;

- (void)getPlacesWithsuccessed:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;

- (void)setCurrentPlaceWithUserID:(NSString*)user_id
                          PlaceID:(NSString*)place_id
                        successed:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;

- (void)getPeopleWithUserID:(NSString*)user_id
                    PlaceID:(NSString*)place_id
                  successed:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;

- (void)likeWithUserID:(NSString*)user_id
              userName:(NSString*)user_name
            OpponentID:(NSString*)opponent_id
               PlaceID:(NSString*)place_id
           NotifyValue:(NSString*)notify_value
             successed:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure;

- (void)unlockWithUserID:(NSString*)user_id
                userName:(NSString*)user_name
              OpponentID:(NSString*)opponent_id
                 PlaceID:(NSString*)place_id
             NotifyValue:(NSString*)notify_value
              UnlockType:(NSString*)unlock_type
               successed:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;

- (void)blockWithUserID:(NSString*)user_id
             OpponentID:(NSString*)opponent_id
                PlaceID:(NSString*)place_id
            NotifyValue:(NSString*)notify_value
              BlockType:(NSString*)block_type
              successed:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;

- (void)addNotificationWithUserID:(NSString*)user_id
                       OpponentID:(NSString*)opponent_id
                          PlaceID:(NSString*)place_id
                 NotificationType:(NSString*)notification_type
                        successed:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;

- (void)getBadgesWithUserID:(NSString*)user_id
                    PlaceID:(NSString*)place_id
                  successed:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;

- (void)removeBadgesWithUserID:(NSString*)user_id
                       PlaceID:(NSString*)place_id
                     successed:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;

- (void)getNotificationsWithUserID:(NSString*)user_id
                           PlaceID:(NSString*)place_id
                         successed:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;

- (void)getAllChatsWithUserID:(NSString*)user_id
                      PlaceID:(NSString*)place_id
                   BaseChatID:(NSString*)base_id
                    successed:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;

- (void)uploadMediaOnlyWithUserID:(NSString*)user_id
                          PlaceID:(NSString*)place_id
                        MediaType:(MediaType)media_type
                        MediaData:(NSData*)media_data
                        successed:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;

- (void)sendChatWithChatObj:(ChatObj*)chat_obj
                  successed:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;

- (void)getBaseChatNoWithPlaceID:(NSString*)place_id
                          BaseNo:(NSString*)base_no
                       successed:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;

- (void)setUserOnlineWithUserID:(NSNumber*)user_id
                    OnlineState:(NSNumber*)bState
                      successed:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;




@end
