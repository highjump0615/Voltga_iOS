//
//  SignupViewController.h
//  Voltga
//
//  Created by JackQuan on 8/5/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PECropViewController.h"

@interface SignupViewController : UIViewController<UITextFieldDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, PECropViewControllerDelegate>
{
    BOOL            m_bAvatar;
    UIImage*        m_imgUserAvatar;
}
@property (strong, nonatomic) IBOutlet UILabel *m_lblTitle;
@property (strong, nonatomic) IBOutlet UITextField *m_txtPassword;
@property (strong, nonatomic) IBOutlet UITextField *m_txtConfirm;
@property (strong, nonatomic) IBOutlet UIImageView *m_imgAvatar;
@property (strong, nonatomic) IBOutlet UIView *m_viewAvatar;
@property (strong, nonatomic) IBOutlet UITextField *m_txtUserName;
@property (strong, nonatomic) IBOutlet UITextField *m_txtEmailAddress;

@property (nonatomic, retain) UIPopoverController *m_popoverController;
@property (nonatomic, retain) UIImagePickerController *m_pickerController;


- (IBAction)onClickDone:(id)sender;
- (IBAction)onClickSignin:(id)sender;

@end
