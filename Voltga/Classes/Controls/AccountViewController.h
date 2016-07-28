//
//  AccountViewController.h
//  Voltga
//
//  Created by JackQuan on 8/5/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PECropViewController.h"

@interface AccountViewController : UIViewController<UIGestureRecognizerDelegate, PECropViewControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>
{
    // picture index for selecting picture from camera or camera roll.
    // 1: public piture (avatar)
    // 2: private picture 1, 3: private picture 2, 4: private picture 3
    int m_nPictureIndex;
}
@property (strong, nonatomic) IBOutlet UILabel *m_lblTitle;
@property (strong, nonatomic) IBOutlet UIImageView *m_imgAccountIcon;
@property (strong, nonatomic) IBOutlet UIImageView *m_imgAvatar;
@property (strong, nonatomic) IBOutlet UIImageView *m_imgPrivatePicture1;
@property (strong, nonatomic) IBOutlet UIImageView *m_imgPrivatePicture2;
@property (strong, nonatomic) IBOutlet UIImageView *m_imgPrivatePicture3;
@property (strong, nonatomic) IBOutlet UIView *m_viewPublicPicture;
@property (strong, nonatomic) IBOutlet UIView *m_viewPrivatePicture;

@property (nonatomic, retain) UIPopoverController *m_popoverController;
@property (nonatomic, retain) UIImagePickerController *m_pickerController;


- (IBAction)onClickProfile:(id)sender;
- (IBAction)onClickAccountInfo:(id)sender;

@end
