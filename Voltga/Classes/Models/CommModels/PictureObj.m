//
//  PictureObj.m
//  Voltga
//
//  Created by JackQuan on 8/6/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import "PictureObj.h"
#import "Global.h"
#import "CommAPIManager.h"

@implementation PictureObj

@synthesize user_id;
@synthesize picture_index;
@synthesize private_picture;

- (id) initEmptyObj
{
    self = [super init];
    
    if (self)
    {
#ifdef BACKEND_READY
        [self setUser_id:NSNUMBER_INT_ZERO];
        [self setPicture_index:NSNUMBER_INT_ZERO];
        [self setPrivate_picture:@""];
#else
        [self setUser_id:[NSNumber numberWithInt:1]];
        [self setPicture_index:[NSNumber numberWithInt:1]];
        [self setPrivate_picture:@"http://cache4.asset-cache.net/gc/172601361-caucasian-man-smiling-gettyimages.jpg?v=1&c=IWSAsset&k=2&d=%2fw9BeUsjrSrzA2uNK7Gx8TmXnxgKVkrSmea7KsVXB82YtO05Y7XxKA%2b%2b1WNTCU3a376vKQwjYz%2fuboAkrwOSig%3d%3d"];
#endif
    }
    
    return self;
}

- (id) initWithDict:(NSDictionary *) dict
{
    self = [super init];
    
    if (self)
    {
        [self setUser_id:DICTIONARY_STRING_TO_INT_NUMBER(dict, @"photo_user_id")];
        [self setPicture_index:DICTIONARY_STRING_TO_INT_NUMBER(dict, @"photo_user_index")];
        [self setPrivate_picture:[NSString stringWithFormat:@"%@%@", VOLTGA_BASE_FILE_URL, [dict objectForKey:@"photo_url"]]];
    }
    
    return self;
}

- (NSDictionary *) currentDict
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    [dict setObject:user_id forKey:@"photo_user_id"];
    [dict setObject:picture_index forKey:@"photo_user_index"];
    [dict setObject:private_picture forKey:@"photo_url"];
    
    return dict;
}

@end
