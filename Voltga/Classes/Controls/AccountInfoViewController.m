//
//  AccountInfoViewController.m
//  Voltga
//
//  Created by JackQuan on 8/5/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import "AccountInfoViewController.h"
#import "AppDelegate.h"

@interface AccountInfoViewController ()

@end

@implementation AccountInfoViewController

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
    
#pragma mark - Because we used the phone number at first for signup and signin, so used that as email address.
    _m_txtPhone.text = ((GlobalData*)[GlobalData sharedData]).g_selfUser.user_email;
//    _m_txtPhone.enabled = false;
    
    _m_txtPhone.delegate = self;
    _m_txtOldPassword.delegate = self;
    _m_txtNewPassword.delegate = self;
    _m_txtConfirmPassword.delegate = self;
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

- (IBAction)onClickBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)onClickSave:(id)sender
{
    // Check the data integrity.
#pragma mark - Because we used the phone number at first for signup and signin, so used that as email address.
    if (_m_txtPhone.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"Please input email address."];
        return;
    }
    
    if (_m_txtOldPassword.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"Please input current password"];
        return;
    }
    
    if (_m_txtNewPassword.text.length == 0 || [_m_txtNewPassword.text isEqualToString:_m_txtConfirmPassword.text] == false)
    {
        [SVProgressHUD showErrorWithStatus:@"Please input new password correctly."];
        return;
    }
    
    if (![_m_txtOldPassword.text isEqualToString:((GlobalData*) [GlobalData sharedData]).g_selfUser.user_password])
    {
        [SVProgressHUD showErrorWithStatus:@"Current password does not match. Please input correctly."];
        return;
    }
    
    UserObj* userObj = [[UserObj alloc] initWithDict:[[[GlobalData sharedData] g_selfUser] currentDict]];
    
    userObj.user_email = _m_txtPhone.text;
    userObj.user_password = _m_txtNewPassword.text;
    //TCOTS
    // ****************** SAVE USER PROFILE INFORMATION TO SERVER ****************** //
    // API : saveUserProfileWithUserObj
    
    [[CommAPIManager sharedCommAPIManager] saveUserProfileWithUserObj:userObj
                                                            successed:^(id responseObject)
    {
        if ([[responseObject objectForKey:WEBAPI_RETURN_RESULT] isEqualToString:WEBAPI_RETURN_SUCCESS])
        {
            [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:WEBAPI_RETURN_MESSAGE]];
            
            [[GlobalData sharedData] setG_selfUser:userObj];
            
            [self.navigationController popViewControllerAnimated:true];
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
    
    
    
    [self.navigationController popViewControllerAnimated:true];
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    textField.text = @"";
}


- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
