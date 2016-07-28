//
//  SignupViewController.m
//  Voltga
//
//  Created by JackQuan on 8/5/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import "SignupViewController.h"
#import "AppDelegate.h"
#import "SigninViewController.h"
#import "PhotoActionSheetView.h"

@interface SignupViewController () <PhotoActionDelegate> {
    PhotoActionSheetView *mActionsheetView;
}

@property (weak, nonatomic) IBOutlet UIView *mViewActionsheet;

@end

@implementation SignupViewController
@synthesize m_pickerController;
@synthesize m_popoverController;

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
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnClickAvatar:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    _m_txtPassword.delegate = self;
    _m_txtConfirm.delegate = self;
    
    m_bAvatar = false;
    
    mActionsheetView = (PhotoActionSheetView *)[PhotoActionSheetView initView:self.view];
    mActionsheetView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) OnClickAvatar:(id) sender
{
    // Remove keyboard.
    [_m_txtPassword resignFirstResponder];
    [_m_txtConfirm resignFirstResponder];
    
    // Select Avatar from camera or camera roll.
    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *)sender;
    CGPoint touchPos = [tapGesture locationInView:self.m_viewAvatar];
    
    if (CGRectContainsPoint(_m_imgAvatar.frame, touchPos))
    {
//        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
//                                                                 delegate:self
//                                                        cancelButtonTitle:@"Cancel"
//                                                   destructiveButtonTitle:nil
//                                                        otherButtonTitles:@"Camera", @"Image Gallary", nil];
//        
////        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
//        [actionSheet showInView:self.view];
        
        if (![mActionsheetView isShowing]) {
            [mActionsheetView showView];
        }
    }
}
//TCOTS
#define BACKEND_READY
- (IBAction)onClickDone:(id)sender
{
    // Check date integrity.
    if (_m_txtUserName.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"Please input user name. it must be an unique one."];
        return;
    }
    else
    {
        NSRange whiteSpaceRange = [_m_txtUserName.text rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
        if (whiteSpaceRange.location != NSNotFound)
        {
            [SVProgressHUD showErrorWithStatus:@"Username should not contain space."];
            return;
        }
    }
    
//    if (_m_txtEmailAddress.text.length == 0)
//    {
//        _m_txtEmailAddress.text = @"";
//        [SVProgressHUD showErrorWithStatus:@"Please input your email. it must be an unique one."];
//        return;
//    }
    
    if (_m_txtPassword.text.length == 0 || _m_txtConfirm.text.length == 0 || ![_m_txtPassword.text isEqualToString:_m_txtConfirm.text])
    {
        [SVProgressHUD showErrorWithStatus:@"Please input password correctly."];
        return;
    }
    
    if (m_bAvatar == false)
    {
        [SVProgressHUD showErrorWithStatus:@"Please select profile picture."];
        return;
    }
    
    if (_m_txtEmailAddress.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"Please input the email address correctly, it will be used to recovery password."];
        return;
    }
 
    NSData* userAvatar = UIImageJPEGRepresentation(_m_imgAvatar.image, 1.0f);
    NSData* userThumbnailAvatar = userAvatar;
    
    double dTargetSize = 1024 * 100;
    double dRatio = 1;
    NSUInteger nOldSize = 0;
    
    while (userAvatar.length > dTargetSize)  // size over 100KB
    {
        dRatio *= dTargetSize / userAvatar.length;
        userAvatar = UIImageJPEGRepresentation(_m_imgAvatar.image, dRatio);
        userThumbnailAvatar = userAvatar;
        
        if (nOldSize > 0 && nOldSize == userAvatar.length) {
            // already minimum, so break
            break;
        }
        
        nOldSize = userAvatar.length;
    }
    
    double dWidth = [_m_imgAvatar.image size].width;
    double dHeight = [_m_imgAvatar.image size].height;
    if (dWidth > 150 || dHeight > 150)
    {
        UIImage* convertImage = [GlobalData imageWithImage:_m_imgAvatar.image scaledToSize:CGSizeMake(75, 75)];
        userThumbnailAvatar = UIImageJPEGRepresentation(convertImage, 0.5f);
    }
    
    //TCOTS
    // ************************* SAVE PROFILE TO SERVER************************** //
    // API :

#if TARGET_IPHONE_SIMULATOR
//    ((GlobalData*)[GlobalData sharedData]).g_strDeviceToken = @"test device token from simulator";
    ((GlobalData*)[GlobalData sharedData]).g_strDeviceToken = @"";
#endif

#ifdef BACKEND_READY
    [SVProgressHUD showWithStatus:@"Sign up ..." maskType:SVProgressHUDMaskTypeClear];
    
    [[CommAPIManager sharedCommAPIManager] userSignUpWithUserName:_m_txtUserName.text
                                                        UserEmail:_m_txtEmailAddress.text
                                                     UserPassword:_m_txtPassword.text
                                                        UserToken:((GlobalData*)[GlobalData sharedData]).g_strDeviceToken
                                                      PublicPhoto:userAvatar
                                                 PublicPhotoThumb:userThumbnailAvatar
                                                        successed:^(id responseObject)
    {
        if ([[responseObject objectForKey:WEBAPI_RETURN_RESULT] isEqualToString:WEBAPI_RETURN_SUCCESS])
        {
            [SVProgressHUD showSuccessWithStatus:@"Signup success!"];
            
            // Initialize the user object based on return value.
            ((GlobalData*)[GlobalData sharedData]).g_selfUser = [[UserObj alloc] initWithDict:responseObject[WEBAPI_RETURN_VALUES][@"user"]];
            
            // Save user phone and flag of signed into NSUserDefaults
            [[NSUserDefaults standardUserDefaults] setObject:[((GlobalData*)[GlobalData sharedData]).g_selfUser.user_id stringValue] forKey:SELF_USERID];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SIGNUP_SUCCESS];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // Navigate into main view.
            [[AppDelegate sharedAppDelegate] initMainView];
        }
        else
        {
//            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:responseObject[WEBAPI_RETURN_MESSAGE]];
        }
        
    }
                                                          failure:^(NSError *error)
    {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.description];
    }];
#else
    // Initialize the user object based on return value.
    ((GlobalData*)[GlobalData sharedData]).g_selfUser = [[UserObj alloc] initWithDict:responseObject[WEBAPI_RETURN_VALUES]];
    
    // Save user phone and flag of signed into NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:SIGNUP_PHONENUMBER forKey:_m_txtPhone.text];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SIGNUP_SUCCESS];
#endif
}

- (IBAction)onClickSignin:(id)sender
{
    SigninViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SigninViewController"];
    [self.navigationController pushViewController:viewController animated:true];
}

#pragma mark -- UITextFieldDelegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    [textField setText:@""];
}

#pragma mark -- PhotoActionDelegate 
- (void)onButPhoto {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    if(m_popoverController != nil) {
        [m_popoverController dismissPopoverAnimated:YES];
        m_popoverController = nil;
    }
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            m_popoverController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
            m_popoverController.delegate = self;
            [m_popoverController presentPopoverFromRect:CGRectMake(0, 0, 1024, 160)
                                                 inView:self.view
                               permittedArrowDirections:UIPopoverArrowDirectionAny
                                               animated:YES];
        }
        else {
            
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }
}

- (void)onButCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}


#pragma mark -- UIActionSheetDelegate

//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    switch (buttonIndex)
//    {
//        case 0:
//        {
//            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//                
//                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//                picker.delegate = self;
//                
//                [self presentViewController:picker animated:YES completion:nil];
//            }
//            
//            break;
//        }
//            
//        case 1:
//        {
//            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//            imagePicker.delegate = self;
//            if(m_popoverController != nil) {
//                [m_popoverController dismissPopoverAnimated:YES];
//                m_popoverController = nil;
//            }
//            
//            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
//            {
//                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//                {
//                    m_popoverController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
//                    m_popoverController.delegate = self;
//                    [m_popoverController presentPopoverFromRect:CGRectMake(0, 0, 1024, 160)
//                                                         inView:self.view
//                                       permittedArrowDirections:UIPopoverArrowDirectionAny
//                                                       animated:YES];
//                }
//                else {
//                    
//                    [self presentViewController:imagePicker animated:YES completion:nil];
//                }
//            }
//            
//            break;
//        }
//            
//        default:
//            break;
//    }
//}

#pragma mark - image picker controller

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *imgUserAvatar = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.m_pickerController = picker;
    
    [self openEditor:imgUserAvatar];
}

# pragma mark - Open Crop View Controller

- (void) openEditor:(UIImage *) editImage {
    
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = editImage;
    controller.cropAspectRatio = 1.0f;
    controller.toolbarHidden = YES;
    controller.keepingCropAspectRatio = YES;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.m_pickerController presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - PECropViewController Delegate
- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    [controller dismissViewControllerAnimated:YES completion:^(void) {

        [_m_imgAvatar setImage:croppedImage];
        m_imgUserAvatar = croppedImage;
        m_bAvatar = true;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            [m_popoverController dismissPopoverAnimated:YES];
        else
            [self.m_pickerController dismissViewControllerAnimated:YES completion:nil];
        
    }];
}

- (void) cropViewControllerDidCancel:(PECropViewController *) controller {
    
    [controller dismissViewControllerAnimated:YES completion:^(void) {}];
}


@end
