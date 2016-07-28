//
//  NotificationViewController.m
//  Voltga
//
//  Created by JackQuan on 8/5/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import "NotificationViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "NotificationViewCell.h"
#import "UIImageView+WebCache.h"
//#import "UIImageView+AFNetworking.h"
#import "UserInfoViewController.h"
#import "GADBannerView.h"

@interface NotificationViewController ()

@property (weak, nonatomic) IBOutlet GADBannerView *mViewBanner;

@end

#define NOTIFICATIONVIEWCELL_HEIGHT_IPHONE5     60
#define BACKEND_READY

@implementation NotificationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    m_aryNotification = [[NSMutableArray alloc] init];
    
    // Pull to refresh
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(fnInitialize:) forControlEvents:UIControlEventValueChanged];
    [self.m_tblNotification addSubview:refreshControl];
    [self fnInitialize:refreshControl];
    
    m_bIsLoaded = true;
    
    // banner view
    self.mViewBanner.adUnitID = @"ca-app-pub-8287457467886602/9966393174";
    self.mViewBanner.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    request.testDevices = @[GAD_SIMULATOR_ID];
    [self.mViewBanner loadRequest:request];

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[GlobalData sharedData] g_bChangedPlaceNotification])
    {
        [self fnInitialize:nil];
    }
    
//    if (!m_bIsLoaded)
//    {
////        [self fnInitialize:nil];
//    }
//    
//    //TCOTS
//    m_bIsLoaded = false;
}

- (void) fnInitialize:(UIRefreshControl*) sender
{
    // Initialize controls.
#ifdef BACKEND_READY
    
    //TCOTS
    // ********************** GET NOTIFICATIONS IN CURRENT PLACE ************************ //
    // API : getNotifications
    
    
    GlobalData *gData = [GlobalData sharedData];
    if (gData.g_bChangedPlaceNotification)
    {
        [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeClear];
    }
    if (gData.g_bChangedPlaceNotification)
    {
        [_m_tblNotification setHidden:YES];
    }
    
    [[CommAPIManager sharedCommAPIManager] getNotificationsWithUserID:[((GlobalData*) [GlobalData sharedData]).g_selfUser.user_id stringValue]
                                                              PlaceID:[((GlobalData*) [GlobalData sharedData]).g_selfUser.user_place_id stringValue]
                                                            successed:^(id responseObject)
    {
        NSLog(@"%@", responseObject);
        if ([[responseObject objectForKey:WEBAPI_RETURN_RESULT] isEqualToString:WEBAPI_RETURN_SUCCESS])
        {
            [SVProgressHUD dismiss];
            NSArray *aryNotification = [responseObject objectForKey:WEBAPI_RETURN_VALUES];
            
            [m_aryNotification removeAllObjects];
    
            for (int i = 0; i < [aryNotification count]; i++) {
                NotificationObj* notificationObj = [[NotificationObj alloc] initWithDict:aryNotification[i]];
                if ([notificationObj.notification_type intValue] > 0) {
                    [m_aryNotification addObject:notificationObj];
                }
            }
            
            NSLog(@"get notification success");
            
            gData.g_bChangedPlaceNotification = NO;
        
//            if (m_aryNotification.count > 0)
//            {
                [_m_tblNotification setHidden:NO];
//            }
//            else
//            {
//                [_m_tblNotification setHidden:YES];
//            }
            
            [_m_tblNotification reloadData];
        }
        else
        {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:WEBAPI_RETURN_MESSAGE]];
        }
        
        [sender endRefreshing];
    }
                                                              failure:^(NSError *error)
    {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.description];
        
        [sender endRefreshing];
    }];
#else
    
    [m_aryNotification removeAllObjects];
    
    for (int i = 0; i < 10; i ++)
    {
        NotificationObj* notificationObj = [[NotificationObj alloc] initEmptyObj];
        [m_aryNotification addObject:notificationObj];
    }
    
    [_m_tblNotification reloadData];
    
    [sender endRefreshing];
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UITableViewDelegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_aryNotification count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NOTIFICATIONVIEWCELL_HEIGHT_IPHONE5;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* strCellIndentifier = @"NotificationViewCell";
    UIImage* imgDefaultAvatar = [UIImage imageNamed:@"img_default_user.png"];
    
    NotificationViewCell* cell = [tableView dequeueReusableCellWithIdentifier:strCellIndentifier];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:strCellIndentifier owner:self options:nil] objectAtIndex:0];
    }
    
    NotificationObj* notificationObj = [m_aryNotification objectAtIndex:indexPath.row];
    [cell.m_imgAvatar sd_setImageWithURL:[NSURL URLWithString:[GlobalData getUserPhoto:notificationObj.notification_fromuserobj.user_public_photo isThumbnail:YES]]
                        placeholderImage:imgDefaultAvatar
                                 options:SDWebImageProgressiveDownload | SDWebImageRetryFailed];
    
    // set the notification text.
    NSString *strMsg;
    if ([notificationObj.notification_type isEqualToNumber:[NSNumber numberWithInt:NotificationType_Like]]) {
        strMsg = [NSString stringWithFormat:@"%@ liked you", notificationObj.notification_fromuserobj.user_name];
    }
    else if ([notificationObj.notification_type isEqualToNumber:[NSNumber numberWithInt:NotificationType_Mention]]) {
        strMsg = [NSString stringWithFormat:@"%@ mentioned you", notificationObj.notification_fromuserobj.user_name];
    }
    else if ([notificationObj.notification_type isEqualToNumber:[NSNumber numberWithInt:NotificationType_Unlock]]) {
        strMsg = [NSString stringWithFormat:@"%@ unlocked you", notificationObj.notification_fromuserobj.user_name];
    }
    
    NSMutableAttributedString *attStrMsg = [[NSMutableAttributedString alloc] initWithString:strMsg];
    
    [attStrMsg addAttribute:NSForegroundColorAttributeName
                      value:[UIColor colorWithRed:181/255.0 green:212/255.0 blue:52/255.0 alpha:1]
                      range:NSMakeRange(0, notificationObj.notification_fromuserobj.user_name.length)];
    
    [attStrMsg addAttribute:NSForegroundColorAttributeName
                      value:[UIColor whiteColor]
                      range:NSMakeRange(notificationObj.notification_fromuserobj.user_name.length, strMsg.length - notificationObj.notification_fromuserobj.user_name.length)];
    
    [cell.m_lblNotification setAttributedText:attStrMsg];
    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GlobalData *globalData = (GlobalData *)[GlobalData sharedData];
    
    cell.selectedBackgroundView = [UIView new];
    cell.selectedBackgroundView.backgroundColor = globalData.g_themeColor;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Go to profile view screen.
    UserInfoViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
    
    NotificationObj* notificationObj = [m_aryNotification objectAtIndex:indexPath.row];
    
    // Pass the selected user_id.
    ((GlobalData*) [GlobalData sharedData]).g_selectedUser = notificationObj.notification_fromuserobj;
    
    [self.navigationController pushViewController:viewController animated:true];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
