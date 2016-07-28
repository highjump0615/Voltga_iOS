//
//  PictureObj.h
//  Voltga
//
//  Created by JackQuan on 8/6/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PictureObj : NSObject

@property (retain, nonatomic) NSNumber*     user_id;
@property (retain, nonatomic) NSNumber*     picture_index;
@property (retain, nonatomic) NSString*     private_picture;

- (id) initEmptyObj;
- (id) initWithDict:(NSDictionary *) dict;
- (NSDictionary *) currentDict;

@end
