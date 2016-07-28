//
//  UserObj.m
//  Voltga
//
//  Created by JackQuan on 8/6/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import "UserObj.h"
#import "Global.h"
#import "CommAPIManager.h"

@implementation UserObj

@synthesize user_id;
@synthesize user_name;
@synthesize user_age;
@synthesize user_height;
@synthesize user_weight;
@synthesize user_ethnicity;
@synthesize user_body;
@synthesize user_practice;
@synthesize user_intro;
@synthesize user_status;
@synthesize user_phone;
@synthesize user_password;
@synthesize user_email;
//@synthesize user_publicpicture;
@synthesize user_place_id;
//@synthesize user_privatepicture;
@synthesize user_relation_from;
@synthesize user_relation_to;

- (id) initEmptyObj
{
    self = [super init];
    
    if (self)
    {
#ifdef BACKEND_READY
        [self setUser_id:NSNUMBER_INT_ZERO];
        [self setUser_name:@""];
        [self setUser_age:NSNUMBER_INT_ZERO];
        [self setUser_height:@""];
        [self setUser_weight:@""];
        [self setUser_ethnicity:@""];
        [self setUser_body:@""];
        [self setUser_practice:@""];
        [self setUser_status:@""];
        [self setUser_phone:@""];
        [self setUser_password:@""];
//        [self setUser_publicpicture:@""];
        [self setUser_currentplace:NSNUMBER_INT_ZERO];
        [self setUser_privatepicture:[[NSMutableArray alloc] init]]
        [self setUser_intro:@""];
#else
        [self setUser_id:[NSNumber numberWithInt:1]];
        [self setUser_name:@"Jack"];
        [self setUser_age:[NSNumber numberWithInt:25]];
        [self setUser_height:@"25'5"];
        [self setUser_weight:[NSNumber numberWithInt:25]];
        [self setUser_ethnicity:@"American"];
        [self setUser_body:@"White"];
        [self setUser_practice:@"CTO"];
        [self setUser_status:@"Active"];
        [self setUser_phone:@"313587946"];
        [self setUser_password:@""];
        [self setUser_email:@""];
//        [self setUser_publicpicture:@"http://cache4.asset-cache.net/gc/129798908-natural-portrait-on-young-relaxed-gettyimages.jpg?v=1&c=IWSAsset&k=2&d=kV07kmVeYEFgERWK6xesmRSyUShoZ4vQUwwKhGEclvohQfpjh8%2faOPIYJ0oLcqr6"];
        [self setUser_place_id:[NSNumber numberWithInt:1]];
        [self setUser_intro:@"I come here to make good friend."];
        
//        [self setUser_privatepicture:[NSMutableArray array]];
        [self setUser_relation_to:[NSNumber numberWithInt:0]];
        [self setUser_relation_from:[NSNumber numberWithInt:0]];
        
#endif
    }
    
    return self;
}

- (id) initWithDict:(NSDictionary *) dict
{
    self = [super init];
    
    if (self)
    {
        [self setUser_id:DICTIONARY_STRING_TO_INT_NUMBER(dict, @"user_id")];
        [self setUser_name:[dict objectForKey:@"user_name"]];
        [self setUser_age:DICTIONARY_STRING_TO_INT_NUMBER(dict, @"user_age")];
        [self setUser_height:[dict objectForKey:@"user_height"]];
        [self setUser_weight:DICTIONARY_STRING_TO_FLOAT_NUMBER(dict, @"user_weight")];
        [self setUser_ethnicity:[dict objectForKey:@"user_ethnicity"]];
        [self setUser_body:[dict objectForKey:@"user_body"]];
        [self setUser_practice:[dict objectForKey:@"user_practice"]];
        [self setUser_status:[dict objectForKey:@"user_status"]];
        [self setUser_phone:[dict objectForKey:@"user_phone"]];
        [self setUser_password:[dict objectForKey:@"user_password"]];
        [self setUser_email:[dict objectForKey:@"user_email"]];
        [self setUser_is_active:[dict objectForKey:@"user_is_active"]];
        
        [self setUser_public_photo:[dict objectForKey:@"user_public_photo"]];
        [self setUser_private_photo1:[dict objectForKey:@"user_private_photo1"]];
        [self setUser_private_photo2:[dict objectForKey:@"user_private_photo2"]];
        [self setUser_private_photo3:[dict objectForKey:@"user_private_photo3"]];
        
//        [self setUser_publicpicture:[NSString stringWithFormat:@"%@user/%@", VOLTGA_BASE_FILE_URL, [dict objectForKey:@"user_publicpicture"]]];
        
        [self setUser_place_id:DICTIONARY_STRING_TO_INT_NUMBER(dict, @"user_place_id")];
        [self setUser_intro:[dict objectForKeyedSubscript:@"user_intro"]];
        
//        [self setUser_privatepicture:[((NSMutableArray*)[dict objectForKey:@"user_privatepicture"]) mutableCopy]];
        [self setUser_relation_to:DICTIONARY_STRING_TO_INT_NUMBER(dict, @"user_relation_to")];
        [self setUser_relation_from:DICTIONARY_STRING_TO_INT_NUMBER(dict, @"user_relation_from")];

    }
    
    return self;
}

- (NSDictionary *) currentDict
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    [dict setObject:[user_id stringValue] forKey:@"user_id"];
    [dict setObject:user_name forKey:@"user_name"];
    [dict setObject:[user_age stringValue] forKey:@"user_age"];
    [dict setObject:user_height forKey:@"user_height"];
    [dict setObject:[user_weight stringValue] forKey:@"user_weight"];
    [dict setObject:user_ethnicity forKey:@"user_ethnicity"];
    [dict setObject:user_body forKey:@"user_body"];
    [dict setObject:user_practice forKey:@"user_practice"];
    [dict setObject:user_intro forKey:@"user_intro"];
    [dict setObject:user_status forKey:@"user_status"];
    [dict setObject:user_phone forKey:@"user_phone"];
    [dict setObject:user_password forKey:@"user_password"];
    [dict setObject:user_email forKey:@"user_email"];
//    [dict setObject:user_publicpicture forKey:@"user_publicpicture"];
    [dict setObject:[user_place_id stringValue] forKey:@"user_place_id"];
    
    return dict;
}

- (BOOL)blockedByMe{
    
    return [self.user_relation_to intValue] & NotificationValue_IsBlock;
    
}

- (BOOL)likedByMe{
    
//    return [self.user_relation_to intValue] & RelationType_IsLike;
    return YES;
    
}

- (BOOL)lockedByMe{
    
    return !([self.user_relation_to intValue] & NotificationValue_IsUnlock);
    
}

- (BOOL)mentionedByMe{
    
//    return ([self.user_relation_to intValue] & RelationType_IsMention);
    return YES;
    
}

- (BOOL)blockedMe{
    
    return [self.user_relation_from intValue] & NotificationValue_IsBlock;
    
}

- (BOOL)likedMe{
    
//    return [self.user_relation_from intValue] & RelationType_IsLike;
    return YES;
    
}

- (BOOL)lockedMe{
    
    return !([self.user_relation_from intValue] & NotificationValue_IsUnlock);
    
}

- (BOOL)mentionedMe{
    
//    return ([self.user_relation_from intValue] & RelationType_IsMention);
    return YES;
    
}




@end
