//
//  PlaceObj.m
//  Voltga
//
//  Created by JackQuan on 8/6/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import "PlaceObj.h"
#import "Global.h"
#import "CommAPIManager.h"
#import "UserObj.h"

@implementation PlaceObj

@synthesize place_id;
@synthesize place_name;
@synthesize place_city;
@synthesize place_phone;
@synthesize place_state;
@synthesize place_street;
@synthesize place_zip;
@synthesize place_picture;

- (id) initEmptyObj
{
    self = [super init];
    
    if (self)
    {
#ifdef BACKEND_READY
        [self setPlace_id:NSNUMBER_INT_ZERO];
        [self setPlace_name:@""];
        [self setPlace_street:@""];
        [self setPlace_city:@""];
        [self setPlace_state:@""];
        [self setPlace_zip:@""];
        [self setPlace_phone:@""];
        [self setPlace_picture:@""];
#else
        [self setPlace_id:[NSNumber numberWithInt:1]];
        [self setPlace_name:@"Badlands"];
        [self setPlace_street:@"4142 18th st"];
        [self setPlace_city:@"San Francisco"];
        [self setPlace_state:@"CA"];
        [self setPlace_zip:@"94114"];
        [self setPlace_phone:@"313-5534673"];
        [self setPlace_picture:@"http://www.homeizy.com/wp-content/uploads/2012/11/Home-Bar-Design-Ideas-500x387.jpg"];
#endif
    }
    
    return self;
}

- (id) initWithDict:(NSDictionary *) dict
{
    self = [super init];
    
    if (self)
    {
        [self setPlace_id:DICTIONARY_STRING_TO_INT_NUMBER(dict, @"place_id")];
        [self setPlace_name:[dict objectForKey:@"place_name"]];
        [self setPlace_street:[dict objectForKey:@"place_street"]];
        [self setPlace_city:[dict objectForKey:@"place_city"]];
        [self setPlace_state:[dict objectForKey:@"place_state"]];
        [self setPlace_zip:[dict objectForKey:@"place_zip"]];
        [self setPlace_phone:[dict objectForKey:@"place_phone"]];
        
        [self setPlace_picture:[NSString stringWithFormat:@"%@place/%@", VOLTGA_BASE_FILE_URL, [dict objectForKey:@"place_photo"]]];
        
        NSDictionary *dicUser =[dict objectForKey:@"user"];
        if ([dicUser count] > 0) {
            [self setUser_obj:[[UserObj alloc] initWithDict:[dict objectForKey:@"user"]]];
        }
    }
    
    return self;
}

- (NSDictionary *) currentDict
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    [dict setObject:[place_id stringValue] forKey:@"place_id"];
    [dict setObject:place_name forKey:@"place_name"];
    [dict setObject:place_street forKey:@"place_street"];
    [dict setObject:place_city forKey:@"place_city"];
    [dict setObject:place_state forKey:@"place_state"];
    [dict setObject:place_zip forKey:@"place_zip"];
    [dict setObject:place_phone forKey:@"place_phone"];
    [dict setObject:place_picture forKey:@"place_picture"];
    
    return dict;
}


@end
