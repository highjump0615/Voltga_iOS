//
//  Created by Jesse Squires
//  http://www.hexedbits.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSMessagesViewController
//
//
//  The MIT License
//  Copyright (c) 2013 Jesse Squires
//  http://opensource.org/licenses/MIT
//

#define TABBAR_HEIGHT       155.f

#import "JSMessagesViewController.h"
#import "JSMessageTextView.h"
#import "NSString+JSMessagesView.h"
#import "ChatImageView.h"
#import "AFNetworking.h"
#import "CommAPIManager.h"

#import "PhotoActionSheetView.h"

//#import "MJPhotoBrowser.h"
//#import "MJPhoto.h"

#import <AVFoundation/AVFoundation.h>

@interface JSMessagesViewController () <JSDismissiveTextViewDelegate, UIPopoverControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PhotoActionDelegate>
{
//    ChatImageView   *imageView;
    BOOL                bShowChatImage;
    
    PhotoActionSheetView *mActionsheetView;
}

@property (assign, nonatomic) CGFloat previousTextViewContentHeight;
@property (assign, nonatomic) BOOL isUserScrolling;

- (void)setup;

- (void)sendPressed:(UIButton *)sender;
- (void)sendPhoto:(UIButton *)sender;
- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)tap;

- (BOOL)shouldAllowScroll;

- (void)layoutAndAnimateMessageInputTextView:(UITextView *)textView;
- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom;
- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom;

- (void)handleWillShowKeyboardNotification:(NSNotification *)notification;
- (void)handleWillHideKeyboardNotification:(NSNotification *)notification;
- (void)keyboardWillShowHide:(NSNotification *)notification;

- (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve;

@end



@implementation JSMessagesViewController

@synthesize m_popoverController;
@synthesize m_actionSheet;

#pragma mark - Initialization

- (void)setup
{
    UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(0
                                                                   , 0
                                                                   , self.view.frame.size.width
                                                                   , self.view.frame.size.height - _navigationHeight)];
    [self.view addSubview:messageView];
    _messageView = messageView;
    
    if ([self.view isKindOfClass:[UIScrollView class]]) {
        // FIXME: hack-ish fix for ipad modal form presentations
        ((UIScrollView *)self.view).scrollEnabled = NO;
    }
    
	_isUserScrolling = NO;
    
    CGSize size = self.messageView.frame.size;
    
    JSMessageInputViewStyle inputViewStyle = [self.delegate inputViewStyle];
    CGFloat inputViewHeight = (inputViewStyle == JSMessageInputViewStyleFlat) ? 46.0f : 40.0f;
    
    CGRect tableFrame = CGRectMake(0.0f, 0.0f, size.width, size.height - inputViewHeight);
	JSMessageTableView *tableView = [[JSMessageTableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	tableView.dataSource = self;
	tableView.delegate = self;
    tableView.delaysContentTouches = NO;
	//[self.view addSubview:tableView];
    [self.messageView addSubview:tableView];
	_tableView = tableView;
    
    [self setBackgroundColor:[UIColor clearColor]];
//    [self setBackgroundColor:RGB(51, 54, 43, 255)];
    
    CGRect inputFrame = CGRectMake(0.0f,
                                   size.height - inputViewHeight,
                                   size.width,
                                   inputViewHeight);
    
    BOOL allowsPan = YES;
    if ([self.delegate respondsToSelector:@selector(allowsPanToDismissKeyboard)]) {
        allowsPan = [self.delegate allowsPanToDismissKeyboard];
    }
    
    UIPanGestureRecognizer *pan = allowsPan ? _tableView.panGestureRecognizer : nil;
    
    JSMessageInputView *inputView = [[JSMessageInputView alloc] initWithFrame:inputFrame
                                                                        style:inputViewStyle
                                                                     delegate:self
                                                         panGestureRecognizer:pan];
    
    if (!allowsPan) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
        [_tableView addGestureRecognizer:tap];
    }
    
    if ([self.delegate respondsToSelector:@selector(sendButtonForInputView)]) {
        UIButton *sendButton = [self.delegate sendButtonForInputView];
        [inputView setSendButton:sendButton];
    }
    
    inputView.sendButton.enabled = NO;
    [inputView.sendButton addTarget:self
                             action:@selector(sendPressed:)
                   forControlEvents:UIControlEventTouchUpInside];
    
    [inputView.photoButton addTarget:self
                              action:@selector(sendPhoto:)
                    forControlEvents:UIControlEventTouchUpInside];
    
//    [inputView.voiceButton addTarget:self
//                              action:@selector(startRecord:)
//                    forControlEvents:UIControlEventTouchDown];
//    
//    [inputView.voiceButton addTarget:self
//                              action:@selector(stopRecord:)
//                    forControlEvents:UIControlEventTouchUpInside];
    
    //[self.view addSubview:inputView];
    [self.messageView addSubview:inputView];
    _messageInputView = inputView;
    
    [_messageInputView.textView addObserver:self
                                 forKeyPath:@"contentSize"
                                    options:NSKeyValueObservingOptionNew
                                    context:nil];
    
//    mActionsheetView = (PhotoActionSheetView *)[PhotoActionSheetView initView:self.parentViewController.view];
//    mActionsheetView.delegate = self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    
    UIFont* font = [UIFont systemFontOfSize:kChatTextFontSize]; //TCOTS CHAT FONT SIZE
    [[JSBubbleView appearance] setFont:font];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self scrollToBottomAnimated:NO];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillShowKeyboardNotification:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillHideKeyboardNotification:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [self scrollToBottomAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.messageInputView resignFirstResponder];
    [self setEditing:NO animated:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"*** %@: didReceiveMemoryWarning ***", [self class]);
}

- (void)dealloc
{
    [_messageInputView.textView removeObserver:self forKeyPath:@"contentSize"];
    _delegate = nil;
    _dataSource = nil;
    _tableView = nil;
    _messageInputView = nil;
}

#pragma mark - View rotation

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.tableView reloadData];
    [self.tableView setNeedsLayout];
}

#pragma mark - Actions

- (void)sendPressed:(UIButton *)sender
{
    [self.delegate didSendText:[self.messageInputView.textView.text js_stringByTrimingWhitespace]
                        onDate:[NSDate date]];
}

//- (void)startRecord:(UIButton *)sender
//{
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    [session setActive:YES error:nil];
//    
//    // Start recording
//    [recorder recordForDuration:120];
//}
//
//- (void)stopRecord:(UIButton *)sender
//{
//    [recorder stop];
//    
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    [audioSession setActive:NO error:nil];
//}

- (void)OnClickBtnPlay:(UIButton *)sender
{
//    UIButton *btnPlay = (UIButton *)sender;
//    
//    UIView *findView = btnPlay;
//    while (findView != nil) {
//        if ([findView isKindOfClass:[JSBubbleMessageCell class]]) {
//            break;
//        } else {
//            findView = [findView superview];
//        }
//    }
//    
//    JSBubbleMessageCell *cell = (JSBubbleMessageCell *)findView;
//    
//    [self.delegate didClickPlayButton:sender.tag - 100 audioView:cell.bubbleView.audioView];
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    
//    [[UserClient sharedClient] uploadMediaOnlyWithUserID:[_globalData.userID stringValue]
//                                               MediaType:MediaTypeAudio
//                                               MediaData:[NSData dataWithContentsOfURL:avrecorder.url]
//                                               successed:^(id responseObject) {
//                                                   if([[responseObject objectForKey:WEBAPI_RETURN_ACTION] isEqualToString:WEBAPI_UPLOADMEDIAONLY])
//                                                   {
//                                                       if([[responseObject objectForKey:WEBAPI_RETURN_RESULT] isEqualToString:WEBAPI_RETURN_SUCCEED])
//                                                       {
//                                                           NSDictionary *dicData = [responseObject objectForKey:WEBAPI_RETURN_VALUE];
//                                                           NSString *strAudioURL = [dicData objectForKey:@"mediaurl"];
//                                                           [self.delegate didSendAudio:strAudioURL
//                                                                                onDate:[NSDate date]];
//                                                       }
//                                                       else
//                                                       {
//                                                           [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:WEBAPI_RETURN_MESSAGE]];
//                                                       }
//                                                   }
//                                                   [SVProgressHUD dismiss];
//                                               }
//                                                 failure:^(NSError *error) {
//                                                     [SVProgressHUD showErrorWithStatus:@"Uploading Failed"];
//                                                 }
//                                                progress:^(NSUInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
//                                                    NSLog(@"progress--------------------->%f", totalBytesWritten / totalBytesExpectedToWrite * 100.0f);
//                                                    //NSString *strPercent = @"%";
//                                                    [SVProgressHUD showProgress:((float)totalBytesWritten / (float)totalBytesExpectedToWrite)];
//                                                }];

}

- (void)sendPhoto:(UIButton *)sender
{
//    if (![mActionsheetView isShowing]) {
//        [mActionsheetView showView];
//    }
    
    m_actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                 delegate:self
                                        cancelButtonTitle:@"Cancel"
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:@"Camera", @"Image Gallery", nil];
    
    [m_actionSheet showInView:self.parentViewController.view];
    
    
//    if(bShowChatImage)
//    {
//        bShowChatImage = NO;
//        [UIView animateWithDuration:0.5 animations:^ {
//            [imageView setFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(imageView.frame))];
//        }];
//        
//        return;
//    }
//    
//    CGFloat chatImageY = self.messageInputView.frame.origin.y - CGRectGetHeight(imageView.frame);
//    
//    [UIView animateWithDuration:0.5 animations:^ {
//        [imageView setFrame:CGRectMake(0, chatImageY, CGRectGetWidth(imageView.frame), CGRectGetHeight(imageView.frame))];
//    }];
//    
//    bShowChatImage = YES;
//    [imageView.m_btnCamera addTarget:self action:@selector(OnClickBtnCamera) forControlEvents:UIControlEventTouchUpInside];
//    [imageView.m_btnTimebomb addTarget:self action:@selector(OnClickBtnTimeBomb) forControlEvents:UIControlEventTouchUpInside];
//    [imageView.m_btnHideTimeBomb addTarget:self action:@selector(OnClickHideTimeBomb) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)OnClickBtnTimeBomb
{
//    bShowChatImage = NO;
//    [UIView animateWithDuration:0.5 animations:^ {
//        [imageView setFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(imageView.frame))];
//    }];
    
//    [_globalData showTimeBombViewController:self];
}

- (void)OnClickBtnCamera
{
//    bShowChatImage = NO;
//    [UIView animateWithDuration:0.5 animations:^ {
//        [imageView setFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(imageView.frame))];
//    }];
//    
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//
//        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        picker.delegate = self;
//        
//        [self presentViewController:picker animated:YES completion:nil];
//    }
}

- (void)OnClickHideTimeBomb
{
//    bShowChatImage = NO;
//    [UIView animateWithDuration:0.5 animations:^ {
//        [imageView setFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(imageView.frame))];
//    }];
}

- (void)OnLongTap:(UILongPressGestureRecognizer *)tap
{
    NSInteger nSelectedRow = tap.view.tag - 100;
    
    NSLog(@"%d", (int)nSelectedRow);
    if(tap.state == UIGestureRecognizerStateBegan){
        
        [self.delegate didLongTapOnTimeBombStart:nSelectedRow];
        
    } else if(tap.state == UIGestureRecognizerStateEnded){
        
        [self.delegate didLongTapOnTimeBombEnd:nSelectedRow];
        
    }
}

- (void)OnTapMessage:(UITapGestureRecognizer*)recognizer
{
    [self.messageInputView.textView resignFirstResponder];
    UIImageView* v = (UIImageView*)recognizer.view;
    
    id<JSMessageData> message = [self.dataSource messageForRowAtIndexPath:[NSIndexPath indexPathForRow:v.tag inSection:0]];
    if([message msgType] == PHOTO_MESSAGE){
        
//        MJPhoto *photo = [[MJPhoto alloc] init];
//        photo.url = [NSURL URLWithString:[message photo]];
//        photo.srcImageView = v;
//        NSMutableArray *photos = [NSMutableArray arrayWithObject:photo];
//        
//        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//        browser.currentPhotoIndex = 0;
//        browser.photos = photos;
//        [browser show];
        
       [self.delegate didTapPhoto:[message photo]];
    }
    
}

- (void)uploadUserMedia:(NSData *)imgData width:(int)nWidth height:(int)nHeight
{
    
    [[CommAPIManager sharedCommAPIManager] uploadMediaOnlyWithUserID:[[[GlobalData sharedData] g_selfUser].user_id stringValue]
                                                             PlaceID:[[[GlobalData sharedData] g_selfUser].user_place_id stringValue]
                                                           MediaType:MediaTypePhoto
                                                           MediaData:imgData
                                                           successed:^(id responseObject) {
                                                               
                                                               if([[responseObject objectForKey:WEBAPI_RETURN_RESULT] isEqualToString:WEBAPI_RETURN_SUCCESS]){
                                                                   
                                                                   NSDictionary *dicData = [responseObject objectForKey:WEBAPI_RETURN_VALUES];
                                                                   NSString *strMediaURL = [dicData objectForKey:@"mediaurl"];
                                                                   [self.delegate didSendPhoto:strMediaURL
                                                                                        onDate:[NSDate date]
                                                                                         width:nWidth
                                                                                        height:nHeight];
                                                               } else {
                                                                   
                                                                   [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:WEBAPI_RETURN_MESSAGE]];
                                                                   
                                                               }
                                                               
                                                               [SVProgressHUD dismiss];
                                                               
                                                           }
                                                             failure:^(NSError *error) {
                                                                 
                                                                 [SVProgressHUD showErrorWithStatus:@"Uploading Failed"];
                                                                 
                                                             }];
    
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *imgMessage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIGraphicsEndImageContext();
    
    double dWidth = [image size].width;
    double dHeight = [image size].height;
    double dScale = 200.0 / (dWidth > dHeight ? dWidth : dHeight);
    dScale = dScale < 1.0 ? dScale : 1.0;
    dWidth = dWidth * dScale;
    dHeight = dHeight * dScale;
    
    [self uploadUserMedia:[NSData dataWithData:UIImageJPEGRepresentation([self compressImage:imgMessage], 0.7f)]
                    width:(int)dWidth
                   height:(int)dHeight];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [m_popoverController dismissPopoverAnimated:YES];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)compressImage:(UIImage *)image
{
    float fMaxWidth = (float)((self.view.frame.size.width - kJSAvatarImageSize) * 0.8f);
    if(image.size.width > fMaxWidth)
    {
        float fScale = image.size.width / fMaxWidth;
        
        UIGraphicsBeginImageContext(CGSizeMake(fMaxWidth, image.size.height / fScale));
        [image drawInRect:CGRectMake(0, 0, fMaxWidth, image.size.height / fScale)];
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return smallImage;
    }
    else
        return image;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

#pragma comments UITapGesture Delegate

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)tap
{
    [self.messageInputView.textView resignFirstResponder];
}

- (void)onTapAvatar:(UITapGestureRecognizer*)tapGuesture{
    
    NSLog(@"%d", (int)tapGuesture.view.tag);
    
    [self.delegate didTapAvatar:(int)tapGuesture.view.tag];
}

- (void)onDblTapAvatar:(UITapGestureRecognizer*)tapGuesture
{
    NSLog(@"%d", (int)tapGuesture.view.tag);
    
    [self.delegate didDblTapAvatar:(int)tapGuesture.view.tag];
}

- (void)didTapPhoto:(NSString*)photo_url{
    
    NSLog(@"%@", photo_url);
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSBubbleMessageType type = [self.delegate messageTypeForRowAtIndexPath:indexPath];
    
    UIImageView *bubbleImageView = [self.delegate bubbleImageViewWithType:type
                                                        forRowAtIndexPath:indexPath];
    
    id<JSMessageData> message = [self.dataSource messageForRowAtIndexPath:indexPath];
    
    UIImageView *avatar = [self.dataSource avatarImageViewForRowAtIndexPath:indexPath];
    
    BOOL displayTimestamp = YES;
    if ([self.delegate respondsToSelector:@selector(shouldDisplayTimestampForRowAtIndexPath:)]) {
        displayTimestamp = [self.delegate shouldDisplayTimestampForRowAtIndexPath:indexPath];
    }
    
    NSString *CellIdentifier = nil;
    if ([self.delegate respondsToSelector:@selector(customCellIdentifierForRowAtIndexPath:)]) {
        CellIdentifier = [self.delegate customCellIdentifierForRowAtIndexPath:indexPath];
    }

    if (!CellIdentifier) {
        CellIdentifier = [NSString stringWithFormat:@"JSMessageCell_%d_%d_%d_%d_%d_%d",
                          (int)type, (int)[message date], avatar != nil, (int)[message msgType], [[message nImgWidth] intValue], [[message nImgHeight] intValue]];
    }
    
    JSBubbleMessageCell *cell = (JSBubbleMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        cell = [[JSBubbleMessageCell alloc] initWithBubbleType:type
                                               bubbleImageView:bubbleImageView
                                                       message:message
                                             displaysTimestamp:displayTimestamp
                                                     hasAvatar:avatar != nil
                                               reuseIdentifier:CellIdentifier];
    }
    
    [cell setMessage:message];
    [cell.bubbleView.textView setDelegate:self];
    [cell setAvatarImageView:avatar message:message];

    // timestamp
    if ([message date]) {
        [cell.timestampLabel setText:[message date]];
    }


// -------- Tap on Avatar
    UITapGestureRecognizer* dblTapOnAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDblTapAvatar:)];
    [dblTapOnAvatar setNumberOfTapsRequired:2];
    [dblTapOnAvatar setNumberOfTouchesRequired:1];
    [avatar setUserInteractionEnabled:YES];
    [avatar addGestureRecognizer:dblTapOnAvatar];
    
    UITapGestureRecognizer* tapOnAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAvatar:)];
    [tapOnAvatar setNumberOfTapsRequired:1];
    [tapOnAvatar setNumberOfTouchesRequired:1];
    [avatar setUserInteractionEnabled:YES];
    [avatar addGestureRecognizer:tapOnAvatar];
    [tapOnAvatar requireGestureRecognizerToFail:dblTapOnAvatar];
    
//---------------------
    
    [cell setBackgroundColor:tableView.backgroundColor];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapMessage:)];
    cell.bubbleView.photoView.tag = indexPath.row;
    [cell.bubbleView.photoView addGestureRecognizer:tap];
    [cell.bubbleView.photoView setUserInteractionEnabled:YES];
    
    
	#if TARGET_IPHONE_SIMULATOR
        cell.bubbleView.textView.dataDetectorTypes = UIDataDetectorTypeNone;
	#else
		cell.bubbleView.textView.dataDetectorTypes = UIDataDetectorTypeAll;
	#endif
	
    if ([self.delegate respondsToSelector:@selector(configureCell:atIndexPath:)]) {
        [self.delegate configureCell:cell atIndexPath:indexPath];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<JSMessageData> message = [self.dataSource messageForRowAtIndexPath:indexPath];
    UIImageView *avatar = [self.dataSource avatarImageViewForRowAtIndexPath:indexPath];
    
    return [JSBubbleMessageCell neededHeightForBubbleMessageCellWithMessage:message
                                                                     avatar:avatar != nil];
}

#pragma mark - Messages view controller

- (void)finishSend
{
    [self.messageInputView.textView setText:@""];
    [self textViewDidChange:self.messageInputView.textView];
//    [self.tableView reloadData];
}

- (void)setBackgroundColor:(UIColor *)color
{
    self.view.backgroundColor = color;
    _tableView.backgroundColor = color;
    _tableView.separatorColor = color;
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
	if (![self shouldAllowScroll])
        return;
	
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    
    if (rows > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
//        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath
			  atScrollPosition:(UITableViewScrollPosition)position
					  animated:(BOOL)animated
{
	if (![self shouldAllowScroll])
        return;
	
	[self.tableView scrollToRowAtIndexPath:indexPath
						  atScrollPosition:position
								  animated:animated];
}

- (BOOL)shouldAllowScroll
{
    if (self.isUserScrolling) {
        if ([self.delegate respondsToSelector:@selector(shouldPreventScrollToBottomWhileUserScrolling)]
           && [self.delegate shouldPreventScrollToBottomWhileUserScrolling]) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - Scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	self.isUserScrolling = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.isUserScrolling = NO;
}

#pragma mark - Text view delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
	
    if (!self.previousTextViewContentHeight)
		self.previousTextViewContentHeight = textView.contentSize.height;
    
    [self scrollToBottomAnimated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self sendPressed:nil];
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.messageInputView.sendButton.enabled = ([[textView.text js_stringByTrimingWhitespace] length] > 0);

//    if (!textView.markedTextRange)
//    {
//        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:textView.text];
//        [self getAttributedText:textView.text AttributedString:attrText Start:0];
//        
//        [textView setAttributedText:attrText];
//    }

    
//    NSString* str = textView.text;
//    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@"<BR>"];
//    str = [str stringByReplacingOccurrencesOfString:@"[" withString:@"<B><FONT COLOR='#00FF00'>["];
//    NSString* result = [str stringByReplacingOccurrencesOfString:@"]" withString:@"]</FONT></B>"];
//    
//    [textView setValue:result forKey:@"contentToHTMLString"];
    
    
}

- (NSString*)getAttributedText:(NSString*)text AttributedString:(NSMutableAttributedString*) attrText Start:(int)start{
    
    NSRange st = [text rangeOfString:@"@" options:0 range:NSMakeRange(start, text.length - start)];
    
    if(st.location != NSNotFound) {
        NSRange en = [text rangeOfString:@" " options:0 range:NSMakeRange(st.location, text.length - st.location)];
        
        if (en.location != NSNotFound && en.location > st.location) {
            //        [attrText addAttribute:NSForegroundColorAttributeName
            //                         value:[UIColor blueColor]
            //                         range:NSMakeRange(st.location, en.location - st.location + 1)];
            [attrText addAttribute:NSFontAttributeName
                             value:[UIFont fontWithName:@"Helvetica-Bold" size:16.0f]
                             range:NSMakeRange(st.location, en.location - st.location + 1)];
            [self getAttributedText:text AttributedString:attrText Start:(int)en.location + 1];
        }
    }
    
    return @"";
    
}



- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    
    NSLog(@"%@", [textView.text substringWithRange:textView.selectedRange]);
    if(textView == self.messageInputView.textView)
        return;
    
    [self.delegate didSelectedSubString:[textView.text substringWithRange:textView.selectedRange]];
    
}

#pragma mark - Layout message input view

- (void)layoutAndAnimateMessageInputTextView:(UITextView *)textView
{
    CGFloat maxHeight = [JSMessageInputView maxHeight];
    
    BOOL isShrinking = textView.contentSize.height < self.previousTextViewContentHeight;
    CGFloat changeInHeight = textView.contentSize.height - self.previousTextViewContentHeight;
    
    if (!isShrinking && (self.previousTextViewContentHeight == maxHeight || textView.text.length == 0)) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }
    
    if (changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             [self setTableViewInsetsWithBottomValue:self.tableView.contentInset.bottom + changeInHeight];
                             
                             [self scrollToBottomAnimated:NO];
                             
                             if (isShrinking) {
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [self.messageInputView adjustTextViewHeightBy:changeInHeight];
                             }
                             
                             CGRect inputViewFrame = self.messageInputView.frame;
                             self.messageInputView.frame = CGRectMake(0.0f,
                                                                      inputViewFrame.origin.y - changeInHeight,
                                                                      inputViewFrame.size.width,
                                                                      inputViewFrame.size.height + changeInHeight);
                             
                             if (!isShrinking) {
                                 // growing the view, animate the text view frame AFTER input view frame
                                 [self.messageInputView adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                         }];
        
        self.previousTextViewContentHeight = MIN(textView.contentSize.height, maxHeight);
    }
    
    // Once we reached the max height, we have to consider the bottom offset for the text view.
    // To make visible the last line, again we have to set the content offset.
    if (self.previousTextViewContentHeight == maxHeight) {
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime,
                       dispatch_get_main_queue(),
                       ^(void) {
                           CGPoint bottomOffset = CGPointMake(0.0f, textView.contentSize.height - textView.bounds.size.height);
                           [textView setContentOffset:bottomOffset animated:YES];
                       });
    }
}

- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom
{
    UIEdgeInsets insets;
    if (bottom == 0)
    {
        JSMessageInputViewStyle inputViewStyle = [self.delegate inputViewStyle];
        insets = [self tableViewInsetsWithBottomValue:(inputViewStyle == JSMessageInputViewStyleFlat) ? 41.0f : 40.0f]; // tcots added the if clause, orginal
    }
    else
    {
        insets = [self tableViewInsetsWithBottomValue:bottom];
    }
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
}

- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom
{
    UIEdgeInsets insets = UIEdgeInsetsZero;
    
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        insets.top = self.topLayoutGuide.length;
    }
    
    insets.bottom = bottom;
    
    return insets;
}

#pragma mark - Key-value observing

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == self.messageInputView.textView && [keyPath isEqualToString:@"contentSize"]) {
        [self layoutAndAnimateMessageInputTextView:object];
    }
}

#pragma mark - Keyboard notifications

- (void)handleWillShowKeyboardNotification:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboardNotification:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:[self animationOptionsForCurve:curve]
                     animations:^{
                         CGFloat keyboardY = [self.messageView convertRect:keyboardRect fromView:nil].origin.y;
                         
                         CGRect inputViewFrame = self.messageInputView.frame;
                         CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                         
                         // for ipad modal form presentations
                         CGFloat messageViewFrameBottom = self.messageView.frame.size.height - inputViewFrame.size.height;
                         if (inputViewFrameY > messageViewFrameBottom)
                             inputViewFrameY = messageViewFrameBottom;
						 
                         self.messageInputView.frame = CGRectMake(inputViewFrame.origin.x,
																  inputViewFrameY,
																  inputViewFrame.size.width,
																  inputViewFrame.size.height);

                         [self setTableViewInsetsWithBottomValue:self.messageView.frame.size.height
                                                                - self.messageInputView.frame.origin.y
                                                                - inputViewFrame.size.height];
                     }
                     completion:nil];
    [self OnClickHideTimeBomb];
}

#pragma mark - Dismissive text view delegate

- (void)keyboardDidScrollToPoint:(CGPoint)point
{
    CGRect inputViewFrame = self.messageInputView.frame;
    CGPoint keyboardOrigin = [self.messageView convertPoint:point fromView:nil];
    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
    self.messageInputView.frame = inputViewFrame;
}

- (void)keyboardWillBeDismissed
{
    CGRect inputViewFrame = self.messageInputView.frame;
    inputViewFrame.origin.y = self.messageView.bounds.size.height - inputViewFrame.size.height;
    self.messageInputView.frame = inputViewFrame;
}

- (void)keyboardWillSnapBackToPoint:(CGPoint)point
{
    if (!self.tabBarController.tabBar.hidden){
        return;
    }
	
    CGRect inputViewFrame = self.messageInputView.frame;
    CGPoint keyboardOrigin = [self.messageView convertPoint:point fromView:nil];
    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
    self.messageInputView.frame = inputViewFrame;
}

#pragma mark - Utilities

- (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve
{
    switch (curve) {
        case UIViewAnimationCurveEaseInOut:
            return UIViewAnimationOptionCurveEaseInOut;
            
        case UIViewAnimationCurveEaseIn:
            return UIViewAnimationOptionCurveEaseIn;
            
        case UIViewAnimationCurveEaseOut:
            return UIViewAnimationOptionCurveEaseOut;
            
        case UIViewAnimationCurveLinear:
            return UIViewAnimationOptionCurveLinear;
            
        default:
            return kNilOptions;
    }
}

#pragma mark -- PhotoActionDelegate
- (void)onButPhoto {
    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [picker setDelegate:self];
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)onButCamera {
    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [picker setDelegate:self];
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIAction Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    switch(buttonIndex){
            
        case 0:{
            
            UIImagePickerController* picker = [[UIImagePickerController alloc] init];
            [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [picker setDelegate:self];
            [self presentViewController:picker animated:YES completion:nil];
        }
            break;
            
        case 1:{
            
            UIImagePickerController* picker = [[UIImagePickerController alloc] init];
            [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [picker setDelegate:self];
            [self presentViewController:picker animated:YES completion:nil];
        }
            break;
            
        default:{
            
        }
            break;
            
    }
    
}

@end
