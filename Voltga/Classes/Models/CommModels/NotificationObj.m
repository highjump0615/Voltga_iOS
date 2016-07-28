//
//  NotificationObj.m
//  Voltga
//
//  Created by JackQuan on 8/6/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import "NotificationObj.h"
#import "Global.h"

@implementation NotificationObj

@synthesize notification_id;
@synthesize notification_placeid;
@synthesize notification_fromid;
@synthesize notification_toid;
@synthesize notification_type;
@synthesize notification_fromuserobj;
@synthesize notification_message;

- (id) initEmptyObj
{
    self = [super init];
    
    if (self)
    {
#ifdef BACKEND_READY
        [self setNotification_id:NSNUMBER_INT_ZERO];
        [self setNotification_placeid:NSNUMBER_INT_ZERO];
        [self setNotification_fromid:NSNUMBER_INT_ZERO];
        [self setNotification_toid:NSNUMBER_INT_ZERO];
        [self setNotification_type:NSNUMBER_INT_ZERO];
        [self setNotification_fromuserobj:[[UserObj alloc] init]];
        [self setNotification_message:@""];;
#else
        [self setNotification_id:[NSNumber numberWithInt:1]];
        [self setNotification_placeid:[NSNumber numberWithInt:1]];
        [self setNotification_fromid:[NSNumber numberWithInt:1]];
        [self setNotification_toid:[NSNumber numberWithInt:2]];
        [self setNotification_type:[NSNumber numberWithInt:1]];
        [self setNotification_fromuserobj:[[UserObj alloc] initEmptyObj]];
        [self setNotification_message:@"Liked you."];
#endif
    }
    
    return self;
}

- (id) initWithDict:(NSDictionary *) dict
{
    self = [super init];
    
    if (self)
    {
        [self setNotification_id:DICTIONARY_STRING_TO_INT_NUMBER(dict, @"notification_id")];
        [self setNotification_placeid:DICTIONARY_STRING_TO_INT_NUMBER(dict, @"notification_placeid")];
        [self setNotification_fromid:DICTIONARY_STRING_TO_INT_NUMBER(dict, @"notification_fromid")];
        [self setNotification_toid:DICTIONARY_STRING_TO_INT_NUMBER(dict, @"notification_toid")];
        [self setNotification_type:DICTIONARY_STRING_TO_INT_NUMBER(dict, @"notification_type")];
        [self setNotification_fromuserobj:[[UserObj alloc] initWithDict:[dict objectForKey:@"notification_fromuserobj"]]];
        [self setNotification_message:[dict objectForKey:@"notification_message"]];
    }
    
    return self;
}

- (NSDictionary *) currentDict
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    [dict setObject:[notification_id stringValue] forKey:@"notification_id"];
    [dict setObject:[notification_placeid stringValue] forKey:@"notification_placeid"];
    [dict setObject:[notification_fromid stringValue] forKey:@"notification_fromid"];
    [dict setObject:[notification_toid stringValue] forKey:@"notification_toid"];
    [dict setObject:[notification_type stringValue] forKey:@"notification_type"];
    [dict setObject:[notification_fromuserobj currentDict] forKey:@"notification_fromuserobj"];
    [dict setObject:notification_message forKey:@"notification_message"];
    
    return dict;
}


@end
