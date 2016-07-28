//
//  ProfileViewController.m
//  Voltga
//
//  Created by JackQuan on 8/5/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"

enum
{
    DATA_SHOW_TYPE_AGE = 1,
    DATA_SHOW_TYPE_STATUS = 2,
    DATA_SHOW_TYPE_ETHNICITY = 3,
    DATA_SHOW_TYPE_BODY = 4,
    DATA_SHOW_TYPE_PRACTICE = 5
    
} DATA_SHOW_TYPE;

@interface ProfileViewController ()
{
    int m_nMoreShowYPos;
    int m_nMoreHideYPos;
}

@property (weak, nonatomic) IBOutlet UIView *mViewPopupMask;

@property (weak, nonatomic) IBOutlet UIView *mViewPickerPopup;
@property (weak, nonatomic) IBOutlet UILabel *mLblCurPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *mPicker;

@end

@implementation ProfileViewController

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
    
    
    // Initialize the controls.
    _m_txtName.text = ((GlobalData*)[GlobalData sharedData]).g_selfUser.user_name;
    _m_txtName.enabled = false;
    
    _m_txtAge.text = [((GlobalData*)[GlobalData sharedData]).g_selfUser.user_age stringValue];
    
    _m_txtHeight.text = ((GlobalData*)[GlobalData sharedData]).g_selfUser.user_height;
    _m_txtWeight.text = [((GlobalData*)[GlobalData sharedData]).g_selfUser.user_weight stringValue];
    _m_txtEthnicity.text = ((GlobalData*)[GlobalData sharedData]).g_selfUser.user_ethnicity;
    _m_txtBody.text = ((GlobalData*)[GlobalData sharedData]).g_selfUser.user_body;
    _m_txtPractice.text = ((GlobalData*)[GlobalData sharedData]).g_selfUser.user_practice;
    _m_txtStatus.text = ((GlobalData*)[GlobalData sharedData]).g_selfUser.user_status;
    _m_txtIntro.text = ((GlobalData*)[GlobalData sharedData]).g_selfUser.user_intro;
    
    if (_m_txtIntro.text.length == 0)
    {
        _m_txtIntro.text = @"Intro";
    }
    
    _m_txtAge.delegate = self;
    _m_txtStatus.delegate = self;
    _m_txtBody.delegate = self;
    _m_txtPractice.delegate = self;
    _m_txtEthnicity.delegate = self;
    _m_txtHeight.delegate = self;
    _m_txtWeight.delegate = self;
    _m_txtIntro.delegate = self;
    
    // Prepare datas for datapicker controller.
    m_aryAge = [[NSMutableArray alloc] init];
    for (int i = 21; i < 150; i ++)
    {
        [m_aryAge addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    m_aryStatus = [[NSMutableArray alloc] initWithObjects:@"negative", @"positive", @"don't know", nil];
    
    m_aryEthnicity = [[NSMutableArray alloc] initWithObjects:@"White", @"Asian", @"Latino", @"Black", @"Others", nil];
    
    m_aryBody = [[NSMutableArray alloc] initWithObjects:@"Body Builder", @"Muscular", @"Athletic", @"Average", @"Large", @"Slim", nil];
    
    m_aryPractice = [[NSMutableArray alloc] initWithObjects:@"Always Safe", @"Mostly", @"Anything Goes", nil];
    
    [_m_scrMain setContentSize:CGSizeMake(320, 512)];
    [_m_scrMain setScrollEnabled:YES];
    
    
    //
    // picker popup
    //
    [self.mViewPopupMask setHidden:YES];
    
    m_nMoreHideYPos = self.view.frame.size.height;
    m_nMoreShowYPos = m_nMoreHideYPos - self.mViewPickerPopup.frame.size.height;
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

- (void) hideKeyboard
{
    [self.view endEditing:YES];
}

- (IBAction)onClickBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)onClickSave:(id)sender
{
    // Check data integrity.
    if (_m_txtAge.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"Please select age."];
        return;
    }
    
    if (_m_txtHeight.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"Please input height."];
        return;
    }
    
    if (_m_txtWeight.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"Please input weight."];
        return;
    }
    
    if (_m_txtEthnicity.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"Please input ethnicity."];
        return;
    }
    
    if (_m_txtBody.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"Please input body"];
        return;
    }
    
    if (_m_txtPractice.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"Please input practice."];
        return;
    }
    
    if (_m_txtStatus.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"Please select status."];
        return;
        
    }
    
    if (_m_txtIntro.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"Please input intro."];
        return;
    }
        
    ((GlobalData*) [GlobalData sharedData]).g_selfUser.user_age = [NSNumber numberWithInt:_m_txtAge.text.intValue];
    ((GlobalData*) [GlobalData sharedData]).g_selfUser.user_height = _m_txtHeight.text;
    ((GlobalData*) [GlobalData sharedData]).g_selfUser.user_weight = [NSNumber numberWithFloat:_m_txtWeight.text.floatValue];
    ((GlobalData*) [GlobalData sharedData]).g_selfUser.user_ethnicity = _m_txtEthnicity.text;
    ((GlobalData*) [GlobalData sharedData]).g_selfUser.user_body = _m_txtBody.text;
    ((GlobalData*) [GlobalData sharedData]).g_selfUser.user_practice = _m_txtPractice.text;
    ((GlobalData*) [GlobalData sharedData]).g_selfUser.user_status = _m_txtStatus.text;
    ((GlobalData*) [GlobalData sharedData]).g_selfUser.user_intro = _m_txtIntro.text;
    
    //TCOTS
    // ****************** SAVE USER PROFILE INFORMATION TO SERVER ****************** //
    // API : saveUserProfileWithUserObj
    [[CommAPIManager sharedCommAPIManager] saveUserProfileWithUserObj:((GlobalData*) [GlobalData sharedData]).g_selfUser
                                                            successed:^(id responseObject)
    {
        if ([[responseObject objectForKey:WEBAPI_RETURN_RESULT] isEqualToString:WEBAPI_RETURN_SUCCESS])
        {
            [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:WEBAPI_RETURN_MESSAGE]];
            
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
    
}
    
# pragma mark - Control Methods
- (void) PopupPickerView
{
    [self.view endEditing:YES];
    
    [self.mPicker reloadAllComponents];
    
    switch (m_nDataShowType)
    {
        case DATA_SHOW_TYPE_AGE:
            self.mLblCurPicker.text = m_aryAge[0];
            [self.mPicker selectRow:0 inComponent:0 animated:NO];
            break;
        case DATA_SHOW_TYPE_STATUS:
            self.mLblCurPicker.text = m_aryStatus[2];
            [self.mPicker selectRow:2 inComponent:0 animated:NO];
            break;
        case DATA_SHOW_TYPE_ETHNICITY:
            self.mLblCurPicker.text = m_aryEthnicity[0];
            [self.mPicker selectRow:0 inComponent:0 animated:NO];
            break;
        case DATA_SHOW_TYPE_BODY:
            self.mLblCurPicker.text = m_aryBody[0];
            [self.mPicker selectRow:0 inComponent:0 animated:NO];
            break;
        case DATA_SHOW_TYPE_PRACTICE:
            self.mLblCurPicker.text = m_aryPractice[0];
            [self.mPicker selectRow:0 inComponent:0 animated:NO];
            break;
        default:
            break;
    }
    
    if (self.mViewPickerPopup.frame.origin.y == m_nMoreHideYPos)
    {
        [self.mViewPopupMask setHidden:NO];
        [UIView animateWithDuration:0.3
                         animations:^{
                             CGRect rt = self.mViewPickerPopup.frame;
                             rt.origin.y = m_nMoreShowYPos;
                             self.mViewPickerPopup.frame = rt;
                             [self.mViewPopupMask setAlpha:0.5];
                         }completion:^(BOOL finished) {
                             //						 self.view.userInteractionEnabled = YES;
                         }];
    }
}


#pragma mark -
#pragma mark PickerView DataSource


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int numRows = 0;
    switch (m_nDataShowType)
    {
        case DATA_SHOW_TYPE_AGE:
            numRows = (int)m_aryAge.count;
            break;
        case DATA_SHOW_TYPE_STATUS:
            numRows = (int)m_aryStatus.count;
            break;
        case DATA_SHOW_TYPE_ETHNICITY:
            numRows = (int)m_aryEthnicity.count;
            break;
        case DATA_SHOW_TYPE_BODY:
            numRows = (int)m_aryBody.count;
            break;
        case DATA_SHOW_TYPE_PRACTICE:
            numRows = (int)m_aryPractice.count;
            break;
        default:
            break;
    }
    
    return numRows;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString* strTitle = nil;
    switch (m_nDataShowType)
    {
        case DATA_SHOW_TYPE_AGE:
            m_nAgeIndex = (int)row;
            strTitle = m_aryAge[m_nAgeIndex];
            break;
        case DATA_SHOW_TYPE_STATUS:
            m_nStatusIndex = (int)row;
            strTitle = m_aryStatus[m_nStatusIndex];
            break;
        case DATA_SHOW_TYPE_ETHNICITY:
            m_nEthnicityIndex = (int)row;
            strTitle = m_aryEthnicity[m_nEthnicityIndex];
            break;
        case DATA_SHOW_TYPE_BODY:
            m_nBodyIndex = (int)row;
            strTitle = m_aryBody[m_nBodyIndex];
            break;
        case DATA_SHOW_TYPE_PRACTICE:
            m_nPracticeIndex = (int)row;
            strTitle = m_aryPractice[m_nPracticeIndex];
            break;
    }
    
    return strTitle;
}


#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (m_nDataShowType)
    {
        case DATA_SHOW_TYPE_AGE:
            self.mLblCurPicker.text = m_aryAge[row];
            m_nAgeIndex = (int)row;
            break;
        case DATA_SHOW_TYPE_STATUS:
            self.mLblCurPicker.text = m_aryStatus[row];
            m_nStatusIndex = (int)row;
            break;
        case DATA_SHOW_TYPE_ETHNICITY:
            self.mLblCurPicker.text = m_aryEthnicity[row];
            break;
        case DATA_SHOW_TYPE_BODY:
            self.mLblCurPicker.text = m_aryBody[row];
            break;
        case DATA_SHOW_TYPE_PRACTICE:
            self.mLblCurPicker.text = m_aryPractice[row];
            break;
        default:
            break;
    }
}



#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _m_txtAge)
    {
        m_nDataShowType = DATA_SHOW_TYPE_AGE;
        [self PopupPickerView];
        
        return NO;
    }
    
    if (textField == _m_txtStatus)
    {
        m_nDataShowType = DATA_SHOW_TYPE_STATUS;
        [self PopupPickerView];
        
        return NO;
    }
    
    if (textField == _m_txtEthnicity)
    {
        m_nDataShowType = DATA_SHOW_TYPE_ETHNICITY;
        [self PopupPickerView];
        
        return NO;
    }
    
    if (textField == _m_txtBody)
    {
        m_nDataShowType = DATA_SHOW_TYPE_BODY;
        [self PopupPickerView];
        
        return NO;
    }
    
    if (textField == _m_txtPractice)
    {
        m_nDataShowType = DATA_SHOW_TYPE_PRACTICE;
        [self PopupPickerView];
        
        return NO;
    }

    
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _m_txtHeight)
    {
        [_m_txtHeight setText:@""];
        return;
    }
    
    if (textField == _m_txtWeight)
    {
        [_m_txtWeight setText:@""];
        return;
    }
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == _m_txtHeight)
    {
        NSString *newString = textField.text;
        NSLog(@"%@", newString);
        
        NSString* strQuete = @"'";
        if ([newString rangeOfString:strQuete].location == NSNotFound)
        {
            _m_txtHeight.text = [newString stringByReplacingOccurrencesOfString:@"."
                                                                     withString:@"'"];
        }
        else if ([string isEqualToString:@"."])
        {
            return NO;
        }
        
        NSLog(@"Changed Str: %@", _m_txtHeight.text);
    }
    return YES;
}

#pragma - mark UITextViewDelegate
- (void) textViewDidBeginEditing:(UITextView *)textView
{
    _m_txtIntro.text = @"";
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    if (_m_txtIntro.text.length == 0)
    {
        _m_txtIntro.text = @"Intro";
    }
}


#pragma mark Picker Popup

- (void)hidePopup
{
    if (self.mViewPickerPopup.frame.origin.y == m_nMoreShowYPos)
    {
        [UIView animateWithDuration:0.3
                         animations:^ {
                             CGRect rt = self.mViewPickerPopup.frame;
                             rt.origin.y = m_nMoreHideYPos;
                             self.mViewPickerPopup.frame = rt;
                             [self.mViewPopupMask setAlpha:0];
                         }
                         completion:^(BOOL finished) {
                             //						 self.view.userInteractionEnabled = YES;
                             [self.mViewPopupMask setHidden:YES];
                         }];
    }
}


- (IBAction)onButPopupOk:(id)sender
{
    switch (m_nDataShowType)
    {
        case DATA_SHOW_TYPE_AGE:
            _m_txtAge.text = m_aryAge[m_nAgeIndex];
            break;
        case DATA_SHOW_TYPE_STATUS:
            _m_txtStatus.text = m_aryStatus[m_nStatusIndex];
            break;
        case DATA_SHOW_TYPE_ETHNICITY:
            _m_txtEthnicity.text = m_aryEthnicity[m_nEthnicityIndex];
            break;
        case DATA_SHOW_TYPE_BODY:
            _m_txtBody.text = m_aryBody[m_nBodyIndex];
            break;
        case DATA_SHOW_TYPE_PRACTICE:
            _m_txtPractice.text = m_aryPractice[m_nPracticeIndex];
            break;
        default:
            break;
    }

    [self hidePopup];
}

- (IBAction)onButPopupCancel:(id)sender
{
    [self hidePopup];
}


@end
