//
//  UserInfoViewController.m
//  Voltga
//
//  Created by JackQuan on 8/5/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import "UserInfoViewController.h"
//#import "UIImageView+AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "MWPhotoBrowser.h"
#import "MWPhoto.h"

#import "CurrentViewController.h"
#import "GADBannerView.h"

@interface UserInfoViewController () <MWPhotoBrowserDelegate>

@property (weak, nonatomic) IBOutlet UIButton *mButMention;
@property (weak, nonatomic) IBOutlet UIButton *mButLike;
@property (weak, nonatomic) IBOutlet UIButton *mButUnlock;
@property (weak, nonatomic) IBOutlet UIButton *mButBlock;
@property (weak, nonatomic) IBOutlet GADBannerView *mViewBanner;

@end

@implementation UserInfoViewController

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
    
    // Initialize controls.
    _m_viewOption.hidden = true;
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnClickPicture:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    [_m_lblUserName setText:((GlobalData*) [GlobalData sharedData]).g_selectedUser.user_name];
    
    // set background image.
    UIImage* imgDefaultPicture = [UIImage imageNamed:@"img_default_user.png"];
    NSString *strPicture = [GlobalData getUserPhoto:((GlobalData*) [GlobalData sharedData]).g_selectedUser.user_public_photo isThumbnail:NO];
    [_m_imgPublicPicture sd_setImageWithURL:[NSURL URLWithString:strPicture]
                           placeholderImage:imgDefaultPicture
                                    options:SDWebImageProgressiveDownload | SDWebImageRetryFailed];
    
    // Make array of picture.
    m_aryPictureURL = [[NSMutableArray alloc] init];
    m_aryPictureController = [[NSMutableArray alloc] init];
    
    // set avatar picture.
    strPicture = [GlobalData getUserPhoto:((GlobalData*) [GlobalData sharedData]).g_selectedUser.user_public_photo isThumbnail:YES];
    [_m_imgAvatar sd_setImageWithURL:[NSURL URLWithString:strPicture]
                    placeholderImage:imgDefaultPicture
                             options:SDWebImageProgressiveDownload | SDWebImageRetryFailed];
    
    strPicture = [GlobalData getUserPhoto:((GlobalData*) [GlobalData sharedData]).g_selectedUser.user_public_photo isThumbnail:NO];
    [m_aryPictureURL addObject:strPicture];
    [m_aryPictureController addObject:_m_imgAvatar];
    
    if ([[[GlobalData sharedData] g_selfUser].user_id isEqualToNumber:[[GlobalData sharedData] g_selectedUser].user_id] ||
        ![[[GlobalData sharedData] g_selectedUser] lockedMe])
    {
        strPicture = [GlobalData getUserPhoto:((GlobalData*) [GlobalData sharedData]).g_selectedUser.user_private_photo1 isThumbnail:YES];
        if (strPicture.length > 0) {
            [_m_imgPrivatePicture1 sd_setImageWithURL:[NSURL URLWithString:strPicture]
                                     placeholderImage:imgDefaultPicture
                                              options:SDWebImageProgressiveDownload | SDWebImageRetryFailed];
        
            strPicture = [GlobalData getUserPhoto:((GlobalData*) [GlobalData sharedData]).g_selectedUser.user_private_photo1 isThumbnail:NO];
            [m_aryPictureURL addObject:strPicture];
            [m_aryPictureController addObject:_m_imgPrivatePicture1];
        }

        strPicture = [GlobalData getUserPhoto:((GlobalData*) [GlobalData sharedData]).g_selectedUser.user_private_photo2 isThumbnail:YES];
        if (strPicture.length > 0) {
            [_m_imgPrivatePicture2 sd_setImageWithURL:[NSURL URLWithString:strPicture] 
                                     placeholderImage:imgDefaultPicture
                                              options:SDWebImageProgressiveDownload | SDWebImageRetryFailed];
        
            strPicture = [GlobalData getUserPhoto:((GlobalData*) [GlobalData sharedData]).g_selectedUser.user_private_photo2 isThumbnail:NO];
            [m_aryPictureURL addObject:strPicture];
            [m_aryPictureController addObject:_m_imgPrivatePicture2];
        }
        
        strPicture = [GlobalData getUserPhoto:((GlobalData*) [GlobalData sharedData]).g_selectedUser.user_private_photo3 isThumbnail:YES];
        if (strPicture.length > 0) {
            [_m_imgPrivatePicture3 sd_setImageWithURL:[NSURL URLWithString:strPicture]
                                     placeholderImage:imgDefaultPicture
                                              options:SDWebImageProgressiveDownload | SDWebImageRetryFailed];
        
            strPicture = [GlobalData getUserPhoto:((GlobalData*) [GlobalData sharedData]).g_selectedUser.user_private_photo3 isThumbnail:NO];
            [m_aryPictureURL addObject:strPicture];
            [m_aryPictureController addObject:_m_imgPrivatePicture3];
        }
    }
    
    NSString* strUserProfile = @"";
    if (![((GlobalData*) [GlobalData sharedData]).g_selectedUser.user_age isEqualToNumber:[NSNumber numberWithInt:0]]) {
        strUserProfile = [NSString stringWithFormat:@"%@, %@, %@lbs, %@, %@, %@, %@",
                                [((GlobalData*) [GlobalData sharedData]).g_selectedUser.user_age stringValue],
                                ((GlobalData*) [GlobalData sharedData]).g_selectedUser.user_height,
                                [((GlobalData*) [GlobalData sharedData]).g_selectedUser.user_weight stringValue],
                                ((GlobalData*) [GlobalData sharedData]).g_selectedUser.user_ethnicity,
                                ((GlobalData*) [GlobalData sharedData]).g_selectedUser.user_body,
                                ((GlobalData*) [GlobalData sharedData]).g_selectedUser.user_practice,
                                ((GlobalData*) [GlobalData sharedData]).g_selectedUser.user_status];
    }
    [self.m_txtProfile setText:strUserProfile];
    
    [_m_txtUserIntro setText:((GlobalData*) [GlobalData sharedData]).g_selectedUser.user_intro];
    
    [self updateActionView];
    
//    [self setImgTextButton:self.mButMention];
    [self setImgTextButton:self.mButLike];
    [self setImgTextButton:self.mButUnlock];
    [self setImgTextButton:self.mButBlock];
    
    // banner view
    self.mViewBanner.adUnitID = @"ca-app-pub-8287457467886602/8489659974";
    self.mViewBanner.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    request.testDevices = @[GAD_SIMULATOR_ID];
    [self.mViewBanner loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setImgTextButton:(UIButton *)button {
    // the space between the image and text
    CGFloat spacing = 3.0;
    
    // lower the text and push it left so it appears centered
    //  below the image
    CGSize imageSize = button.imageView.frame.size;
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    // raise the image and push it right so it appears centered
    //  above the text
    CGSize titleSize = button.titleLabel.frame.size;
    button.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
}

- (void)OnClickPicture:(id) sender
{
    // Select Avatar from camera or camera roll.
    m_nPictureIndex = 0;
    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *)sender;
    CGPoint touchPos = [tapGesture locationInView:self.m_viewPictureContainter];
    
    if (CGRectContainsPoint(_m_imgAvatar.frame, touchPos))
    {
        m_nPictureIndex = 1;
    }
    
    if (CGRectContainsPoint(_m_imgPrivatePicture1.frame, touchPos))
    {
        m_nPictureIndex = 2;
    }
    
    if (CGRectContainsPoint(_m_imgPrivatePicture2.frame, touchPos))
    {
        m_nPictureIndex = 3;
    }
    
    if (CGRectContainsPoint(_m_imgPrivatePicture3.frame, touchPos))
    {
        m_nPictureIndex = 4;
    }

    if (m_nPictureIndex == 0 || m_nPictureIndex > m_aryPictureURL.count)
    {
        return;
    }
    
//    int count = (int)m_aryPictureURL.count;
    // Image Ready
//    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
//    for (int i = 0; i<count; i++)
//    {
//        // 替换为中等尺寸图片
//        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:m_aryPictureURL[i]]];
//        [photos addObject:photo];
//    }
    
    // 2.显示相册
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.currentPhotoIndex = m_nPictureIndex - 1; // 弹出相册时显示的第一张图片是？
    
    browser.displayActionButton = NO;
    
    [self.navigationController pushViewController:browser animated:YES];
//    browser.photos = photos; // 设置所有的图片
//    [browser show];
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

#pragma mark - MWPhotoBrowser
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return m_aryPictureURL.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:m_aryPictureURL[index]]];
    return photo;
}


- (IBAction)onClickBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)onClickAction:(id)sender
{
    // If this is my account, could not make action.
    if ([[GlobalData sharedData] g_selfUser].user_id.intValue == [[GlobalData sharedData] g_selectedUser].user_id.intValue)
        return;
    
    _m_viewOption.hidden = !_m_viewOption.hidden;
}

- (IBAction)onClickMention:(id)sender
{
    //TCOTS
    // Go to chat screen with user profile link.
    
    //AFTER COMMUNICATION, CHANGE label.
    [self updateActionView];
    _m_viewOption.hidden = YES;
    
    UserObj* userObj = [[GlobalData sharedData] g_selectedUser];
    
    // Go to chat screen with user profile link.
    ((GlobalData*) [GlobalData sharedData]).g_strSelectedUserProfileLink = [NSString stringWithFormat:@"@%@ ", userObj.user_name];
    
    LeveyTabBarController* rootViewController = (LeveyTabBarController*)self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
    CurrentViewController* parent = (CurrentViewController*)rootViewController.viewControllers[1];//self.parentViewController;
    [parent->m_viewCtrlChat textViewDidBeginEditing:parent->m_viewCtrlChat.messageInputView.textView];
    NSString* msg = [parent->m_viewCtrlChat.messageInputView.textView.text stringByAppendingString:[[GlobalData sharedData] g_strSelectedUserProfileLink]];
    [parent->m_viewCtrlChat.messageInputView.textView setText:msg];
    [parent->m_viewCtrlChat textViewDidChange:parent->m_viewCtrlChat.messageInputView.textView];
    
    [parent onClickChat:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickUnlock:(id)sender
{
    //TCOTS
    // ***************** SEND THE LOCK&UNLOCK ACTION AGAIN TO SERVER BASED ON THE UNLOCK STATE ***************** //
    //API : addNotificationWithUserID
    
    int flag = [[[GlobalData sharedData] g_selectedUser].user_relation_to intValue];
    int nbUnlock;
    
    if([[[GlobalData sharedData] g_selectedUser] lockedByMe]) {
        flag |= NotificationValue_IsUnlock;
        nbUnlock = 1;
    }
    else {
        flag &= ~NotificationValue_IsUnlock;
        nbUnlock = 0;
    }
    
    [SVProgressHUD showWithStatus:@"Action..." maskType:SVProgressHUDMaskTypeClear];
    [[CommAPIManager sharedCommAPIManager] unlockWithUserID:[[[GlobalData sharedData] g_selfUser].user_id stringValue]
                                                   userName:[[[GlobalData sharedData] g_selfUser] user_name]
                                                 OpponentID:[[[GlobalData sharedData] g_selectedUser].user_id stringValue]
                                                    PlaceID:[[[GlobalData sharedData] g_selfUser].user_place_id stringValue]
                                                NotifyValue:[NSString stringWithFormat:@"%d", flag]
                                                 UnlockType:[NSString stringWithFormat:@"%d", nbUnlock]
                                                  successed:^(id responseObject)
    {
           NSLog(@"%@", responseObject);
           if ([[responseObject objectForKey:WEBAPI_RETURN_RESULT] isEqualToString:WEBAPI_RETURN_SUCCESS])
           {
               [[GlobalData sharedData] g_selectedUser].user_relation_to = [NSNumber numberWithInt:flag];
               
               if ([[[GlobalData sharedData] g_selectedUser] lockedByMe])
               {
                   [SVProgressHUD showSuccessWithStatus:@"Lock has been sent."];
               }
               else
               {
                   [SVProgressHUD showSuccessWithStatus:@"Unlock has been sent."];
               }
               
               //AFTER COMMUNICATION, CHANGE label
               [self updateActionView];
               _m_viewOption.hidden = YES;
           }
           else
           {
               [SVProgressHUD dismiss];
               [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:WEBAPI_RETURN_MESSAGE]];
           }
    }
                                                             failure:^(NSError *error)
    {
//
//           //AFTER COMMUNICATION, CHANGE label
//           [self updateActionView];
//            _m_viewOption.hidden = YES;
           [SVProgressHUD dismiss];
           [SVProgressHUD showErrorWithStatus:error.description];
//           NSLog(@"%@", error);
//           
    }];
    
    NSLog(@"%d, %d", 1, ~1);
}

- (IBAction)onClickLike:(id)sender
{
    //TCOTS
    // ***************** SEND THE LIKE ACTION TO SERVER ****************** //
    //API : NUMBER
    
    [SVProgressHUD showWithStatus:@"Action..." maskType:SVProgressHUDMaskTypeClear];
    
    [[CommAPIManager sharedCommAPIManager] likeWithUserID:[[[GlobalData sharedData] g_selfUser].user_id stringValue]
                                                 userName:[[[GlobalData sharedData] g_selfUser] user_name]
                                               OpponentID:[[[GlobalData sharedData] g_selectedUser].user_id stringValue]
                                                  PlaceID:[[[GlobalData sharedData] g_selfUser].user_place_id stringValue]
                                              NotifyValue:[[[GlobalData sharedData] g_selectedUser].user_relation_to stringValue]
                                                successed:^(id responseObject)
    {
        NSLog(@"%@", responseObject);
        if ([[responseObject objectForKey:WEBAPI_RETURN_RESULT] isEqualToString:WEBAPI_RETURN_SUCCESS])
        {
            [SVProgressHUD showSuccessWithStatus:@"Like has been sent."];
            _m_viewOption.hidden = YES;
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
        NSLog(@"%@", error);
                                                               
    }];
}

- (IBAction)onClickBlock:(id)sender
{
    //TCOTS
    // ***************** SEND THE BLOCK ACTION TO SERVER BASED ON THE UNLOCK STATE ***************** //
    //API : NUMBER
    
    int flag = [[[GlobalData sharedData] g_selectedUser].user_relation_to intValue];
    int nbBlock;
    
    if([[[GlobalData sharedData] g_selectedUser] blockedByMe]) {
        flag &= ~NotificationValue_IsBlock;
        nbBlock = 0;
    }
    else {
        flag |= NotificationValue_IsBlock;
        nbBlock = 1;
    }
    
    [SVProgressHUD showWithStatus:@"Action..." maskType:SVProgressHUDMaskTypeClear];
    
    [[CommAPIManager sharedCommAPIManager] blockWithUserID:[[[GlobalData sharedData] g_selfUser].user_id stringValue]
                                                OpponentID:[[[GlobalData sharedData] g_selectedUser].user_id stringValue]
                                                   PlaceID:[[[GlobalData sharedData] g_selfUser].user_place_id stringValue]
                                               NotifyValue:[NSString stringWithFormat:@"%d", flag]
                                                 BlockType:[NSString stringWithFormat:@"%d", nbBlock]
                                                 successed:^(id responseObject)
    {
        NSLog(@"%@", responseObject);
        if ([[responseObject objectForKey:WEBAPI_RETURN_RESULT] isEqualToString:WEBAPI_RETURN_SUCCESS])
        {
           [[GlobalData sharedData] g_selectedUser].user_relation_to = [NSNumber numberWithInt:flag];
            
            if ([[[GlobalData sharedData] g_selectedUser] blockedByMe])
            {
                [SVProgressHUD showSuccessWithStatus:@"Block has been sent."];
            }
            else
            {
                [SVProgressHUD showSuccessWithStatus:@"Unblock has been sent."];
            }
            
            //AFTER COMMUNICATION, CHANGE label.
           [self updateActionView];
            _m_viewOption.hidden = YES;
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
        //AFTER COMMUNICATION, CHANGE label.
        //AFTER COMMUNICATION, CHANGE label.
        [self updateActionView];
        NSLog(@"%@", error);
    }];
}

- (void)updateActionView
{
    // initialize the action controls based on the relation object.
    
    if ([[[GlobalData sharedData] g_selectedUser] blockedByMe])
    {
        [self.mButBlock setTitle:@"unblock" forState:UIControlStateNormal];
    }
    else
    {
        [self.mButBlock setTitle:@"block" forState:UIControlStateNormal];
    }
    
    if ([[[GlobalData sharedData] g_selectedUser] lockedByMe])
    {
        [self.mButUnlock setTitle:@"unlock" forState:UIControlStateNormal];
    }
    else
    {
        [self.mButUnlock setTitle:@"lock" forState:UIControlStateNormal];
    }
}
@end
