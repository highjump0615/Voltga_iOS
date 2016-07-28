//
//  ChatObj.m
//  Voltga
//
//  Created by JackQuan on 8/6/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#define BACKEND_READY

#import "ChatObj.h"
#import "Global.h"
#import "GlobalData.h"
#import "CommAPIManager.h"

@implementation ChatObj

@synthesize chat_id;
@synthesize chat_place_id;
@synthesize chat_user_id;
@synthesize chat_msg_id;
@synthesize chat_type;
@synthesize chat_content;
@synthesize chat_media_url;
@synthesize chat_created;
@synthesize chat_image_width;
@synthesize chat_image_height;

@synthesize chat_user;      // chat sender

- (id) initEmptyObj
{
    self = [super init];
    
    if (self)
    {
#ifdef BACKEND_READY
        
        [self setChat_id:NSNUMBER_INT_ZERO];
        [self setChat_place_id:NSNUMBER_INT_ZERO];
        [self setChat_user_id:NSNUMBER_INT_ZERO];
        [self setChat_type:NSNUMBER_INT_ZERO];
        [self setChat_content:@""];
        [self setChat_media_url:@""];
        self.chat_msg_id = @"";
        [self setChat_image_width:NSNUMBER_INT_ZERO];
        [self setChat_image_height:NSNUMBER_INT_ZERO];
        
//        [self setChat_user:[[UserObj alloc] initEmptyObj]];
        [self setChat_user:[[GlobalData sharedData] g_selfUser]];
        
#else
        [self setChat_id:[NSNumber numberWithInt:1]];
        [self setChat_place_id:[NSNumber numberWithInt:1]];
        [self setChat_user_id:[NSNumber numberWithInt:1]];
        [self setChat_type:[NSNumber numberWithInt:0]]; //1, 2
        [self setChat_content:@"Hello, everybody this is the first chat"];
        [self setChat_media_url:@""];
#endif
    }
    
    return self;
}

- (id) initWithDict:(NSDictionary *) dict
{
    self = [super init];
    
    if(self)
    {
        [self setChat_id:DICTIONARY_STRING_TO_INT_NUMBER(dict, @"chat_id")];
        [self setChat_place_id:DICTIONARY_STRING_TO_INT_NUMBER(dict, @"chat_place_id")];
        [self setChat_user_id:DICTIONARY_STRING_TO_INT_NUMBER(dict, @"chat_user_id")];
        self.chat_msg_id = [dict objectForKey:@"chat_msg_id"];
        [self setChat_type:DICTIONARY_STRING_TO_INT_NUMBER(dict, @"chat_type")];
        [self setChat_content:[dict objectForKey:@"chat_content"]];
        
        if ([[dict objectForKey:@"chat_media_url"] length] > 0)
        {
            [self setChat_media_url:[NSString stringWithFormat:@"%@%@", VOLTGA_BASE_FILE_URL, [dict objectForKey:@"chat_media_url"]]];
        }
        
        [self setChat_image_width:DICTIONARY_STRING_TO_INT_NUMBER(dict, @"chat_image_width")];
        [self setChat_image_height:DICTIONARY_STRING_TO_INT_NUMBER(dict, @"chat_image_height")];
        
        // convert string to date
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *dateCreated = [formatter dateFromString:[dict objectForKey:@"chat_created"]];
        
        NSTimeZone *destTimeZone = [NSTimeZone systemTimeZone];
        NSInteger destGMTOffset = [destTimeZone secondsFromGMTForDate:dateCreated];
        NSDate *destTime = [[NSDate alloc] initWithTimeInterval:destGMTOffset sinceDate:dateCreated];
        
        [self setChat_created:destTime];
        
        [self setChat_user:[[UserObj alloc] initWithDict:[dict objectForKey:@"chat_user"]]];
        
    }
    
    return self;
}

- (NSDictionary *) currentDict
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
//    [dict setObject:[chat_id stringValue] forKey:@"chat_id"];
    [dict setObject:[chat_place_id stringValue] forKey:@"chat_place_id"];
    [dict setObject:[chat_user_id stringValue] forKey:@"chat_user_id"];

    NSString *strMsgId = [NSString stringWithFormat:@"'%@'", chat_msg_id];
    [dict setObject:strMsgId forKey:@"chat_msg_id"];
    
    [dict setObject:[chat_type stringValue] forKey:@"chat_type"];
    
    NSString *strChatContent = [NSString stringWithFormat:@"'%@'", chat_content];
    [dict setObject:strChatContent forKey:@"chat_content"];
    
    NSString *strMediaUrl = [NSString stringWithFormat:@"'%@'", chat_media_url];
    [dict setObject:strMediaUrl forKey:@"chat_media_url"];
    
    return dict;
    
}

@end
