//
//  SigninViewController.m
//  Voltga
//
//  Created by JackQuan on 8/15/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import "SigninViewController.h"
#import "AppDelegate.h"

#define BACKEND_READY
@interface SigninViewController ()

@end

@implementation SigninViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)onClickDone:(id)sender
{
    
    // Check data integrity.
#pragma mark - Because we used the phone number at first for signup and signin, so used that as email address.
    if (_m_txtEmail.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"Please input email address."];
        return;
    }
    
    if (_m_txtPassword.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"Please input password."];
        return;
    }
    
#if TARGET_IPHONE_SIMULATOR
//    ((GlobalData*)[GlobalData sharedData]).g_strDeviceToken = @"test device token from simulator";
    ((GlobalData*)[GlobalData sharedData]).g_strDeviceToken = @"";
#endif
    
    // ************************** LOGIN ************************* //
    //API : userSignInWithUserPhone
#ifdef BACKEND_READY
    
    [SVProgressHUD showWithStatus:@"Sign in ..." maskType:SVProgressHUDMaskTypeClear];
    
    [[CommAPIManager sharedCommAPIManager] userSignInWithUserEmail:_m_txtEmail.text
                                                      UserPassword:_m_txtPassword.text
                                                         UserToken:((GlobalData*)[GlobalData sharedData]).g_strDeviceToken
                                                         successed:^(id responseObject)
    {
        if ([[responseObject objectForKey:WEBAPI_RETURN_RESULT] isEqualToString:WEBAPI_RETURN_SUCCESS])
        {
            // Initialize the user object based on return value.
            ((GlobalData*)[GlobalData sharedData]).g_selfUser = [[UserObj alloc] initWithDict:responseObject[WEBAPI_RETURN_VALUES][@"user"]];
            
            // Save user phone and flag of signed into NSUserDefaults
            [[NSUserDefaults standardUserDefaults] setObject:[((GlobalData*)[GlobalData sharedData]).g_selfUser.user_id stringValue] forKey:SELF_USERID];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SIGNUP_SUCCESS];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // Navigate into main view.
            [[AppDelegate sharedAppDelegate] initMainView];
            
            [SVProgressHUD dismiss];
        }
        else
        {
//            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:responseObject[WEBAPI_RETURN_MESSAGE]];
        }
    }
                                                           failure:^(NSError *error)
    {
//        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.description];
    }];
#else
    
#endif
    }

- (IBAction)onClickForgotPassword:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Please input the email address." message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 10000;
    [alert show];
}

- (IBAction)onClickBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:true];
}

#pragma - mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *strEmail = [[alertView textFieldAtIndex:0] text];
    if (alertView.tag == 10000)
    {
        if (buttonIndex == 0)
        {
            // ********************* FORGOT PASSWORD ************************* //
            // API : getPasswordWithUserEmail
            [[CommAPIManager sharedCommAPIManager] getPasswordWithUserEmail:strEmail
                                                                  successed:^(id responseObject)
            {
                if ([[responseObject objectForKey:WEBAPI_RETURN_RESULT] isEqualToString:WEBAPI_RETURN_SUCCESS])
                {
                    [SVProgressHUD showSuccessWithStatus:@"Please check your email box."];
                }
                else
                {
                    [SVProgressHUD dismiss];
                    [SVProgressHUD showErrorWithStatus:responseObject[WEBAPI_RETURN_MESSAGE]];
                }
            }
                                                                    failure:^(NSError *error)
            {
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:error.description];
            }];
        }
    }
}
@end
