//
//  PlaceObj.h
//  Voltga
//
//  Created by JackQuan on 8/6/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserObj;

@interface PlaceObj : NSObject

@property (retain, nonatomic)  NSNumber* place_id;
@property (retain, nonatomic)  NSString* place_name;
@property (retain, nonatomic)  NSString* place_street;
@property (retain, nonatomic)  NSString* place_city;
@property (retain, nonatomic)  NSString* place_state;
@property (retain, nonatomic)  NSString* place_zip;
@property (retain, nonatomic)  NSString* place_phone;
@property (retain, nonatomic)  NSString* place_picture;
@property (retain, nonatomic)  UserObj* user_obj;

- (id) initEmptyObj;
- (id) initWithDict:(NSDictionary *) dict;
- (NSDictionary *) currentDict;

@end
