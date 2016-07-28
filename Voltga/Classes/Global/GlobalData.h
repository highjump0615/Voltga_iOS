//
//  GlobalData.h
//  Voltga
//
//  Created by JackQuan on 8/6/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "Global.h"
#import <CoreLocation/CoreLocation.h>

@interface GlobalData : NSObject

// Set current place for Current Tab.
@property (retain, nonatomic) PlaceObj*     g_currentPlace;

// Set the informations of app user.
@property (retain, nonatomic) UserObj*      g_selfUser;

// Set the informations of user for UserInfoViewController.
@property (retain, nonatomic) UserObj*      g_selectedUser;

// Set the device token for sending the device token when user signup.
@property (retain, nonatomic) NSString*     g_strDeviceToken;

// Set the user profile link for writing the user profile link in the input textbox in chat screen.
@property (retain, nonatomic) NSString*     g_strSelectedUserProfileLink;

// Set the badge number for notification.
@property (nonatomic, readwrite) int        g_nBadgeNumber;

// Set the phone type.
@property (nonatomic, readwrite) int        g_nPhoneType;

@property (nonatomic, readwrite) int        g_currentChatBaseNo;

@property (nonatomic) BOOL                   g_bChangedPlace;
@property (nonatomic) BOOL                   g_bChangedPlaceChat;
@property (nonatomic) BOOL                   g_bChangedPlaceNotification;

@property (nonatomic) UIBackgroundTaskIdentifier bgTask;

@property (retain, nonatomic) CLLocation*   g_currentLocation;
//@property (retain, nonatomic) NSString*     g_strState;

@property (retain, nonatomic) UIColor     *g_themeColor;

+ (id)sharedData;


- (NSDate *)dateFromString:(NSString *)strDate DateFormat:(NSString *)strDateFormat;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (NSString *)getUserPhoto:(NSString *)filename isThumbnail:(BOOL)bThumbnail;

@end
