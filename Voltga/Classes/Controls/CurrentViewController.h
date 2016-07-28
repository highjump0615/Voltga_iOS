//
//  CurrentViewController.h
//  Voltga
//
//  Created by JackQuan on 8/5/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeopleViewController.h"
#import "ChatViewController.h"
#import "NotificationViewController.h"
#import "GAITrackedViewController.h"

@interface CurrentViewController : GAITrackedViewController
{
@public
    PeopleViewController*           m_viewCtrlPeople;
    ChatViewController*             m_viewCtrlChat;
    NotificationViewController*     m_viewCtrlNotification;
}

@property (strong, nonatomic) IBOutlet UILabel *m_lblPlaceTitle;
@property (strong, nonatomic) IBOutlet UIImageView *m_imgPlacePicture;
@property (strong, nonatomic) IBOutlet UIButton *m_btnPeople;
@property (strong, nonatomic) IBOutlet UIButton *m_btnChat;
@property (strong, nonatomic) IBOutlet UIButton *m_btnNotification;
@property (strong, nonatomic) IBOutlet UIButton *m_btnBadge;

@property (strong, nonatomic) IBOutlet UIView *m_viewMain;

- (IBAction)onClickPeople:(id)sender;
- (IBAction)onClickChat:(id)sender;
- (IBAction)onClickNotification:(id)sender;



@end
