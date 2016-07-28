//
//  AppDelegate.h
//  Voltga
//
//  Created by JackQuan on 8/4/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeveyTabBarController.h"
#import "SVProgressHUD.h"
#import "CommAPIManager.h"
#import "PECropViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "GlobalData.h"
#import "Global.h"

enum
{
    MainTabController_Place = 0,
    MainTabController_Current = 1,
    MainTabController_Me = 2

} MainTabController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, LeveyTabBarControllerDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *mLocationManager;
    CLGeocoder * mGeocoder;
    CLPlacemark * mPlacemark;
}

@property (strong, nonatomic) UIWindow *window;

@property (retain, nonatomic) LeveyTabBarController* m_leveyTabBarController;

+ (AppDelegate*) sharedAppDelegate;
- (void) initMainView;
- (void) setMainTabControllerViewWithIndex:(int) index;

- (void) setBackgroundInvalid;

@end
