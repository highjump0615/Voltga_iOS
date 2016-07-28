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

#import "JSMessageInputView.h"

#import <QuartzCore/QuartzCore.h>
#import "JSBubbleView.h"
#import "NSString+JSMessagesView.h"
#import "UIColor+JSMessagesView.h"

#import "Global.h"
#import "GlobalData.h"

@interface JSMessageInputView ()

- (void)setup;
- (void)configureInputBarWithStyle:(JSMessageInputViewStyle)style;
- (void)configureSendButtonWithStyle:(JSMessageInputViewStyle)style;

@end

@implementation JSMessageInputView

#pragma mark - Initialization

- (void)setup
{
    //self.backgroundColor = [UIColor whiteColor];
//    self.backgroundColor = [UIColor clearColor];
    
    GlobalData *globalData = [GlobalData sharedData];
    [self setBackgroundColor:globalData.g_themeColor];
    
    self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
    self.opaque = YES;
    self.userInteractionEnabled = YES;
}

- (void)configureInputBarWithStyle:(JSMessageInputViewStyle)style
{
    CGFloat sendButtonWidth = (style == JSMessageInputViewStyleClassic) ? 78.0f : 64.0f;
    
    CGFloat width = self.frame.size.width - sendButtonWidth;
    CGFloat height = [JSMessageInputView textViewLineHeight];
    
    JSMessageTextView *textView = [[JSMessageTextView  alloc] initWithFrame:CGRectZero];
//    UITextView *textView = [[UITextView  alloc] initWithFrame:CGRectZero];
    [self addSubview:textView];
	_textView = textView;
    
    if (style == JSMessageInputViewStyleClassic) {
        
        _textView.frame = CGRectMake(6.0f, 3.0f, width, height);
        _textView.backgroundColor = [UIColor whiteColor];
        
        self.image = [[UIImage imageNamed:@"input-bar-background"] resizableImageWithCapInsets:UIEdgeInsetsMake(19.0f, 3.0f, 19.0f, 3.0f)
                                                                                  resizingMode:UIImageResizingModeStretch];
        
        UIImageView *inputFieldBack = [[UIImageView alloc] initWithFrame:CGRectMake(_textView.frame.origin.x - 1.0f,
                                                                                    0.0f,
                                                                                    _textView.frame.size.width + 2.0f,
                                                                                    self.frame.size.height)];
        inputFieldBack.image = [[UIImage imageNamed:@"input-field-cover"] resizableImageWithCapInsets:UIEdgeInsetsMake(20.0f, 12.0f, 18.0f, 18.0f)];
        inputFieldBack.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        inputFieldBack.backgroundColor = [UIColor clearColor];
        [self addSubview:inputFieldBack];
        
    } else {
        
        _textView.clipsToBounds = YES;
        _textView.layer.cornerRadius = 3.0f;
        _textView.frame = CGRectMake(60.0f, 10.0f, 200.0f, height);
        [_textView setReturnKeyType:UIReturnKeySend];
        
        // InputTextView Back Color
//        _textView.backgroundColor = [UIColor grayColor];
        _textView.backgroundColor = [UIColor whiteColor];
//        [_textView setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
//        self.image = [UIImage imageNamed:@"bgInputView.png"];
        
    }
}

- (void)configureSendButtonWithStyle:(JSMessageInputViewStyle)style
{
    UIButton *sendButton;
    
    if (style == JSMessageInputViewStyleClassic) {
        sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 13.0f, 0.0f, 13.0f);
        UIImage *sendBack = [[UIImage imageNamed:@"send-button"] resizableImageWithCapInsets:insets];
        UIImage *sendBackHighLighted = [[UIImage imageNamed:@"send-button"] resizableImageWithCapInsets:insets];
        [sendButton setBackgroundImage:sendBack forState:UIControlStateNormal];
        [sendButton setBackgroundImage:sendBack forState:UIControlStateDisabled];
        [sendButton setBackgroundImage:sendBackHighLighted forState:UIControlStateHighlighted];
        
        UIColor *titleShadow = [UIColor colorWithRed:0.325f green:0.463f blue:0.675f alpha:1.0f];
        [sendButton setTitleShadowColor:titleShadow forState:UIControlStateNormal];
        [sendButton setTitleShadowColor:titleShadow forState:UIControlStateHighlighted];
        sendButton.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
        
        [sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [sendButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateDisabled];
        
        sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    }
    else
    {
        sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
        sendButton.backgroundColor = [UIColor clearColor];
        
        [sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [sendButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];

        //TCOTS: button color
//        [sendButton setTitleColor:[UIColor colorWithRed:181.0f/255.0f green:212.0f/255.0f blue:52.0f/255.0f alpha:1.0f] forState:UIControlStateDisabled];
        
        [sendButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:17.0f]];
//        sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    }
    
    NSString *title = NSLocalizedString(@"send", nil);
    [sendButton setTitle:title forState:UIControlStateNormal];
    [sendButton setTitle:title forState:UIControlStateHighlighted];
    [sendButton setTitle:title forState:UIControlStateDisabled];
    
    sendButton.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin);
    
    [self setSendButton:sendButton];
}

- (void)configurePhotoButton
{
    UIButton *photoButton;
    
    photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoButton setImage:[UIImage imageNamed:@"button-photo"] forState:UIControlStateNormal];
//    [photoButton setBackgroundImage:[UIImage imageNamed:@"button-photo"] forState:UIControlStateNormal];
    [self setPhotoButton:photoButton];
}

- (void)setPhotoButton:(UIButton *)photoButton
{
    [photoButton setFrame:CGRectMake(16, 13, 24, 22)];
    [self addSubview:photoButton];
    photoButton.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin);

    _photoButton = photoButton;
}

- (void)configureVoiceButton
{
    UIButton *voiceButton;
    
    voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [voiceButton setBackgroundImage:[UIImage imageNamed:@"btnVoice.png"] forState:UIControlStateNormal];
    [self setVoiceButton:voiceButton];
}

//- (void)setVoiceButton:(ABFillButton *)voiceButton
//{
//    [voiceButton setFrame:CGRectMake(215, 4, 40, 40)];
//    [self addSubview:voiceButton];
//    voiceButton.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin);
//
//    _voiceButton = voiceButton;
//}

- (instancetype)initWithFrame:(CGRect)frame
                        style:(JSMessageInputViewStyle)style
                     delegate:(id<UITextViewDelegate, JSDismissiveTextViewDelegate>)delegate
         panGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _style = style;
        [self setup];
        [self configureInputBarWithStyle:style];
        [self configureSendButtonWithStyle:style];
        [self configurePhotoButton];
//        [self configureVoiceButton];
        
        _textView.delegate = delegate;
        _textView.keyboardDelegate = delegate;
        _textView.dismissivePanGestureRecognizer = panGestureRecognizer;
    }
    return self;
}

- (void)dealloc
{
    _textView = nil;
    _sendButton = nil;
}

#pragma mark - UIView

- (BOOL)resignFirstResponder
{
    [self.textView resignFirstResponder];
    return [super resignFirstResponder];
}

#pragma mark - Setters

- (void)setSendButton:(UIButton *)btn
{
    if (_sendButton)
        [_sendButton removeFromSuperview];
    
    if (self.style == JSMessageInputViewStyleClassic) {
        btn.frame = CGRectMake(self.frame.size.width - 70.0f, 2.0f, 59.0f, 26.0f);
    }
    else {
        CGFloat padding = 5.f;
        btn.frame = CGRectMake(self.textView.frame.origin.x + self.textView.frame.size.width + 3.0f, //18.0
                               padding,
                               60.0f,
                               self.frame.size.height - padding);
        
//        [btn setBackgroundColor:[UIColor redColor]];
    }
    
    [self addSubview:btn];
    _sendButton = btn;
}

#pragma mark - Message input view

- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight
{
    CGRect prevFrame = self.textView.frame;
    
    NSUInteger numLines = MAX([self.textView numberOfLinesOfText],
                              [self.textView.text js_numberOfLines]);
    
    //  below iOS 7, if you set the text view frame programmatically, the KVO will continue notifying
    //  to avoid that, we are removing the observer before setting the frame and add the observer after setting frame here.
    [self.textView removeObserver:_textView.keyboardDelegate
                       forKeyPath:@"contentSize"];
    
    self.textView.frame = CGRectMake(prevFrame.origin.x,
                                     prevFrame.origin.y,
                                     prevFrame.size.width,
                                     prevFrame.size.height + changeInHeight);
    
    [self.textView addObserver:_textView.keyboardDelegate
                    forKeyPath:@"contentSize"
                       options:NSKeyValueObservingOptionNew
                       context:nil];

    self.textView.contentInset = UIEdgeInsetsMake((numLines >= 6 ? 4.0f : 0.0f),
                                                  0.0f,
                                                  (numLines >= 6 ? 4.0f : 0.0f),
                                                  0.0f);
    
    // from iOS 7, the content size will be accurate only if the scrolling is enabled.
    self.textView.scrollEnabled = YES;
    
    if (numLines >= 6) {
        CGPoint bottomOffset = CGPointMake(0.0f, self.textView.contentSize.height - self.textView.bounds.size.height);
        [self.textView setContentOffset:bottomOffset animated:YES];
        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length - 2, 1)];
    }
}



+ (CGFloat)textViewLineHeight
{
    return 28.0f; //22.0f for fontSize 16.0f
}

+ (CGFloat)maxLines
{
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 3.0f : 6.0f;
}

+ (CGFloat)maxHeight
{
    return [JSMessageInputView maxLines] * [JSMessageInputView textViewLineHeight] - 5.0f;
}

@end
