//
//  ProfileViewController.h
//  Voltga
//
//  Created by JackQuan on 8/5/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
@interface ProfileViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UIActionSheetDelegate, UITextFieldDelegate, UITextViewDelegate>
{
    UIActionSheet*  m_actionSheet;
    int             m_nDataShowType;
    
    NSMutableArray* m_aryAge;
    NSMutableArray* m_aryStatus;
    NSMutableArray* m_aryEthnicity;
    NSMutableArray* m_aryBody;
    NSMutableArray* m_aryPractice;
    
    int             m_nAgeIndex;
    int             m_nStatusIndex;
    int             m_nEthnicityIndex;
    int             m_nBodyIndex;
    int             m_nPracticeIndex;
}

@property (strong, nonatomic) IBOutlet UILabel*         m_lblTitle;
@property (strong, nonatomic) IBOutlet UITextField*     m_txtName;
@property (strong, nonatomic) IBOutlet UITextField*     m_txtAge;
@property (strong, nonatomic) IBOutlet UITextField*     m_txtHeight;
@property (strong, nonatomic) IBOutlet UITextField*     m_txtWeight;
@property (strong, nonatomic) IBOutlet UITextField*     m_txtEthnicity;
@property (strong, nonatomic) IBOutlet UITextField*     m_txtBody;
@property (strong, nonatomic) IBOutlet UITextField*     m_txtPractice;
@property (strong, nonatomic) IBOutlet UITextField*     m_txtStatus;
@property (strong, nonatomic) IBOutlet UITextView*      m_txtIntro;
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *m_scrMain;

- (IBAction)onClickBack:(id)sender;
- (IBAction)onClickSave:(id)sender;

@end
