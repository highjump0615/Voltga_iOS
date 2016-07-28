//
//  GlobalData.m
//  Voltga
//
//  Created by JackQuan on 8/6/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import "GlobalData.h"

GlobalData *g_globalData = nil;

@implementation GlobalData

@synthesize g_currentPlace;
@synthesize g_selfUser;
@synthesize g_selectedUser;
@synthesize g_strDeviceToken;
@synthesize g_strSelectedUserProfileLink;
@synthesize g_nBadgeNumber;
@synthesize g_nPhoneType;
@synthesize g_currentChatBaseNo;

+(id) sharedData
{
	@synchronized(self)
    {
        if (g_globalData == nil)
        {
            g_globalData = [[self alloc] init]; // assignment not done here
        }
	}
    
	return g_globalData;
}

- (id) init{
    
    id _self = [super init];
    
    g_currentChatBaseNo = -1;
    self.g_bChangedPlace = NO;
    self.g_bChangedPlaceNotification = NO;
    self.g_bChangedPlaceChat = YES;
//    self.g_strState = @"";
    
    self.bgTask = UIBackgroundTaskInvalid;
    self.g_themeColor = [UIColor colorWithRed:181/255.0 green:212/255.0 blue:52/255.0 alpha:1.0];
    
    g_strDeviceToken = @"";
    
    return _self;
    
}


- (NSDate *)dateFromString:(NSString *)strDate DateFormat:(NSString *)strDateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (strDateFormat == nil || [@"" isEqualToString:strDateFormat])
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    else
        [dateFormatter setDateFormat:strDateFormat];
    
    return [dateFormatter dateFromString:strDate];
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSString *)getUserPhoto:(NSString *)filename isThumbnail:(BOOL)bThumbnail
{
    NSString *strUrl = @"";
    
    if (filename && ![filename isEqual:[NSNull null]]) {
        if (bThumbnail)
        {
            strUrl = [NSString stringWithFormat:@"%@user/thumb/%@", VOLTGA_BASE_FILE_URL, filename];
        }
        else
        {
            strUrl = [NSString stringWithFormat:@"%@user/%@", VOLTGA_BASE_FILE_URL, filename];
        }
    }
    
    return strUrl;
}

+ (NSString *)getPrivatePhoto:(UserObj *)user index:(int)nIndex isThumbnail:(BOOL)bThumbnail
{
    NSString *strUrl;
    
    if (bThumbnail)
    {
        strUrl = [NSString stringWithFormat:@"%@user/thumb/%@_%d.jpg", VOLTGA_BASE_FILE_URL, user.user_name, nIndex];
    }
    else
    {
        strUrl = [NSString stringWithFormat:@"%@user/%@_%d.jpg", VOLTGA_BASE_FILE_URL, user.user_name, nIndex];
    }
    
    return strUrl;
}



@end