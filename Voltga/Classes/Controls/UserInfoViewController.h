//
//  UserInfoViewController.h
//  Voltga
//
//  Created by JackQuan on 8/5/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoViewController : UIViewController<UIGestureRecognizerDelegate>
{
    // picture index for selecting picture.
    // 1: public piture (avatar)
    // 2: private picture 1, 3: private picture 2, 4: private picture 3
    int m_nPictureIndex;
    
    NSMutableArray*         m_aryPictureURL;
    NSMutableArray*         m_aryPictureController;
}
@property (strong, nonatomic) IBOutlet UILabel*         m_lblUserName;
@property (strong, nonatomic) IBOutlet UIImageView*     m_imgPublicPicture;
@property (strong, nonatomic) IBOutlet UIImageView*     m_imgAvatar;
@property (strong, nonatomic) IBOutlet UIImageView*     m_imgPrivatePicture1;
@property (strong, nonatomic) IBOutlet UIImageView*     m_imgPrivatePicture2;
@property (strong, nonatomic) IBOutlet UIImageView*     m_imgPrivatePicture3;
@property (strong, nonatomic) IBOutlet UITextView*      m_txtProfile;
@property (strong, nonatomic) IBOutlet UITextView*      m_txtUserIntro;
@property (strong, nonatomic) IBOutlet UIView*          m_viewOption;
@property (strong, nonatomic) IBOutlet UIButton*        m_btnAction;

//@property (strong, nonatomic) IBOutlet UILabel*         m_lblMention;
//@property (strong, nonatomic) IBOutlet UILabel*         m_lblUnlock;
//@property (strong, nonatomic) IBOutlet UILabel*         m_lblLike;
//@property (strong, nonatomic) IBOutlet UILabel*         m_lblBlock;
@property (strong, nonatomic) IBOutlet UIView *m_viewPictureContainter;


- (IBAction)onClickBack:(id)sender;
- (IBAction)onClickAction:(id)sender;
- (IBAction)onClickMention:(id)sender;
- (IBAction)onClickUnlock:(id)sender;
- (IBAction)onClickLike:(id)sender;
- (IBAction)onClickBlock:(id)sender;


@end
