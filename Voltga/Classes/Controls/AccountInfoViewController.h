//
//  AccountInfoViewController.h
//  Voltga
//
//  Created by JackQuan on 8/5/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountInfoViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *m_lblTitle;
@property (strong, nonatomic) IBOutlet UITextField *m_txtPhone;
@property (strong, nonatomic) IBOutlet UITextField *m_txtNewPassword;
@property (strong, nonatomic) IBOutlet UITextField *m_txtConfirmPassword;
@property (strong, nonatomic) IBOutlet UITextField *m_txtOldPassword;

- (IBAction)onClickBack:(id)sender;
- (IBAction)onClickSave:(id)sender;

@end
