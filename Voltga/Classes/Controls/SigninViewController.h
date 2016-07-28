//
//  SigninViewController.h
//  Voltga
//
//  Created by JackQuan on 8/15/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SigninViewController : UIViewController<UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *m_txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *m_txtPassword;
- (IBAction)onClickDone:(id)sender;
- (IBAction)onClickForgotPassword:(id)sender;
- (IBAction)onClickBack:(id)sender;

@end
