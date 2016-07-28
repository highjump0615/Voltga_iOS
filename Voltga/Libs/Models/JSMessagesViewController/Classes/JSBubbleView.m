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

#import "JSBubbleView.h"

#import "JSMessageInputView.h"
#import "JSAvatarImageFactory.h"
#import "NSString+JSMessagesView.h"

#define kMarginTop 8.0f
#define kMarginBottom 4.0f
#define kPaddingTop 4.0f
#define kPaddingBottom 8.0f
#define kBubblePaddingRight 35.0f

@interface JSBubbleView()

- (void)setup;

- (void)addTextViewObservers;
- (void)removeTextViewObservers;

+ (CGSize)textSizeForText:(NSString *)txt;
+ (CGSize)neededSizeForText:(NSString *)text;
+ (CGFloat)neededHeightForText:(NSString *)text;

@end


@implementation JSBubbleView

@synthesize font = _font;

#pragma mark - Setup

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.font = [UIFont fontWithName:@"Helvetica-Regular" size:16.0f];
}

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame
                   bubbleType:(JSBubbleMessageType)bubleType
              bubbleImageView:(UIImageView *)bubbleImageView
                      message:(id<JSMessageData>)message
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        
        _type = bubleType;
        _message = message;
        
        bubbleImageView.userInteractionEnabled = YES;
        [self addSubview:bubbleImageView];
        _bubbleImageView = bubbleImageView;
        
//        UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"time_background.png"]];
//        [self addSubview:imgView];
//        [self bringSubviewToFront:imgView];
//        _imgTimeBackView = imgView;

//        UILabel* lblView = [[UILabel alloc] init];
//        lblView.font = [UIFont fontWithName:@"Helvetica-Light" size:13.0f];
//        lblView.textColor = [UIColor colorWithWhite:1.f alpha:0.5f];
//        lblView.backgroundColor = [UIColor clearColor];
//        lblView.userInteractionEnabled = NO;
//        lblView.textAlignment = NSTextAlignmentCenter;
//
//        [self addSubview:lblView];
//        [self bringSubviewToFront:lblView];
//        _lblTimeStamp = lblView;
        
        
        if([message msgType] == TEXT_MESSAGE)
        {
            UITextView *textView = [[UITextView alloc] init];
            textView.font = _font; //TCOTS CHAT FONT SIZE
            textView.textColor = [UIColor colorWithWhite:1.f alpha:1.f];
            textView.editable = NO;
            textView.userInteractionEnabled = YES;
            textView.showsHorizontalScrollIndicator = NO;
            textView.showsVerticalScrollIndicator = NO;
            textView.scrollEnabled = NO;
            textView.backgroundColor = [UIColor clearColor];
            textView.contentInset = UIEdgeInsetsZero;
            textView.scrollIndicatorInsets = UIEdgeInsetsZero;
            textView.contentOffset = CGPointZero;
            textView.dataDetectorTypes = UIDataDetectorTypeNone;
            textView.userInteractionEnabled = YES;
            [self addSubview:textView];
            [self bringSubviewToFront:textView];
            _textView = textView;
            
            if ([_textView respondsToSelector:@selector(textContainerInset)]) {
                _textView.textContainerInset = UIEdgeInsetsMake(8.0f, 4.0f, 2.0f, 4.0f);
            }
            
            [self addTextViewObservers];
            
        }
        else if(([message msgType] == PHOTO_MESSAGE) || ([message msgType] == BOMB_MESSAGE))
        {
            UIImageView *photoView = [[UIImageView alloc] init];
            [self addSubview:photoView];
            [self bringSubviewToFront:photoView];
            [photoView.layer setCornerRadius:4.0f];
            [photoView.layer setMasksToBounds:YES];
            _photoView = photoView;
        }
        
//        NOTE: TODO: textView frame & text inset
//        --------------------
//        future implementation for textView frame
//        in layoutSubviews : "self.textView.frame = textFrame;" is not needed
//        when setting the property : "_textView.textContainerInset = UIEdgeInsetsZero;"
//        unfortunately, this API is available in iOS 7.0+
//        update after dropping support for iOS 6.0
//        --------------------
    }
    
    [self setBackgroundColor:[UIColor redColor]];
    return self;
}

- (void)dealloc
{
    [self removeTextViewObservers];
    _bubbleImageView = nil;
    _textView = nil;
}

#pragma mark - KVO

- (void)addTextViewObservers
{
    [_textView addObserver:self
                forKeyPath:@"text"
                   options:NSKeyValueObservingOptionNew
                   context:nil];
    
    [_textView addObserver:self
                forKeyPath:@"font"
                   options:NSKeyValueObservingOptionNew
                   context:nil];
    
    [_textView addObserver:self
                forKeyPath:@"textColor"
                   options:NSKeyValueObservingOptionNew
                   context:nil];
}

- (void)removeTextViewObservers
{
    [_textView removeObserver:self forKeyPath:@"text"];
    [_textView removeObserver:self forKeyPath:@"font"];
    [_textView removeObserver:self forKeyPath:@"textColor"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == self.textView) {
        if ([keyPath isEqualToString:@"text"]
           || [keyPath isEqualToString:@"font"]
           || [keyPath isEqualToString:@"textColor"]) {
            [self setNeedsLayout];
        }
    }
}

#pragma mark - Setters

- (void)setFont:(UIFont *)font
{
    _font = font;
//    _textView.font = font;
}

#pragma mark - UIAppearance Getters

- (UIFont *)font
{
    if (_font == nil) {
        _font = [[[self class] appearance] font];
    }
    
    if (_font != nil) {
        return _font;
    }
    
    return [UIFont systemFontOfSize:kChatTextFontSize]; //TCOTS CHAT FONT SIZE
}

#pragma mark - Getters

- (CGRect)bubbleFrame
{
    CGSize bubbleSize;
    
    if([_message msgType] == TEXT_MESSAGE)
        bubbleSize = [JSBubbleView neededSizeForText:self.textView.text];
    else if([_message msgType] == PHOTO_MESSAGE)
        bubbleSize = CGSizeMake([[_message nImgWidth] intValue] + 20, [[_message nImgHeight] intValue] + 8);
    else if([_message msgType] == BOMB_MESSAGE)
        bubbleSize = CGSizeMake(BOMB_SIZE_WIDTH + 52, BOMB_SIZE_HEIGHT + 12);
    else
        bubbleSize = CGSizeMake(AUDIO_VIEW_WIDTH + 20, AUDIO_VIEW_HEIGHT + 16);
    
    if([_message msgType] != BOMB_MESSAGE){
        bubbleSize.width += TIMESTAMP_WIDTH;
        bubbleSize.width = bubbleSize.width < 320 - kJSAvatarImageSize * 2 ? bubbleSize.width : 320 - kJSAvatarImageSize * 2;
    }
    
    return CGRectIntegral(CGRectMake((self.type == JSBubbleMessageTypeOutgoing ? self.frame.size.width - bubbleSize.width + kJSAvatarImageSize / 4 - 11.f: 4.0f),
                                     self.frame.size.height - bubbleSize.height, //kJSAvatarImageSize / 2,
                                     bubbleSize.width,
                                     bubbleSize.height));
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bubbleImageView.frame = [self bubbleFrame];
    
    CGFloat xPos = self.bubbleImageView.frame.origin.x;
    
    if (self.type == JSBubbleMessageTypeIncoming) {
        xPos += (self.bubbleImageView.image.capInsets.left / 2.0f);
        xPos += 12.0f;
    }
    
    CGRect msgFrame;
    CGRect timeFrame;
    
    if([_message msgType] == TEXT_MESSAGE)
    {
        if(_type == JSBubbleMessageTypeIncoming)
        {
            msgFrame = CGRectMake(self.bubbleImageView.frame.origin.x + 14.0f,
                                  self.bubbleImageView.frame.origin.y - 2.0f,
                                  self.bubbleImageView.frame.size.width - TIMESTAMP_WIDTH - (self.bubbleImageView.image.capInsets.right / 2.0f),
                                  self.bubbleImageView.frame.size.height);
            
            timeFrame = CGRectMake(self.bubbleImageView.frame.origin.x + self.bubbleImageView.frame.size.width - TIMESTAMP_WIDTH
                                   , self.bubbleImageView.frame.origin.y + 2.0f
                                   , TIMESTAMP_WIDTH
                                   , TIMESTAMP_WIDTH / 2);

        }
        else
        {
            msgFrame = CGRectMake(self.bubbleImageView.frame.origin.x + 2.0f,
                                  self.bubbleImageView.frame.origin.y - 2.0f,
                                  self.bubbleImageView.frame.size.width - TIMESTAMP_WIDTH - (self.bubbleImageView.image.capInsets.right / 2.0f),
                                  self.bubbleImageView.frame.size.height);

            timeFrame = CGRectMake(self.bubbleImageView.frame.origin.x + self.bubbleImageView.frame.size.width
                                                - TIMESTAMP_WIDTH
                                                - (self.bubbleImageView.image.capInsets.right / 2.0f)
                                   , self.bubbleImageView.frame.origin.y + 2.0f
                                   , TIMESTAMP_WIDTH
                                   , TIMESTAMP_WIDTH / 2);
        }
        self.textView.frame = CGRectIntegral(msgFrame);
        self.imgTimeBackView.frame = self.lblTimeStamp.frame = CGRectIntegral(timeFrame);

        
        
    }
    else if([_message msgType] == PHOTO_MESSAGE)
    {
        if(_type == JSBubbleMessageTypeIncoming)
        {
            msgFrame = CGRectMake(self.bubbleImageView.frame.origin.x + 16,
                                  self.bubbleImageView.frame.origin.y + 4,
                                  [[_message nImgWidth] intValue],
                                  [[_message nImgHeight] intValue]);

            timeFrame = CGRectMake(self.bubbleImageView.frame.origin.x + 17 + [[_message nImgWidth] intValue]
                                   , self.bubbleImageView.frame.origin.y + 4
                                   , TIMESTAMP_WIDTH
                                   , TIMESTAMP_WIDTH / 2);
            
        }
        else
        {
            msgFrame = CGRectMake(self.bubbleImageView.frame.origin.x + 4,
                                  self.bubbleImageView.frame.origin.y + 4,
                                  [[_message nImgWidth] intValue],
                                  [[_message nImgHeight] intValue]);

            timeFrame = CGRectMake(self.bubbleImageView.frame.origin.x + 5 + [[_message nImgWidth] intValue]
                                   , self.bubbleImageView.frame.origin.y + 4
                                   , TIMESTAMP_WIDTH
                                   , TIMESTAMP_WIDTH / 2);
            
        }
        self.photoView.frame = CGRectIntegral(msgFrame);
        self.imgTimeBackView.frame = self.lblTimeStamp.frame = CGRectIntegral(timeFrame);
        
    }
    else if([_message msgType] == BOMB_MESSAGE)
    {
        if(_type == JSBubbleMessageTypeIncoming)
        {
            msgFrame = CGRectMake(self.bubbleImageView.frame.origin.x + 32,
                                  self.bubbleImageView.frame.origin.y + 7,
                                  BOMB_SIZE_WIDTH,
                                  BOMB_SIZE_HEIGHT);
        }
        else
        {
            msgFrame = CGRectMake(self.bubbleImageView.frame.origin.x + 20,
                                  self.bubbleImageView.frame.origin.y + 7,
                                  BOMB_SIZE_WIDTH,
                                  BOMB_SIZE_HEIGHT);
        }
        
        self.photoView.frame = CGRectIntegral(msgFrame);
    }
    else
    {
        if(_type == JSBubbleMessageTypeIncoming)
        {
            msgFrame = CGRectMake(self.bubbleImageView.frame.origin.x + 16,
                                  self.bubbleImageView.frame.origin.y + 8,
                                  AUDIO_VIEW_WIDTH,
                                  AUDIO_VIEW_HEIGHT);
        }
        else
        {
            msgFrame = CGRectMake(self.bubbleImageView.frame.origin.x + 4,
                                  self.bubbleImageView.frame.origin.y + 8,
                                  AUDIO_VIEW_WIDTH,
                                  AUDIO_VIEW_HEIGHT);
        }
    }
}

#pragma mark - Bubble view

+ (CGSize)textSizeForText:(NSString *)txt
{
    CGFloat maxWidth = [UIScreen mainScreen].applicationFrame.size.width * 0.60f;
    CGFloat maxHeight = MAX([JSMessageTextView numberOfLinesForMessage:txt],
                         [txt js_numberOfLines]) * [JSMessageInputView textViewLineHeight];
    maxHeight += kJSAvatarImageSize;
    
    CGSize stringSize;

    CGRect stringRect = [txt boundingRectWithSize:CGSizeMake(maxWidth - TIMESTAMP_WIDTH, maxHeight)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{ NSFontAttributeName : [[JSBubbleView appearance] font] }
                                          context:nil];
    
    stringSize = CGRectIntegral(stringRect).size;
    
    return CGSizeMake(roundf(stringSize.width), roundf(stringSize.height));
}

+ (CGSize)neededSizeForText:(NSString *)text
{
    CGSize textSize = [JSBubbleView textSizeForText:text];
    
	return CGSizeMake(textSize.width + kBubblePaddingRight,
                      textSize.height + kPaddingTop + kPaddingBottom);
}

+ (CGFloat)neededHeightForText:(NSString *)text
{
    CGSize size = [JSBubbleView neededSizeForText:text];
    return size.height + kMarginTop + kMarginBottom;
}

@end