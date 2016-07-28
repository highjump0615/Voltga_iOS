//
//  NotificationObj.h
//  Voltga
//
//  Created by JackQuan on 8/6/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserObj.h"

@interface NotificationObj : NSObject

@property (retain, nonatomic) NSNumber* notification_id;
@property (retain, nonatomic) NSNumber* notification_placeid;
@property (retain, nonatomic) NSNumber* notification_fromid;
@property (retain, nonatomic) NSNumber* notification_toid;
@property (retain, nonatomic) NSNumber* notification_type;
@property (retain, nonatomic) NSString* notification_message;
@property (retain, nonatomic) UserObj*  notification_fromuserobj;

- (id) initEmptyObj;
- (id) initWithDict:(NSDictionary *) dict;
- (NSDictionary *) currentDict;

@end
