//
//  ChatObj.h
//  Voltga
//
//  Created by JackQuan on 8/6/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserObj.h"

typedef enum
{
    chatTypeText = 0,
    chatTypeImage,
    chatTypeSound,
    chatTypeBomb
}CHAT_TYPE;

@interface ChatObj : NSObject

@property (retain, nonatomic) NSNumber* chat_id;
@property (retain, nonatomic) NSNumber* chat_place_id;
@property (retain, nonatomic) NSNumber* chat_user_id;
@property (retain, nonatomic) NSString* chat_msg_id;
@property (retain, nonatomic) NSNumber* chat_type;
@property (retain, nonatomic) NSString* chat_content;
@property (retain, nonatomic) NSString* chat_media_url;
@property (retain, nonatomic) NSDate* chat_created;
@property (retain, nonatomic) NSNumber* chat_image_width;
@property (retain, nonatomic) NSNumber* chat_image_height;

@property (retain, nonatomic) UserObj* chat_user;

- (id) initEmptyObj;
- (id) initWithDict:(NSDictionary *) dict;
- (NSDictionary *) currentDict;

@end
