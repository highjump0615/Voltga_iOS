//
//  PlaceViewController.m
//  Voltga
//
//  Created by JackQuan on 8/4/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import "PlaceViewController.h"
#import "AppDelegate.h"
#import "PlaceViewCell.h"
#import "UIImageView+WebCache.h"
//#import "UIImageView+AFNetworking.h"
#import "GADBannerView.h"
#import "UIButton+WebCache.h"

#define PLACEVIEWCELL_HELIGHT_IPHONE4   65

#define BACKEND_READY
@interface PlaceViewController () {
    PlaceViewCell *mCurrentCell;
}

@property (weak, nonatomic) IBOutlet GADBannerView *mViewBanner;

@end

@implementation PlaceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_aryPlace = [[NSMutableArray alloc] init];
    m_arySearchedPlace = [[NSMutableArray alloc] init];
    
    // Pull to refresh
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(fnInitialize:) forControlEvents:UIControlEventValueChanged];
    [self.m_tblPlace addSubview:refreshControl];
    
    [self fnInitialize:refreshControl];
    
    _m_tblPlace.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _m_tblPlace.backgroundColor = [UIColor clearColor];
    m_bIsLoaded = true;
    
    [_m_schPlace setBackgroundImage:[UIImage new]];;
    
    // banner view
    self.mViewBanner.adUnitID = @"ca-app-pub-8287457467886602/4713228771";
    self.mViewBanner.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    request.testDevices = @[GAD_SIMULATOR_ID];
    [self.mViewBanner loadRequest:request];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void) fnInitialize:(UIRefreshControl*) sender
{
    // Initialize Controls.
    
#ifdef BACKEND_READY
    
    //TCOTS
    // ********************** GET ALL PLACE DATA *********************** //
    // API : getPlacesWithsuccessed
    if (m_aryPlace.count == 0)
    {
        [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeClear];
    }
    
    [[CommAPIManager sharedCommAPIManager] getPlacesWithsuccessed:^(id responseObject)
    {
        if ([[responseObject objectForKey:WEBAPI_RETURN_RESULT] isEqualToString:WEBAPI_RETURN_SUCCESS])
        {
            [SVProgressHUD dismiss];
            
            NSArray *placeArray = [responseObject objectForKey:WEBAPI_RETURN_VALUES][@"places"];
            
            [m_aryPlace removeAllObjects];
            
            // change location of selected place
            for (int i = 0; i < [placeArray count]; i++)
            {
                NSDictionary *dicData = [placeArray objectAtIndex:i];
                PlaceObj *placeObj = [[PlaceObj alloc] initWithDict:dicData];
                if ([[GlobalData sharedData] g_selfUser].user_place_id.intValue == placeObj.place_id.intValue) {
                    [m_aryPlace insertObject:placeObj atIndex:0];
                }
                else {
                    [m_aryPlace addObject:placeObj];
                }
            }
            
            [_m_tblPlace reloadData];
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
    [m_aryPlace removeAllObjects];
    for (int i = 0; i < 10; i ++)
    {
        PlaceObj* placeObj = [[PlaceObj alloc] initEmptyObj];
        [m_aryPlace addObject:placeObj];
    }
    
    [_m_tblPlace reloadData];
    
    [sender endRefreshing];
#endif
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!m_bIsLoaded)
    {
        [_m_tblPlace reloadData];
    }
    
    m_bIsLoaded = false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark table view

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (m_arySearchedPlace.count == 0)
    {
        return m_aryPlace.count;
    }
    else
    {
        return m_arySearchedPlace.count;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TCOTS
    return PLACEVIEWCELL_HELIGHT_IPHONE4;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage* imgDefault = [UIImage imageNamed:@"img_bar_default.png"];
    UIImage* imgDefaultUser = [UIImage imageNamed:@"img_default_user.png"];
    
    NSString* strIndentifier = @"PlaceViewCellID";
    PlaceViewCell* cell = [tableView dequeueReusableCellWithIdentifier:strIndentifier];
    
//    if (!cell)
//    {
//        cell = [[[NSBundle mainBundle] loadNibNamed:strIndentifier owner:self options:nil] objectAtIndex:0];
//    }
    
    GlobalData *globalData = (GlobalData *)[GlobalData sharedData];
    
    cell.selectedBackgroundView = [UIView new];
    cell.selectedBackgroundView.backgroundColor = globalData.g_themeColor;

    
    PlaceObj* placeObj = nil;
    if (m_arySearchedPlace.count == 0)
    {
        placeObj = m_aryPlace[indexPath.row];
    }
    else
    {
        placeObj = m_arySearchedPlace[indexPath.row];
    }
    
    // Remove Selection of cell
    cell.backgroundColor    = [UIColor clearColor];
    
    // set data into controls of cell
    [cell.m_lblPlaceTitle setTextColor:[UIColor whiteColor]];
    [cell.m_lblPlaceAddress setTextColor:[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0]];
    
    cell.m_lblPlaceTitle.text = placeObj.place_name;
    cell.m_lblPlaceAddress.text = [NSString stringWithFormat:@"%@ %@", placeObj.place_street, placeObj.place_city];
    
    [cell.m_imgPlacePicture sd_setImageWithURL:[NSURL URLWithString:placeObj.place_picture] placeholderImage:imgDefault options:SDWebImageProgressiveDownload];
    
    if (placeObj.user_obj) {
        
        [cell.m_btnUser sd_setImageWithURL:[NSURL URLWithString:[GlobalData getUserPhoto:placeObj.user_obj.user_public_photo isThumbnail:YES]]
                                  forState:UIControlStateNormal
                          placeholderImage:imgDefaultUser options:SDWebImageProgressiveDownload];
        [cell.m_btnUser setTag:indexPath.row];
        [cell.m_btnUser setHidden:NO];
    }
    else {
        [cell.m_btnUser setHidden:YES];
    }
    
    if ([[GlobalData sharedData] g_selfUser].user_place_id.intValue == placeObj.place_id.intValue)
    {
        GlobalData *globalData = [GlobalData sharedData];
        cell.backgroundColor = globalData.g_themeColor;
        [cell.m_lblPlaceTitle setTextColor:[UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1.0]];
        [cell.m_lblPlaceAddress setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]];
        
        mCurrentCell = cell;
    }
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (mCurrentCell) {
        mCurrentCell.backgroundColor = [UIColor clearColor];
        [mCurrentCell.m_lblPlaceTitle setTextColor:[UIColor whiteColor]];
        [mCurrentCell.m_lblPlaceAddress setTextColor:[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0]];
    }
    
    [self OnClickHere:indexPath.row];
    
    return indexPath;
}

- (void) OnClickHere:(NSInteger)index {
//- (void) OnClickHere:(UIButton*) sender{
    
    PlaceObj *placeObj;
    
    if (m_arySearchedPlace.count == 0)
    {
//        ((GlobalData*)[GlobalData sharedData]).g_currentPlace = [[PlaceObj alloc] initWithDict:m_aryPlace[sender.tag]];
        placeObj = [m_aryPlace objectAtIndex:index];
        ((GlobalData*)[GlobalData sharedData]).g_currentPlace = placeObj;
        [m_aryPlace removeObjectAtIndex:index];
        [m_aryPlace insertObject:placeObj atIndex:0];
    }
    else {
//        ((GlobalData*)[GlobalData sharedData]).g_currentPlace = [[PlaceObj alloc] initWithDict:m_arySearchedPlace[sender.tag]];
        
        placeObj = [m_arySearchedPlace objectAtIndex:index];
        ((GlobalData*)[GlobalData sharedData]).g_currentPlace = placeObj;
        [m_arySearchedPlace removeObjectAtIndex:index];
        [m_arySearchedPlace insertObject:placeObj atIndex:0];
    }
    
    if ([[GlobalData sharedData] g_selfUser].user_place_id.intValue != [[GlobalData sharedData] g_currentPlace].place_id.intValue)  // place has changed
    {
        [[GlobalData sharedData] setG_currentChatBaseNo:-1];
    }
    
    //TCOTS
    // *********************** SET CURRENT PLACE TO SERVER *************************** //
    // API : setCurrentPlaceWithUserID
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeClear];
    [[CommAPIManager sharedCommAPIManager] setCurrentPlaceWithUserID:[((GlobalData*) [GlobalData sharedData]).g_selfUser.user_id stringValue]
                                                             PlaceID:[((GlobalData*) [GlobalData sharedData]).g_currentPlace.place_id stringValue]
                                                           successed:^(id responseObject)
    {

        if ([[responseObject objectForKey:WEBAPI_RETURN_RESULT] isEqualToString:WEBAPI_RETURN_SUCCESS])
        {
            ((GlobalData*)[GlobalData sharedData]).g_bChangedPlace = YES;
            ((GlobalData*)[GlobalData sharedData]).g_bChangedPlaceNotification = YES;
            ((GlobalData*)[GlobalData sharedData]).g_bChangedPlaceChat = YES;

            [SVProgressHUD dismiss];
            ((GlobalData*)[GlobalData sharedData]).g_selfUser.user_place_id = ((GlobalData*) [GlobalData sharedData]).g_currentPlace.place_id;
            
            [_m_tblPlace reloadData];
//            [[[GlobalData sharedData] g_selfUser] setUser_place_id:[[GlobalData sharedData] g_currentPlace].place_id];
            [[AppDelegate sharedAppDelegate] setMainTabControllerViewWithIndex:MainTabController_Current];
            
            [self fnInitialize:nil];
        }
        else
        {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:WEBAPI_RETURN_MESSAGE]];
        }
        
    }
                                                             failure:^(NSError *error)
    {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.description];
    }];
}

- (void)fnSearchPlaceByName:(NSString *)strPlaceName
{
    if ([@"" isEqualToString:strPlaceName])
    {
        m_arySearchedPlace = [NSMutableArray array];
        [_m_tblPlace reloadData];
        return;
    }
    
    [m_arySearchedPlace removeAllObjects];
    NSInteger rowNum = [m_aryPlace count];
    
    for(int i = 0; i < rowNum; i ++)
    {
        PlaceObj* placeObj = [m_aryPlace objectAtIndex:i];
        if ([placeObj.place_name rangeOfString:strPlaceName options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            [m_arySearchedPlace addObject:placeObj];
        }
    }
    
    [_m_tblPlace reloadData];
}


#pragma mark - SearchBar Delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)sender
{
    _m_schPlace.showsCancelButton = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)sender
{
    [sender resignFirstResponder];
    sender.showsCancelButton = NO;
    
    [self fnSearchPlaceByName:_m_schPlace.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self fnSearchPlaceByName:_m_schPlace.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)sender
{
    _m_schPlace.text = @"";
    [_m_schPlace resignFirstResponder];
    _m_schPlace.showsCancelButton = NO;
    [self fnSearchPlaceByName:_m_schPlace.text];
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
