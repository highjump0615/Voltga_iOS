//
//  RelationObj.m
//  Voltga
//
//  Created by JackQuan on 8/6/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import "RelationObj.h"
#import "Global.h"

@implementation RelationObj

@synthesize relation_id;
@synthesize relation_placeid;
@synthesize relation_fromid;
@synthesize relation_toid;
@synthesize relation_type;

- (id) initEmptyObj
{
    self = [super init];
    
    if (self)
    {
#ifdef BACKEND_READY
        [self setRelation_id:NSNUMBER_INT_ZERO];
        [self setRelation_placeid:NSNUMBER_INT_ZERO];
        [self setRelation_fromid:NSNUMBER_INT_ZERO];
        [self setRelation_toid:NSNUMBER_INT_ZERO];
        [self setRelation_type:NSNUMBER_INT_ZERO];
#else
        [self setRelation_id:[NSNumber numberWithInt:1]];
        [self setRelation_placeid:[NSNumber numberWithInt:1]];
        [self setRelation_fromid:[NSNumber numberWithInt:1]];
        [self setRelation_toid:[NSNumber numberWithInt:2]];
        [self setRelation_type:[NSNumber numberWithInt:1]];
#endif
    }
    
    return self;
}

- (id) initWithDict:(NSDictionary *) dict
{
    self = [super init];
    
    if (self)
    {
        [self setRelation_id:DICTIONARY_STRING_TO_INT_NUMBER(dict, @"relation_id")];
        [self setRelation_placeid:DICTIONARY_STRING_TO_INT_NUMBER(dict, @"relation_placeid")];
        [self setRelation_fromid:DICTIONARY_STRING_TO_INT_NUMBER(dict, @"relation_fromid")];
        [self setRelation_toid:DICTIONARY_STRING_TO_INT_NUMBER(dict, @"relation_toid")];
        [self setRelation_type:DICTIONARY_STRING_TO_INT_NUMBER(dict, @"relation_type")];
    }
    
    return self;
}

- (NSDictionary *) currentDict
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    [dict setObject:[relation_id stringValue] forKey:@"relation_id"];
    [dict setObject:[relation_placeid stringValue] forKey:@"relation_placeid"];
    [dict setObject:[relation_fromid stringValue] forKey:@"relation_fromid"];
    [dict setObject:[relation_toid stringValue] forKey:@"relation_toid"];
    [dict setObject:[relation_type stringValue] forKey:@"relation_type"];
    
    return dict;
}

@end
