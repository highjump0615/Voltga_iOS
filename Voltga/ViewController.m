//
//  ViewController.m
//  Voltga
//
//  Created by JackQuan on 8/4/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import "ViewController.h"
#import "SignupViewController.h"
#import "AppDelegate.h"

#define BACKEND_READY
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(gotoMainViewController:) userInfo:nil repeats:false];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) gotoMainViewController:(NSTimer*) sender
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:SIGNUP_SUCCESS])
    {
#ifdef BACKEND_READY
        //TCOTS
        // *************** GET SELF USER INFORMATIONS **************** //
        // API : getUserWithUserID
        
//        [SVProgressHUD showWithStatus:@"Get informations..." maskType:SVProgressHUDMaskTypeClear];
        NSString* strUserID = [[NSUserDefaults standardUserDefaults] objectForKey:SELF_USERID];
        [[CommAPIManager sharedCommAPIManager] getUserWithUserID:strUserID
                                                       successed:^(id responseObject)
        {
            if ([[responseObject objectForKey:WEBAPI_RETURN_RESULT] isEqualToString:WEBAPI_RETURN_SUCCESS])
            {
//                [SVProgressHUD dismiss];
                
                NSLog(@"%@", responseObject);
                
                NSDictionary *userDic = [responseObject objectForKey:WEBAPI_RETURN_VALUES][@"user"];
                if ([userDic isEqual:[NSNull null]]) {
                    [self gotoSingupView];
                }
                else {
                    ((GlobalData*)[GlobalData sharedData]).g_selfUser = [[UserObj alloc] initWithDict:userDic];
                    [[AppDelegate sharedAppDelegate] initMainView];
                    [[NSNotificationCenter defaultCenter] postNotificationName:SET_TOTAL_NOTIFICATION object:nil];
                }
            }
            else
            {
//                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:WEBAPI_RETURN_MESSAGE]];
            }
            
        }
                                                         failure:^(NSError *error)
        {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:error.description];
        }];
        
        //((GlobalData*)[GlobalData sharedData]).g_selfUser = return value;
        
        // After communicate with server side for user information, the below statements will be executed.

#else
        ((GlobalData*)[GlobalData sharedData]).g_selfUser = [[UserObj alloc] initEmptyObj];
        [[AppDelegate sharedAppDelegate] initMainView];
#endif
        
    }
    else
    {
        [self gotoSingupView];
    }
}

- (void)gotoSingupView {
    SignupViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SignupViewController"];
    //
    ////        self.view.alpha = 1.0;
    ////        [UIView beginAnimations: nil context: nil];
    ////        [UIView setAnimationDuration:1.0f];
    ////        self.view.alpha = 0.0;
    ////        [UIView commitAnimations];
    ////        [[AppDelegate sharedAppDelegate].window setRootViewController:viewController];
    ////        viewController.view.alpha = 0.0;
    ////        [UIView beginAnimations: nil context: nil];
    ////        [UIView setAnimationDuration:0.75f];
    ////        viewController.view.alpha = 1.0;
    ////        [UIView commitAnimations];
    //
    //
    [self.navigationController pushViewController:viewController animated:true];
}


@end
