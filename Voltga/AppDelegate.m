//
//  AppDelegate.m
//  Voltga
//
//  Created by JackQuan on 8/4/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import "AppDelegate.h"
#import "PlaceViewController.h"
#import "CurrentViewController.h"
#import "AccountViewController.h"
#import "GAI.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    UIImage *image = [UIImage imageNamed:@"120.png"];
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    // Override point for customization after application launch.

    // push notification setting.
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
    
    // initialize global variables
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGSize g_cgzScreen = CGSizeMake(screenScale * screenBounds.size.width, screenScale * screenBounds.size.height);
    ((GlobalData*)[GlobalData sharedData]).g_nPhoneType = 0;
    
    // check iphone type
    if (g_cgzScreen.width == 320)
    {
        ((GlobalData*)[GlobalData sharedData]).g_nPhoneType = IPHONE60;
    }
    
    if (g_cgzScreen.width == 640)
    {
        if (g_cgzScreen.height == 960)
        {
            ((GlobalData*)[GlobalData sharedData]).g_nPhoneType = RETINA35;
        }
        else
        {
            ((GlobalData*)[GlobalData sharedData]).g_nPhoneType = RETINA40;
        }
    }
    
    UIViewController *initViewController;
    UIStoryboard* storyBoard = nil;
//    switch (((GlobalData*)[GlobalData sharedData]).g_nPhoneType)
//    {
//        case IPHONE60:
//        case RETINA35:
//            storyBoard = [UIStoryboard storyboardWithName:@"iPhone4" bundle:nil];
//            initViewController = [storyBoard instantiateInitialViewController];
//            [self.window setRootViewController:initViewController];
//
//            break;
//        case RETINA40:
//            storyBoard = [UIStoryboard storyboardWithName:@"iPhone5" bundle:nil];
//            initViewController = [storyBoard instantiateInitialViewController];
//            [self.window setRootViewController:initViewController];
//            
//            break;
//    }
    
    storyBoard = [UIStoryboard storyboardWithName:@"iPhone5" bundle:nil];
    initViewController = [storyBoard instantiateInitialViewController];
    [self.window setRootViewController:initViewController];
    
    
    // get location
    mLocationManager = [[CLLocationManager alloc] init];
    mLocationManager.delegate = self;
    mLocationManager.distanceFilter = kCLLocationAccuracyHundredMeters;
    
    if ([mLocationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [mLocationManager requestAlwaysAuthorization];
    }
    
//    mLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [mLocationManager startMonitoringSignificantLocationChanges];
//    [mLocationManager startUpdatingLocation];
    
    mGeocoder = [[CLGeocoder alloc] init];
    
    // status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [[GAI sharedInstance] setTrackUncaughtExceptions:YES];
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 120;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-56369920-3"];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    // Save the user current place
    [[NSUserDefaults standardUserDefaults] setObject:[((GlobalData*)[GlobalData sharedData]).g_selfUser.user_place_id stringValue] forKey:SELF_USERPLACEID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self setOnlineState:0];
    
    GlobalData *gData = [GlobalData sharedData];
    
    gData.bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        // Clean up any unfinished task business by marking where you
        // stopped or ending the task outright.
        
        NSLog(@"System end");
        
        [application endBackgroundTask:gData.bgTask];
        gData.bgTask = UIBackgroundTaskInvalid;
    }];

}
 
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self setOnlineState:1];
 
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    NSString* strUserID = [[NSUserDefaults standardUserDefaults] objectForKey:SELF_USERID];
    NSString* strCurrentPlaceID = [[NSUserDefaults standardUserDefaults] objectForKey:SELF_USERPLACEID];
    if (strUserID.length == 0 || strCurrentPlaceID.length == 0)
    {
        return;
    }
    
    //TCOTS
    // ************************ GET BADGE BASED ON CURRENT PLACEID AND SELFUSER ID ************************** //
    [[CommAPIManager sharedCommAPIManager] getBadgesWithUserID:strUserID PlaceID:strCurrentPlaceID successed:^(id responseObject)
    {
        NSLog(@"%@", responseObject);
        
        if ([[responseObject objectForKey:WEBAPI_RETURN_RESULT] isEqualToString:WEBAPI_RETURN_SUCCESS])
        {
            ((GlobalData*) [GlobalData sharedData]).g_nBadgeNumber = [[responseObject objectForKey:WEBAPI_RETURN_VALUES] intValue];
        }
        else
        {
            ((GlobalData*) [GlobalData sharedData]).g_nBadgeNumber = 0;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SET_TOTAL_NOTIFICATION object:nil];
    }
                                                       failure:^(NSError *error)
    {
        ((GlobalData*) [GlobalData sharedData]).g_nBadgeNumber = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:SET_TOTAL_NOTIFICATION object:nil];
    }];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self setOnlineState:0];
}

- (void)setOnlineState:(int)bOnline
{
    UserObj *currentUser = ((GlobalData*)[GlobalData sharedData]).g_selfUser;
    if (!currentUser)
    {
        return;
    }
    
    currentUser.user_is_active = [NSNumber numberWithInt:bOnline];
    
    [[CommAPIManager sharedCommAPIManager] setUserOnlineWithUserID:currentUser.user_id
                                                       OnlineState:currentUser.user_is_active
                                                         successed:^(id responseObject)
     {
     }
                                                           failure:^(NSError *error)
     {
     }];
}

- (void) setBackgroundInvalid
{
    GlobalData *gData = [GlobalData sharedData];
    
    if (gData.bgTask != UIBackgroundTaskInvalid)
    {
        UIApplication* app = [UIApplication sharedApplication];
        [app endBackgroundTask:gData.bgTask];
        gData.bgTask = UIBackgroundTaskInvalid;
    }
}

+ (AppDelegate*) sharedAppDelegate
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}


//*******************************************************************************//
//***************************  Device Token Operation  **************************//
//*******************************************************************************//

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"My token is: %@", deviceToken);
    NSString *token = [[NSString alloc]
                       initWithString: [[[[deviceToken description]
                                          stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                         stringByReplacingOccurrencesOfString: @">" withString: @""]
                                        stringByReplacingOccurrencesOfString: @" " withString: @""]];
    
    ((GlobalData*)[GlobalData sharedData]).g_strDeviceToken = token;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%@", error.description);
}

- (void) initMainView
{
    UIStoryboard* storyBoard = nil;
    
//    switch (((GlobalData*)[GlobalData sharedData]).g_nPhoneType)
//    {
//        case IPHONE60:
//        case RETINA35:
//            storyBoard = [UIStoryboard storyboardWithName:@"iPhone4" bundle:nil];
//            break;
//        case RETINA40:
//            storyBoard = [UIStoryboard storyboardWithName:@"iPhone5" bundle:nil];
//            break;
//    }
    storyBoard = [UIStoryboard storyboardWithName:@"iPhone5" bundle:nil];

    PlaceViewController* firstVC = IS_IPHONE ?
    [storyBoard instantiateViewControllerWithIdentifier:@"PlaceViewController"] :
    [storyBoard instantiateViewControllerWithIdentifier:@"PlaceViewController"];
    
	CurrentViewController* secondVC = IS_IPHONE ?
    [storyBoard instantiateViewControllerWithIdentifier:@"CurrentViewController"] :
    [storyBoard instantiateViewControllerWithIdentifier:@"CurrentViewController"];
    
    AccountViewController* thirdVC = IS_IPHONE ?
    [storyBoard instantiateViewControllerWithIdentifier:@"AccountViewController"] :
    [storyBoard instantiateViewControllerWithIdentifier:@"AccountViewController"];
    
	NSArray *ctrlArr = [NSArray arrayWithObjects:firstVC, secondVC, thirdVC, nil];
    
	NSMutableDictionary *imgDic = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic setObject:[UIImage imageNamed:IS_IPHONE ? @"img_place_normal.png" : @"img_place_normal.png"] forKey:@"Default"];
	[imgDic setObject:[UIImage imageNamed:IS_IPHONE ? @"img_place_active.png" : @"img_place_active.png"] forKey:@"Highlighted"];
	[imgDic setObject:[UIImage imageNamed:IS_IPHONE ? @"img_place_active.png" : @"img_place_active.png"] forKey:@"Selected"];
    
	NSMutableDictionary *imgDic2 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic2 setObject:[UIImage imageNamed:IS_IPHONE ? @"img_current_normal.png" : @"img_current_normal.png"] forKey:@"Default"];
	[imgDic2 setObject:[UIImage imageNamed:IS_IPHONE ? @"img_current_active.png" : @"img_current_active.png"] forKey:@"Highlighted"];
	[imgDic2 setObject:[UIImage imageNamed:IS_IPHONE ? @"img_current_active.png" : @"img_current_active.png"] forKey:@"Selected"];
    
	NSMutableDictionary *imgDic3 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic3 setObject:[UIImage imageNamed:IS_IPHONE ? @"img_me_normal.png" : @"img_me_normal.png"] forKey:@"Default"];
	[imgDic3 setObject:[UIImage imageNamed:IS_IPHONE ? @"img_me_active.png" : @"img_me_active.png"] forKey:@"Highlighted"];
	[imgDic3 setObject:[UIImage imageNamed:IS_IPHONE ? @"img_me_active.png" : @"img_me_active.png"] forKey:@"Selected"];
	
	NSArray *imgArr = [NSArray arrayWithObjects:imgDic, imgDic2, imgDic3, nil];
	self.m_leveyTabBarController = [[LeveyTabBarController alloc] initWithViewControllers:ctrlArr imageArray:imgArr];
    [self.m_leveyTabBarController setDelegate:self];
	[self.m_leveyTabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"img_tabbar.png"]];
	[self.m_leveyTabBarController setTabBarTransparent:YES];
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:self.m_leveyTabBarController];
    self.window.rootViewController = navVC;//self.m_leveyTabBarController;
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNewNotification:) name:NEW_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSetNotification:) name:SET_TOTAL_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRemoveNotificationBadge:) name:REMOVE_NOTIFICATION object:nil];
    
    [self setOnlineState:1];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NEW_NOTIFICATION object:nil];
}


#pragma NSNotification observer

- (void)onNewNotification:(NSNotification*)notificcation
{
    ((GlobalData*)[GlobalData sharedData]).g_nBadgeNumber += 1;
    [self.m_leveyTabBarController.tabBar plusBadegeNumber];
    NSLog(@"%@", notificcation);
}

- (void)onRemoveNotificationBadge:(NSNotification*)notificcation
{
    ((GlobalData*) [GlobalData sharedData]).g_nBadgeNumber = 0;
    [self.m_leveyTabBarController.tabBar setBadgeNumber:((GlobalData*) [GlobalData sharedData]).g_nBadgeNumber];
    NSLog(@"%@", notificcation);
}

- (void)onSetNotification:(NSNotification*)notificcation
{
    [self.m_leveyTabBarController.tabBar setBadgeNumber:((GlobalData*) [GlobalData sharedData]).g_nBadgeNumber];
    NSLog(@"%@", notificcation);
}

- (void) setMainTabControllerViewWithIndex:(int) index
{
    [self.m_leveyTabBarController setSelectedIndex:index];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (status == kCLAuthorizationStatusAuthorized || status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways)
    {
        NSLog(@"kCLAuthorizationStatusAuthorized");
        // Re-enable the post button if it was disabled before.
        //			self.navigationItem.rightBarButtonItem.enabled = YES;
        [mLocationManager startMonitoringSignificantLocationChanges];
    }
    else if (status == kCLAuthorizationStatusDenied)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Voltga can’t access your current location.\n\nTo see the places at your current location, turn on access for Voltga to your location in the Settings app under Location Services." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
    }
    else if (status == kCLAuthorizationStatusNotDetermined)
    {
        NSLog(@"kCLAuthorizationStatusNotDetermined");
    }
    else if (status == kCLAuthorizationStatusRestricted)
    {
        NSLog(@"kCLAuthorizationStatusRestricted");
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
//    UIAlertView *errorAlert = [[UIAlertView alloc]
//                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    
    GlobalData* gData = [GlobalData sharedData];
    gData.g_currentLocation = newLocation;
    
//    // Reverse Geocoding
//    NSLog(@"Resolving the Address");
//    [mGeocoder reverseGeocodeLocation:gData.g_currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
//     {
//         NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
//         
//         if (error == nil && [placemarks count] > 0)
//         {
//             mPlacemark = [placemarks lastObject];
//             NSString *strLocation = [NSString stringWithFormat:@"%@\n %@\n%@\n %@\n%@\n%@",
//                                      mPlacemark.subThoroughfare,
//                                      mPlacemark.thoroughfare,
//                                      mPlacemark.postalCode,
//                                      mPlacemark.locality,
//                                      mPlacemark.administrativeArea,
//                                      mPlacemark.country];
//             NSLog(@"Location: %@", strLocation);
//             
//             gData.g_strState = mPlacemark.administrativeArea;
//         }
//         else
//         {
//             NSLog(@"%@", error.debugDescription);
//         }
//     }];

}


@end
