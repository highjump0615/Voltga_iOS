//
//  PeopleViewController.m
//  Voltga
//
//  Created by JackQuan on 8/5/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#define BACKEND_READY

#import "PeopleViewController.h"
#import "AppDelegate.h"
#import "UserObj.h"
//#import "UIImageView+AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "UserInfoViewController.h"
#import "CurrentViewController.h"

#define PEOPLEVIEWCELL_AVATAR           101
#define PEOPLEVIEWCELL_ONLINEVIEW       100

@interface PeopleViewController ()

@end

@implementation PeopleViewController

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
    // Do any additional setup after loading the view.
    
    m_aryPeople = [[NSMutableArray alloc] init];
    
    // Pull to refresh
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(fnInitialize:) forControlEvents:UIControlEventValueChanged];
    [self.m_colPeople addSubview:refreshControl];
    [self fnInitialize:refreshControl];
    
    m_bIsLoaded = true;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[GlobalData sharedData] g_bChangedPlace])
    {
        [self fnInitialize:nil];
    }
    
//    if (!m_bIsLoaded)
//    {
//        [self fnInitialize:nil];
//    }
//    
//    m_bIsLoaded = false;
}

- (void) fnInitialize:(UIRefreshControl*) sender
{
    int nPlaceId = [[GlobalData sharedData] g_selfUser].user_place_id.intValue;
    if (nPlaceId < 0)
    {
        return;
    }

    
    // Initialize Controls.
#ifdef BACKEND_READY
    //TCOTS
    // ************************ GET PEOPLE IN CURRENT PLACE ************************ //
    // API : NUMBER
    
    GlobalData *gData = [GlobalData sharedData];
    
    if (m_aryPeople.count == 0)
    {
        [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeClear];
        [_m_colPeople setHidden:YES];
    }
    else if (gData.g_bChangedPlace)
    {
        [_m_colPeople setHidden:YES];
    }
    
    [[CommAPIManager sharedCommAPIManager] getPeopleWithUserID:[((GlobalData*)[GlobalData sharedData]).g_selfUser.user_id stringValue]
                                                       PlaceID:[((GlobalData*)[GlobalData sharedData]).g_selfUser.user_place_id stringValue]
                                                     successed:^(id responseObject)
    {
                                                         
        if ([[responseObject objectForKey:WEBAPI_RETURN_RESULT] isEqualToString:WEBAPI_RETURN_SUCCESS])
        {
            [m_aryPeople removeAllObjects];
            
            NSArray *aryPeople = [[[responseObject objectForKey:WEBAPI_RETURN_VALUES] objectForKey:@"users"] mutableCopy];
            
            for (int i = 0; i < [aryPeople count]; i++) {
                UserObj* uObj = [[UserObj alloc] initWithDict:aryPeople[i]];
                
                if ([uObj.user_id isEqualToNumber:[[GlobalData sharedData] g_selfUser].user_id]) {
                    [m_aryPeople insertObject:uObj atIndex:0];
                }
                else {
                    [m_aryPeople addObject:uObj];
                }
            }

            [_m_colPeople reloadData];
//            [SVProgressHUD showSuccessWithStatus:@"Success"];
            NSLog(@"%@", @"success get people");
            
            gData.g_bChangedPlace = NO;
            
            [_m_colPeople setHidden:NO];
            
            [SVProgressHUD dismiss];
        }
        else
        {
            [SVProgressHUD dismiss];
//            NSString *strError = [responseObject objectForKey:WEBAPI_RETURN_MESSAGE];
            [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:WEBAPI_RETURN_RESULT]];
            
            gData.g_bChangedPlace = YES;
        }
        [sender endRefreshing];
        
    }
                                                       failure:^(NSError *error)
    {
                                                         
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"Error Occurred"];
        [sender endRefreshing];
        NSLog(@"%@", error);
        
        gData.g_bChangedPlace = YES;
    }];
    
    
    
#else
    
    [m_aryPeople removeAllObjects];
    
    for (int i = 0; i < 10; i ++)
    {
        UserObj* userObj = [[UserObj alloc] initEmptyObj];
        [m_aryPeople addObject:userObj];
    }
    
    [_m_colPeople reloadData];
    
    [sender endRefreshing];
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return m_aryPeople.count;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage* imgDefaultAvatar = [UIImage imageNamed:@"img_default_user.png"];
    
    NSString* strReuseIndentifier = @"PeopleViewCell";
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:strReuseIndentifier forIndexPath:indexPath];

    UserObj* userObj = [m_aryPeople objectAtIndex:indexPath.row];
    
    UIImageView* imgUserAvatar = ((UIImageView*)[cell viewWithTag:PEOPLEVIEWCELL_AVATAR]);
    
    [imgUserAvatar sd_setImageWithURL:[NSURL URLWithString:[GlobalData getUserPhoto:userObj.user_public_photo isThumbnail:YES]]
                     placeholderImage:imgDefaultAvatar
                              options:SDWebImageProgressiveDownload | SDWebImageRetryFailed];

    UIView* imgOnline = (UIView*)[cell viewWithTag:PEOPLEVIEWCELL_ONLINEVIEW];
    double dRadius = imgOnline.frame.size.height / 2;
    [imgOnline.layer setMasksToBounds:YES];
    [imgOnline.layer setCornerRadius:dRadius];
    
    if ([userObj.user_is_active intValue])
    {
        [imgOnline setHidden:NO];
    }
    else
    {
        [imgOnline setHidden:YES];
    }
    
    // Add tap gestures for selecting picture.
    // One-tap --> profile screen, Double-tap --> chat screen with profile link.
    cell.tag = PEOPLEVIEWCELL_AVATAR + 1 + indexPath.row;
    
    UITapGestureRecognizer* doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnDoubleTap:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [doubleTapGesture setNumberOfTouchesRequired:1];
    [cell addGestureRecognizer:doubleTapGesture];
    
    UITapGestureRecognizer* singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnSingleTap:)];
    [singleTapGesture setNumberOfTapsRequired:1];
    [singleTapGesture setNumberOfTouchesRequired:1];
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    
    [cell addGestureRecognizer:singleTapGesture];
    return cell;
}

//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
//{
//    return CGSizeMake(80, 80);
//}


- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark -- UITapGestureRecognizer selectors
- (void) OnSingleTap:(UITapGestureRecognizer*) sender
{
    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *)sender;
    UICollectionViewCell* cell = (UICollectionViewCell*)tapGesture.view;
    
    NSLog(@"PeopleViewController OnSigleTap: %ld", (long)cell.tag - PEOPLEVIEWCELL_AVATAR - 1);
    
    // Check the relation, if the selected user blocked me, shows the alert.
    int index = (int)cell.tag - PEOPLEVIEWCELL_AVATAR - 1;
    if(index >= m_aryPeople.count)
        return;
    
    UserObj* userObj = [m_aryPeople objectAtIndex:cell.tag - PEOPLEVIEWCELL_AVATAR - 1];
    
    //TCOTS : PLEASE CONFIRM ABOUT THE LOGIC!!!.
    // when locked can't see this user's profile.
    if([userObj blockedMe]){
        
        [[[UIAlertView alloc] initWithTitle:@"VoltGA" message:@"You are blocked by this user" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
    }
    // Go to profile view screen.
    UserInfoViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
    
    // Pass the selected user_id.
    ((GlobalData*) [GlobalData sharedData]).g_selectedUser = userObj;
    
    [self.navigationController pushViewController:viewController animated:true];
}

- (void) OnDoubleTap:(UITapGestureRecognizer*) sender
{
    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *)sender;
    UICollectionViewCell* cell = (UICollectionViewCell*)tapGesture.view;
    
    NSLog(@"PeopleViewController OnDoubleTap: %ld", (long)cell.tag - PEOPLEVIEWCELL_AVATAR - 1);
    
    // Check the relation, if the selected user blocked me, shows the alert.
    UserObj* userObj = [m_aryPeople objectAtIndex:cell.tag - PEOPLEVIEWCELL_AVATAR - 1];

    // Go to chat screen with user profile link.
    ((GlobalData*) [GlobalData sharedData]).g_strSelectedUserProfileLink = [NSString stringWithFormat:@"@%@ ", userObj.user_name];

    CurrentViewController* parent = (CurrentViewController*)self.parentViewController;
    [parent->m_viewCtrlChat textViewDidBeginEditing:parent->m_viewCtrlChat.messageInputView.textView];
    NSString* msg = [parent->m_viewCtrlChat.messageInputView.textView.text stringByAppendingString:[[GlobalData sharedData] g_strSelectedUserProfileLink]];
    [parent->m_viewCtrlChat.messageInputView.textView setText:msg];
    [parent->m_viewCtrlChat textViewDidChange:parent->m_viewCtrlChat.messageInputView.textView];
    
    [parent onClickChat:nil];
    
//    [[AppDelegate sharedAppDelegate] setMainTabControllerViewWithIndex:2];
    
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
