//
//  UserObj.h
//  Voltga
//
//  Created by JackQuan on 8/6/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

typedef enum {
    NotificationValue_IsUnlock   = 0x1,          // 0: Lock,     1: UnLock
    NotificationValue_IsBlock    = 0x2          // 0: UnBlock,  1: Block
} NotificationValue;

typedef enum {
    NotificationType_Mention   = 0x1,
    NotificationType_Unlock    = 0x2,
    NotificationType_Like      = 0x3
} NotificationType;


#import <Foundation/Foundation.h>

@interface UserObj : NSObject

@property (retain, nonatomic) NSNumber*         user_id;
@property (retain, nonatomic) NSString*         user_name;
@property (retain, nonatomic) NSNumber*         user_age;
@property (retain, nonatomic) NSString*         user_height;
@property (retain, nonatomic) NSNumber*         user_weight;
@property (retain, nonatomic) NSString*         user_ethnicity;
@property (retain, nonatomic) NSString*         user_body;
@property (retain, nonatomic) NSString*         user_practice;
@property (retain, nonatomic) NSString*         user_intro;
@property (retain, nonatomic) NSString*         user_status;
@property (retain, nonatomic) NSString*         user_phone;
@property (retain, nonatomic) NSString*         user_password;
@property (retain, nonatomic) NSString*         user_email;
@property (retain, nonatomic) NSNumber*         user_is_active;
@property (retain, nonatomic) NSNumber*         user_place_id;

@property (retain, nonatomic) NSString*         user_public_photo;
@property (retain, nonatomic) NSString*         user_private_photo1;
@property (retain, nonatomic) NSString*         user_private_photo2;
@property (retain, nonatomic) NSString*         user_private_photo3;


//@property (retain, nonatomic) NSMutableArray*   user_privatepicture;    // in photo table

@property (retain, nonatomic) NSNumber*         user_relation_to;       // self to other
@property (retain, nonatomic) NSNumber*         user_relation_from;     // other to self


- (id) initEmptyObj;
- (id) initWithDict:(NSDictionary *) dict;
- (NSDictionary *) currentDict;

- (BOOL)blockedByMe;
- (BOOL)likedByMe;
- (BOOL)lockedByMe;
- (BOOL)mentionedByMe;

- (BOOL)blockedMe;
- (BOOL)likedMe;
- (BOOL)lockedMe;
- (BOOL)mentionedMe;


@end
