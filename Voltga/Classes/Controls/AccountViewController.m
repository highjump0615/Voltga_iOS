//
//  AccountViewController.m
//  Voltga
//
//  Created by JackQuan on 8/5/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import "AccountViewController.h"
#import "AccountInfoViewController.h"
#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
//#import "UIImageView+AFNetworking.h"
#import "PhotoActionSheetView.h"

@interface AccountViewController () <PhotoActionDelegate> {
    PhotoActionSheetView *mActionsheetView;
}

@end

@implementation AccountViewController

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
    
    // Initialize the controls based on user account info.
    UIImage* imgDefaultAvatar = [UIImage imageNamed:@"img_default_user.png"];
    
    UserObj *currentUser = ((GlobalData*)[GlobalData sharedData]).g_selfUser;
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnClickPicture:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];

    [_m_imgAvatar sd_setImageWithURL:[NSURL URLWithString:[GlobalData getUserPhoto:currentUser.user_public_photo isThumbnail:YES]]
                    placeholderImage:imgDefaultAvatar
                             options:SDWebImageProgressiveDownload | SDWebImageRetryFailed];

    
//    if (((GlobalData*)[GlobalData sharedData]).g_selfUser.user_privatepicture.count >= 1)
//    {
        [_m_imgPrivatePicture1 sd_setImageWithURL:[NSURL URLWithString:[GlobalData getUserPhoto:currentUser.user_private_photo1 isThumbnail:YES]]
                                 placeholderImage:imgDefaultAvatar
                                          options:SDWebImageProgressiveDownload | SDWebImageRetryFailed];
//    }
//    
//    if (((GlobalData*)[GlobalData sharedData]).g_selfUser.user_privatepicture.count >= 2)
//    {
        [_m_imgPrivatePicture2 sd_setImageWithURL:[NSURL URLWithString:[GlobalData getUserPhoto:currentUser.user_private_photo2 isThumbnail:YES]]
                                 placeholderImage:imgDefaultAvatar
                                          options:SDWebImageProgressiveDownload | SDWebImageRetryFailed];
//    }
//    
//    if (((GlobalData*)[GlobalData sharedData]).g_selfUser.user_privatepicture.count >= 3)
//    {
        [_m_imgPrivatePicture3 sd_setImageWithURL:[NSURL URLWithString:[GlobalData getUserPhoto:currentUser.user_private_photo3 isThumbnail:YES]]
                                 placeholderImage:imgDefaultAvatar
                                          options:SDWebImageProgressiveDownload | SDWebImageRetryFailed];
//    }

    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    mActionsheetView = (PhotoActionSheetView *)[PhotoActionSheetView initView:appdelegate.m_leveyTabBarController.view];
    mActionsheetView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) OnClickPicture:(id) sender
{
    // Select Avatar from camera or camera roll.
    m_nPictureIndex = 0;
    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *)sender;
    CGPoint touchPos = [tapGesture locationInView:self.m_viewPublicPicture];

    if (CGRectContainsPoint(_m_imgAvatar.frame, touchPos))
    {
        m_nPictureIndex = 1;
    }
    
    touchPos = [tapGesture locationInView:self.m_viewPrivatePicture];
    if (CGRectContainsPoint(_m_imgPrivatePicture1.frame, touchPos))
    {
        m_nPictureIndex = 2;
    }
    
    if (CGRectContainsPoint(_m_imgPrivatePicture2.frame, touchPos))
    {
        m_nPictureIndex = 3;
    }
    
    if (CGRectContainsPoint(_m_imgPrivatePicture3.frame, touchPos))
    {
        m_nPictureIndex = 4;
    }
    
    if (m_nPictureIndex != 0)
    {
//        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select picture from..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Image Gallary", nil];
//        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
//        [actionSheet showInView:self.view];
        
        if (![mActionsheetView isShowing]) {
            [mActionsheetView showView];
        }
    }
}

#pragma mark -- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.delegate = self;
                
                [self presentViewController:picker animated:YES completion:nil];
            }
            
            break;
        }
            
        case 1:
        {
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
            
            break;
        }
            
        default:
            break;
    }
}

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
    [controller dismissViewControllerAnimated:YES completion:^(void)
    {
        NSData* photoImage = UIImageJPEGRepresentation(croppedImage, 1.0f);
        NSData* photoImageThumbnail = photoImage;

        double dTargetSize = 1024 * 100;
        double dRatio = 1;
        NSUInteger nOldSize = 0;
        
        [SVProgressHUD showWithStatus:@"Processing..." maskType:SVProgressHUDMaskTypeClear];
        
        while (photoImage.length > dTargetSize)  // size over 100KB
        {
            dRatio *= dTargetSize / photoImage.length;
            photoImage = UIImageJPEGRepresentation(croppedImage, dRatio);
            photoImageThumbnail = photoImage;
            
            if (nOldSize > 0 && nOldSize == photoImage.length) {
                // already minimum, so break
                break;
            }
            
            nOldSize = photoImage.length;
        }
        
        double dWidth = [croppedImage size].width;
        double dHeight = [croppedImage size].height;
        if (dWidth > 150 || dHeight > 150)
        {
            UIImage* convertImage = [GlobalData imageWithImage:croppedImage scaledToSize:CGSizeMake(75, 75)];
            photoImageThumbnail = UIImageJPEGRepresentation(convertImage, 0.5f);
        }
        
        //TCOTS
        // ******** SAVE USER PICTURE TO SERVER, UPDATE THE USER PROFILE DATA, SHOW PICTURES BASED ON IT ********* //
        // API : NUMBER
        
        switch (m_nPictureIndex)
        {
            case 1:
            {
                [SVProgressHUD showWithStatus:@"Uploading..." maskType:SVProgressHUDMaskTypeClear];
                [_m_imgAvatar setImage:croppedImage];
                [[CommAPIManager sharedCommAPIManager] uploadePublicPhotoWithUserName:[[GlobalData sharedData] g_selfUser].user_name
                                                                         oldPhotoName:[[GlobalData sharedData] g_selfUser].user_public_photo
                                                                          PublicPhoto:photoImage
                                                                     PublicPhotoThumb:photoImageThumbnail
                                                                            successed:^(id responseObject) {
                                                                                
                                                                                [SVProgressHUD showSuccessWithStatus:@"Succeed to upload public Photo"];
                                                                                
                                                                                NSString *strPicture = [[responseObject objectForKey:WEBAPI_RETURN_VALUES] objectForKey:@"user_public_photo"];
                                                                                [[[GlobalData sharedData] g_selfUser] setUser_public_photo:strPicture];

                                                                            }
                                                                              failure:^(NSError *error)
                                                                            {

                                                                                [SVProgressHUD dismiss];
                                                                                [SVProgressHUD showErrorWithStatus:@"Failed to upload public Photo"];
                                                                                
                                                                            }];
                break;
            }

            case 2:{
                
                [_m_imgPrivatePicture1 setImage:croppedImage];

                [SVProgressHUD showWithStatus:@"Uploading..." maskType:SVProgressHUDMaskTypeClear];
                [[CommAPIManager sharedCommAPIManager] uploadePrivatePhotoWithUserName:((GlobalData*)[GlobalData sharedData]).g_selfUser.user_name
                                                                          oldPhotoName:[[GlobalData sharedData] g_selfUser].user_private_photo1
                                                                            PhotoIndex:@"1"
                                                                          PrivatePhoto:photoImage
                                                                     PrivatePhotoThumb:photoImageThumbnail
                                                                             successed:^(id responseObject) {
                                                                               
                                                                               [SVProgressHUD showSuccessWithStatus:@"Succeed to upload private Photo"];
                                                                                 
                                                                                 NSString *strPicture = [[responseObject objectForKey:WEBAPI_RETURN_VALUES] objectForKey:@"user_private_photo"];
                                                                                 [[[GlobalData sharedData] g_selfUser] setUser_private_photo1:strPicture];
                                                                               
                                                                               
                                                                           } failure:^(NSError *error) {
                                                                               
                                                                               [SVProgressHUD dismiss];
                                                                               [SVProgressHUD showErrorWithStatus:@"Failed to upload private Photo"];
                                                                               
                                                                           }
                 ];
            }
                break;

            case 3:{
                
                [_m_imgPrivatePicture2 setImage:croppedImage];
                
                [SVProgressHUD showWithStatus:@"Uploading..." maskType:SVProgressHUDMaskTypeClear];
                [[CommAPIManager sharedCommAPIManager] uploadePrivatePhotoWithUserName:((GlobalData*)[GlobalData sharedData]).g_selfUser.user_name
                                                                          oldPhotoName:[[GlobalData sharedData] g_selfUser].user_private_photo2
                                                                            PhotoIndex:@"2"
                                                                          PrivatePhoto:photoImage
                                                                     PrivatePhotoThumb:photoImageThumbnail
                                                                             successed:^(id responseObject) {

                                                                               [SVProgressHUD showSuccessWithStatus:@"Succeed to upload private Photo"];
                                                                                 
                                                                                 NSString *strPicture = [[responseObject objectForKey:WEBAPI_RETURN_VALUES] objectForKey:@"user_private_photo"];
                                                                                 [[[GlobalData sharedData] g_selfUser] setUser_private_photo2:strPicture];
                                                                               
                                                                               
                                                                           } failure:^(NSError *error) {
                                                                               
                                                                               [SVProgressHUD dismiss];
                                                                               [SVProgressHUD showErrorWithStatus:@"Failed to upload private Photo"];
                                                                               
                                                                               
                                                                           }
                 ];
                
                
            }
                break;

            case 4:{
                
                [_m_imgPrivatePicture3 setImage:croppedImage];
                
                [SVProgressHUD showWithStatus:@"Uploading..." maskType:SVProgressHUDMaskTypeClear];
                [[CommAPIManager sharedCommAPIManager] uploadePrivatePhotoWithUserName:((GlobalData*)[GlobalData sharedData]).g_selfUser.user_name
                                                                          oldPhotoName:[[GlobalData sharedData] g_selfUser].user_private_photo3
                                                                            PhotoIndex:@"3"
                                                                          PrivatePhoto:photoImage
                                                                     PrivatePhotoThumb:photoImageThumbnail
                                                                             successed:^(id responseObject) {
                                                                               
                                                                               [SVProgressHUD showSuccessWithStatus:@"Succeed to upload private Photo"];
                                                                                 
                                                                                 NSString *strPicture = [[responseObject objectForKey:WEBAPI_RETURN_VALUES] objectForKey:@"user_private_photo"];
                                                                                 [[[GlobalData sharedData] g_selfUser] setUser_private_photo3:strPicture];
                                                                               
                                                                           } failure:^(NSError *error) {
                                                                               
                                                                               [SVProgressHUD dismiss];
                                                                               [SVProgressHUD showErrorWithStatus:@"Failed to upload private Photo"];
                                                                               
                                                                           }
                 ];
                
            }
                break;
        }
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            [m_popoverController dismissPopoverAnimated:YES];
        else
            [self.m_pickerController dismissViewControllerAnimated:YES completion:nil];
        
    }];
}

- (void) cropViewControllerDidCancel:(PECropViewController *) controller {
    
    [controller dismissViewControllerAnimated:YES completion:^(void) {}];
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

- (IBAction)onClickProfile:(id)sender
{
    ProfileViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    
    [self.navigationController pushViewController:viewController animated:true];
}

- (IBAction)onClickAccountInfo:(id)sender
{
    AccountInfoViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountInfoViewController"];
    
    [self.navigationController pushViewController:viewController animated:true];
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


@end
