//
//  RelationObj.h
//  Voltga
//
//  Created by JackQuan on 8/6/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef enum
//{
//    
//    RelationType_IsUnlock   = 0x1,        // 0: Lock,     1: UnLock
//    RelationType_IsLike     = 0x2,          // 0: UnLike,   1: Like
//    RelationType_IsBlock    = 0x4          // 0: UnBlock,  1: Block
//    
//} RelationType;

@interface RelationObj : NSObject

@property (retain, nonatomic) NSNumber* relation_id;
@property (retain, nonatomic) NSNumber* relation_placeid;
@property (retain, nonatomic) NSNumber* relation_fromid;
@property (retain, nonatomic) NSNumber* relation_toid;
@property (retain, nonatomic) NSNumber* relation_type;

- (id) initEmptyObj;
- (id) initWithDict:(NSDictionary *) dict;
- (NSDictionary *) currentDict;

@end
