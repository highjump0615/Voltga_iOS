//
//  AVIMInstantMessagesViewController.m
//  Hollerr
//
//  Created by galaxy.d on 5/27/14.
//  Copyright (c) 2014 AVIM. All rights reserved.
//

#import "ChatViewController.h"
#import "JSMessage.h"
#import "CommAPIManager.h"
//#import "UserClient.h"
//#import "UIImageView+AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "ChatObj.h"
#import "AppDelegate.h"
#import "ChatObj.h"
#import "CurrentViewController.h"
#import "PeopleViewController.h"
#import "UserInfoViewController.h"

#import "MWPhotoBrowser.h"
#import "MWPhoto.h"

//#import "MJPhotoBrowser.h"
//#import "MJPhoto.h"



#define FONT_SIZE_NORMAL        21.f
#define DEFAULT_LENGTH          8
#define DESC_SIZE               2.f

@interface ChatViewController () <MWPhotoBrowserDelegate>
{
    int nChats;
    float fProgress;
//    AVIMTimeBombView *viewTimeBomb;
    NSTimer *timer;
    BOOL    bInTimeBomb;
    
    NSString *mPhotoURL;
}

@end

@implementation ChatViewController

@synthesize base_id;
@synthesize refreshControl;
@synthesize isReadMore;
@synthesize isReadMore_;

AppDelegate *appDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
//- (void)awakeFromNib{
    
    self.delegate = self;
    self.dataSource = self;
    
//    self.navigationHeight = CGRectGetHeight(self.m_viewNavigation.frame);
    self.navigationHeight = 568 - 449;
    [super viewDidLoad];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshChatView:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    m_aryMessages = [[NSMutableArray alloc] init];
    
    
}

- (void)refreshChatView:(UIRefreshControl*)sender{
    
    NSLog(@"%@", sender);
    [[CommAPIManager sharedCommAPIManager] getBaseChatNoWithPlaceID:[[[GlobalData sharedData] g_selfUser].user_place_id stringValue]
                                                             BaseNo:[NSString stringWithFormat:@"%d", [[GlobalData sharedData] g_currentChatBaseNo]]
                                                          successed:^(id responseObject) {
                                                              
                                                              NSLog(@"%@", responseObject);
                                                              base_id = [[[responseObject objectForKey:WEBAPI_RETURN_VALUES] objectForKey:@"base_chat_id"] intValue];
                                                              [[GlobalData sharedData] setG_currentChatBaseNo:base_id];
                                                              isReadMore = YES;
                                                              
                                                              [sender endRefreshing];
                                                              
                                                          } failure:^(NSError *error) {
                                                              
                                                              NSLog(@"%@", error);
                                                              [sender endRefreshing];
                                                              
                                                          }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[GlobalData sharedData] g_bChangedPlaceChat])
    {
        isReadMore = isReadMore_ = NO;
        nChats = 0;
        ((GlobalData*) [GlobalData sharedData]).g_strSelectedUserProfileLink = @"";
        [m_aryMessages removeAllObjects];
        ((GlobalData *)[GlobalData sharedData]).g_bChangedPlaceChat = NO;
    }
    
    if([[GlobalData sharedData] g_currentChatBaseNo] == -1)
    {
        [self.tableView setHidden:YES];
    }
}

- (void)startGetMessage
{
    int nPlaceId = [[GlobalData sharedData] g_selfUser].user_place_id.intValue;
    if (nPlaceId < 0)
    {
        return;
    }

    self.mbLoop = YES;
    
    if ([[GlobalData sharedData] g_currentChatBaseNo] == -1)
    {
        [[CommAPIManager sharedCommAPIManager] getBaseChatNoWithPlaceID:[[[GlobalData sharedData] g_selfUser].user_place_id stringValue]
                                                                 BaseNo:@""
                                                              successed:^(id responseObject) {
                                                                  
                                                                  NSLog(@"%@", responseObject);
                                                                  base_id = [[[responseObject objectForKey:WEBAPI_RETURN_VALUES] objectForKey:@"base_chat_id"] intValue];
                                                                  [[GlobalData sharedData] setG_currentChatBaseNo:base_id];
                                                                  [self getMessage];
                                                                  
                                                              } failure:^(NSError *error) {
                                                                  
                                                                  NSLog(@"%@", error);
                                                                  
                                                              }];
        
    }
    else
    {
        [self getMessage];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.mbLoop = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)getMessage
{
    
    if(isReadMore){
        isReadMore = NO;
        isReadMore_ = YES;
    }

    [[CommAPIManager sharedCommAPIManager] getAllChatsWithUserID:[[[GlobalData sharedData] g_selfUser].user_id stringValue]
                                                         PlaceID:[[[GlobalData sharedData] g_selfUser].user_place_id stringValue]
                                                      BaseChatID:[NSString stringWithFormat:@"%d", [[GlobalData sharedData] g_currentChatBaseNo]]
                                                       successed:^(id responseObject) {
                                                           
                                                           if([[responseObject objectForKey:WEBAPI_RETURN_RESULT] isEqualToString:WEBAPI_RETURN_SUCCESS]){
                                                               
                                                               
                                                               NSArray *tmpArray = [[responseObject objectForKey:WEBAPI_RETURN_VALUES] objectForKey:@"chats"];
                                                               
//                                                               [m_aryMessages removeAllObjects];
                                                               for (NSDictionary *dic in tmpArray)
                                                               {
                                                                   NSString *strChatId = [dic objectForKey:@"chat_msg_id"];
                                                                   BOOL bAdd = YES;

                                                                   for (ChatObj *cData in m_aryMessages)
                                                                   {
                                                                       if ([cData.chat_msg_id isEqualToString:strChatId])
                                                                       {
                                                                           bAdd = NO;
                                                                           break;
                                                                       }
                                                                   }
                                                                   
                                                                   if (bAdd)
                                                                   {
                                                                       //
                                                                       // add object according to its time
                                                                       //
                                                                       ChatObj *chatObj = [[ChatObj alloc] initWithDict:dic];
                                                                       
                                                                       if (![chatObj.chat_place_id isEqualToNumber:[[GlobalData sharedData] g_selfUser].user_place_id]) {
                                                                           continue;
                                                                       }
                                                                       
                                                                       int nIndex;
                                                                       for (nIndex = 0; nIndex < m_aryMessages.count; nIndex++) {
                                                                           
                                                                           ChatObj *cObj = [m_aryMessages objectAtIndex:nIndex];
                                                                           if ([cObj.chat_created compare:chatObj.chat_created] == NSOrderedDescending) {
                                                                               break;
                                                                           }
                                                                       }
                                                                       
                                                                       [m_aryMessages insertObject:chatObj atIndex:nIndex];;
                                                                   }
                                                               }
                                                               
                                                               if (m_aryMessages.count > 0)
                                                               {
                                                                   [self reloadTable];
                                                                   [self.tableView setHidden:NO];
                                                               }
                                                           }
//                                                           NSLog(@"%@", responseObject);
                                                           
                                                           if (self.mbLoop)
                                                           {
                                                               [self performSelector:@selector(getMessage) withObject:nil afterDelay:0.5f];
                                                           }
                                                        }
                                                        failure:^(NSError *error)
                                                        {
                                                           NSLog(@"%@", error);
                                                            
                                                           if (self.mbLoop)
                                                           {
                                                               [self performSelector:@selector(getMessage) withObject:nil afterDelay:0.5f];
                                                           }
                                                        }];
}


-(void)dealloc{

    [timer invalidate];
}

- (void)reloadTable
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self.tableView reloadData];
    
    if((nChats != m_aryMessages.count) && (m_aryMessages.count != 0))
    {
        nChats = (int)m_aryMessages.count;
        if(!isReadMore_){
            
            NSIndexPath *ip = [NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:0] - 1 inSection:0];
            //        NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
            
            [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
        } else {
            
            isReadMore_ = NO;
            [self.refreshControl endRefreshing];
        }

    }
}

#pragma mark table view

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return m_aryMessages.count;
}

- (NSString *)getCurrentTimeStamp
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    return dateString;
}


//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)didSendText:(NSString *)text onDate:(NSDate *)date
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    int nPlaceId = [[GlobalData sharedData] g_selfUser].user_place_id.intValue;
    if (nPlaceId < 0)
    {
        return;
    }
    
    if ([text length] > 0) {

        if ([text length] > 140) text = [text substringToIndex:140];
        
        ChatObj *chatObj = [[ChatObj alloc] initEmptyObj];
        chatObj.chat_user_id = [[GlobalData sharedData] g_selfUser].user_id;
        chatObj.chat_user = [[GlobalData sharedData] g_selfUser];
        chatObj.chat_place_id = [[GlobalData sharedData] g_selfUser].user_place_id;
        chatObj.chat_type = [NSNumber numberWithInt:chatTypeText];
        
        chatObj.chat_msg_id = [NSString stringWithFormat:@"%d_%@", [chatObj.chat_user_id intValue], [self getCurrentTimeStamp]];
        
        chatObj.chat_content = text;
        chatObj.chat_created = [NSDate date];
        [[CommAPIManager sharedCommAPIManager] sendChatWithChatObj:chatObj successed:^(id responseObject)
                                                                            {
                                                                                NSLog(@"%@", responseObject);
                                                                            }
                                                                            failure:^(NSError *error)
                                                                            {
                                                                                NSLog(@"%@", error);
                                                                            }];
        
        [JSMessageSoundEffect playMessageSentSound];
        
        NSLog(@"Chat Added ");
        [m_aryMessages addObject:chatObj];
    }

	[self finishSend];
	[self.view endEditing:YES];
    
    [self reloadTable];
}

- (void)didSelectedSubString:(NSString *)text{
    
    CurrentViewController* parent = (CurrentViewController*)self.parentViewController;
    
    for(UserObj* userObj in parent->m_viewCtrlPeople->m_aryPeople){
        
        NSString* profileLink = userObj.user_name;// stringByAppendingString:userObj.user_phone];
        if([text isEqualToString:profileLink]){
            
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
        
    }
    
}

#pragma - mark JSMessagesViewDelegate
- (void)didTapAvatar:(int)index{
    
    ChatObj* chatObj = [m_aryMessages objectAtIndex:index];
    UserObj* userObj = chatObj.chat_user;
    
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

#pragma - mark JSMessagesViewDelegate
- (void)didDblTapAvatar:(int)index
{
    ChatObj* chatObj = [m_aryMessages objectAtIndex:index];
    UserObj* userObj = chatObj.chat_user;
    
    // Go to chat screen with user profile link.
    ((GlobalData*) [GlobalData sharedData]).g_strSelectedUserProfileLink = [NSString stringWithFormat:@"@%@ ", userObj.user_name];
    
    
    [self textViewDidBeginEditing:self.messageInputView.textView];
    NSString* msg = [self.messageInputView.textView.text stringByAppendingString:[[GlobalData sharedData] g_strSelectedUserProfileLink]];
    [self.messageInputView.textView setText:msg];
    [self textViewDidChange:self.messageInputView.textView];
}

- (void)didTapPhoto:(NSString *)photo_url{
    
    NSLog(@"%@", photo_url);
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    mPhotoURL = photo_url;
    
    browser.displayActionButton = NO;
    
    [self.navigationController pushViewController:browser animated:YES];

    
}

- (void)didClickPlayButton:(NSInteger)nRow audioView:(UIView *)view
{
}

- (void) OnTimerPlay:(NSTimer *)playerTimer
{
}

- (void)didLongTapOnTimeBombStart:(NSInteger)nRow
{
//    if(_globalData.bIsInTimeBomb)   return;
//    
//    NSLog(@"Selected Row: %d", (int)nRow);
//    
//    ChatObj *chatObj = [m_aryMessages objectAtIndex:nRow];
//    
//    if(chatObj.chat_from_user_id == [[GlobalData sharedData] selfUser].user_id)
//        return;
//    
//    
//    viewTimeBomb = [[[NSBundle mainBundle] loadNibNamed:@"AVIMTimeBombView" owner:self options:nil] objectAtIndex:0];
//    [viewTimeBomb.m_imgBackground setImageWithURL:[NSURL URLWithString:chatObj.chat_media_url]];
//    [viewTimeBomb.m_lblCaption setText:chatObj.chat_data];
//    viewTimeBomb.chatObj = chatObj;
//    
//    _globalData.bIsInTimeBomb = YES;
//    [self.view addSubview:viewTimeBomb];
//    [viewTimeBomb OnDownButton:nil];
}

- (void)didLongTapOnTimeBombEnd:(NSInteger)nRow
{
    
//    if(!_globalData.bIsInTimeBomb)   return;
//    
//    NSLog(@"Selected Row: %d", (int)nRow);
//    
//    ChatObj *chatObj = [m_aryMessages objectAtIndex:nRow];
//    
//    if(chatObj.chat_from_user_id == [[GlobalData sharedData] selfUser].user_id)
//        return;
//
//    [viewTimeBomb removeFromSuperview];
//    [viewTimeBomb OnUpButton:nil];
//    
//    _globalData.bIsInTimeBomb = NO;
    
    
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)didSendPhoto:(NSString *)photoURL onDate:(NSDate *)date width:(int)nWidth height:(int)nHeight
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    int nPlaceId = [[GlobalData sharedData] g_selfUser].user_place_id.intValue;
    if (nPlaceId < 0)
    {
        return;
    }
    
    ChatObj *chatObj = [[ChatObj alloc] initEmptyObj];
    chatObj.chat_user_id = [[GlobalData sharedData] g_selfUser].user_id;
    chatObj.chat_place_id = [[GlobalData sharedData] g_selfUser].user_place_id;
    chatObj.chat_type = [NSNumber numberWithInt:chatTypeImage];
    chatObj.chat_content = @"Sent Photo";
    chatObj.chat_media_url = photoURL;
    chatObj.chat_image_width = [NSNumber numberWithInt:nWidth];
    chatObj.chat_image_height = [NSNumber numberWithInt:nHeight];
    chatObj.chat_created = [NSDate date];
    
    chatObj.chat_msg_id = [NSString stringWithFormat:@"%d_%@", [chatObj.chat_user_id intValue], [self getCurrentTimeStamp]];
    
    [[CommAPIManager sharedCommAPIManager] sendChatWithChatObj:chatObj successed:^(id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
    chatObj.chat_media_url = [NSString stringWithFormat:@"%@%@", VOLTGA_BASE_FILE_URL, photoURL];
    
	[JSMessageSoundEffect playMessageSentSound];
    
	[self finishSend];
//	[self.view endEditing:YES];
    
    [m_aryMessages addObject:chatObj];
    [self reloadTable];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)didSendAudio:(NSString *)audioURL onDate:(NSDate *)date
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
//    ChatObj *chatObj = [[ChatObj alloc] initEmptyObj];
//    chatObj.chat_from_user_id = _globalData.userID;
//    chatObj.chat_to_user_id = [NSNumber numberWithInt:[_globalData.chatUserID intValue]];
//    chatObj.chat_type = [NSNumber numberWithInt:(int)chatTypeSound];
//    chatObj.chat_media_url = audioURL;
//    
//    [[UserClient sharedClient] sendChatWithUserID:[_globalData.userID stringValue]
//                                          ChatOBJ:chatObj
//                                        successed:^(id responseObject) {
//                                            if([[responseObject objectForKey:WEBAPI_RETURN_ACTION] isEqualToString:WEBAPI_SENDCHAT])
//                                            {
//                                                if([[responseObject objectForKey:WEBAPI_RETURN_RESULT] isEqualToString:WEBAPI_RETURN_SUCCEED])
//                                                {
//                                                    NSLog(@"Chat Sent");
//                                                }
//                                                else
//                                                {
//                                                    [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:WEBAPI_RETURN_MESSAGE]];
//                                                }
//                                            }
//                                        } failure:^(NSError *error) {
//                                            [SVProgressHUD showErrorWithStatus:@"Sever connect error"];
//                                        }];
    
	[JSMessageSoundEffect playMessageSentSound];
    
    [self finishSend];
}


//-------------------------------------------------------------------------------------------------------------------------------------------------
- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	ChatObj *chatObj = [m_aryMessages objectAtIndex:indexPath.row];
    
//    int uid1 = [chatObj.chat_user_id intValue];

	return ([chatObj.chat_user_id intValue] == [[[GlobalData sharedData] g_selfUser].user_id intValue])
    ? JSBubbleMessageTypeOutgoing
    : JSBubbleMessageTypeIncoming;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UIImageView *)bubbleImageViewWithType:(JSBubbleMessageType)type forRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	ChatObj *chatObj = [m_aryMessages objectAtIndex:indexPath.row];
    
	int uid1 = [chatObj.chat_user_id intValue];

    UIImageView *bubbleImageView;

    if([chatObj.chat_type intValue] == chatTypeSound)
    {
        bubbleImageView = [JSBubbleImageViewFactory classicBubbleImageViewForType:type style:JSBubbleImageViewStyleClassicGray];
    }
    else if([chatObj.chat_type intValue] == chatTypeBomb)
    {
        bubbleImageView = [JSBubbleImageViewFactory classicBubbleImageViewForType:type style:JSBubbleImageViewStyleClassicSquareBlue];
    }
    else
    {
        bubbleImageView = (uid1 != [[[GlobalData sharedData] g_selfUser].user_id intValue]) ?
//                                    [JSBubbleImageViewFactory classicBubbleImageViewForType:type style:JSBubbleImageViewStyleClassicGreen] :
                                    [JSBubbleImageViewFactory classicBubbleImageViewForType:type style:JSBubbleImageViewStyleClassicSquareBlue] :
//                                    [JSBubbleImageViewFactory classicBubbleImageViewForType:type style:JSBubbleImageViewStyleClassicBlue];
                                    [JSBubbleImageViewFactory classicBubbleImageViewForType:type style:JSBubbleImageViewStyleClassicSquareGray];
    }

	return bubbleImageView;
    
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (JSMessageInputViewStyle)inputViewStyle
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return JSMessageInputViewStyleFlat;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    return NO;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)configureCell:(JSBubbleMessageCell *)cell atIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
//	if ([cell messageType] == JSBubbleMessageTypeOutgoing)
//	{
//		if ([cell.bubbleView.textView respondsToSelector:@selector(linkTextAttributes)])
//		{
//			NSMutableDictionary *attributes = [cell.bubbleView.textView.linkTextAttributes mutableCopy];
//			[attributes setValue:[UIColor blueColor] forKey:NSForegroundColorAttributeName];
//			cell.bubbleView.textView.linkTextAttributes = attributes;
//		}
//	}
//    
////    [cell.bubbleView.textView setTextColor:[UIColor whiteColor]];
//    
//	if (cell.timestampLabel)
//	{
//		cell.timestampLabel.textColor = [UIColor whiteColor];
//		cell.timestampLabel.shadowOffset = CGSizeZero;
//	}
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return YES;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)allowsPanToDismissKeyboard
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return YES;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (JSMessage *)messageForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	ChatObj *chatObj = [m_aryMessages objectAtIndex:indexPath.row];
    
    NSString *strDate = nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy HH:mm"];
    
    if (indexPath.row == 0) {
        strDate = [formatter stringFromDate:chatObj.chat_created];
    }
    else {
        // calc the difference
        ChatObj *chatObjPrev = [m_aryMessages objectAtIndex:indexPath.row - 1];
        
        NSInteger nMinDiff = [chatObj.chat_created timeIntervalSinceDate:chatObjPrev.chat_created] / 60;
        if (nMinDiff >= 10) {
            strDate = [formatter stringFromDate:chatObj.chat_created];
        }
    }
    
    return [[JSMessage alloc] initWithMessage:chatObj.chat_content
                                        photo:chatObj.chat_media_url
                                         type:[chatObj.chat_type intValue]
                                         date:strDate
                                        width:chatObj.chat_image_width
                                       height:chatObj.chat_image_height];
    
    return [[JSMessage alloc] init];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UIImageView *)avatarImageViewForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	ChatObj *chatObj = [m_aryMessages objectAtIndex:indexPath.row];
	
	UIImageView *imageView = [[UIImageView alloc] init];
	
    UIImage* imgDefaultAvatar = [UIImage imageNamed:@"img_default_user.png"];
    if([chatObj.chat_user_id intValue] == [[[GlobalData sharedData] g_selfUser].user_id intValue])
    {
        NSString *strPublicPicture = [GlobalData getUserPhoto:[[GlobalData sharedData] g_selfUser].user_public_photo isThumbnail:YES];
        [imageView sd_setImageWithURL:[NSURL URLWithString:strPublicPicture]
                     placeholderImage:imgDefaultAvatar
                              options:SDWebImageProgressiveDownload | SDWebImageRetryFailed];
        
    }
    else
    {
        NSString *strPublicPicture = [GlobalData getUserPhoto:chatObj.chat_user.user_public_photo isThumbnail:YES];
        [imageView sd_setImageWithURL:[NSURL URLWithString:strPublicPicture]
                     placeholderImage:imgDefaultAvatar
                              options:SDWebImageProgressiveDownload | SDWebImageRetryFailed];
    }
    
//	imageView.layer.cornerRadius = kJSAvatarImageSize / 2;
//	imageView.layer.masksToBounds = YES;
    [imageView setTag:indexPath.row];

	
	return imageView;
}

#pragma mark -- Right edge function
- (void)handleLeftEdgeGesture:(UIScreenEdgePanGestureRecognizer *)gesture
{
    // Get the current view we are touching
//    
//    if(UIGestureRecognizerStateBegan == gesture.state ||
//       UIGestureRecognizerStateChanged == gesture.state) {
//        
//        //        [self.navigationController popViewControllerAnimated:true];
//        [self OnClickBtnBack:self];
//        
//    } else {// cancel, fail, or ended
//        // Animate back to center x
//        [UIView animateWithDuration:.3 animations:^{
//            
//        }];
//    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // You can customize the way in which gestures can work
    // Enabling multiple gestures will allow all of them to work together, otherwise only the topmost view's gestures will work (i.e. PanGesture view on bottom)
    return YES;
}
//
//- (void)onTapAvatar:(UITapGestureRecognizer*) tapGuesture{
//    
//    int index = [tapGuesture view].tag;
//    ChatObj *chatObj = [m_aryMessages objectAtIndex:index];
//    UserObj* userObj = chatObj.chat_user;
//    
//    NSLog(@"%@", userObj);
//
//    
//}

- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

#pragma mark - MWPhotoBrowser
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return 1;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:mPhotoURL]];
    return photo;
}


@end
