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

#import "JSBubbleMessageCell.h"

#import "JSAvatarImageFactory.h"
#import "UIColor+JSMessagesView.h"
//#import "UIImageView+AFNetworking.h"
#import "UIImageView+WebCache.h"

static const CGFloat kJSLabelPadding = 7.0f;
static const CGFloat kJSTimeStampLabelHeight = 15.0f;

@interface JSBubbleMessageCell()

- (void)setup;
- (void)configureTimestampLabel;

- (void)configureAvatarImageView:(UIImageView *)imageView
                  forMessageType:(JSBubbleMessageType)type
                         message:(id<JSMessageData>)message;

- (void)configureWithType:(JSBubbleMessageType)type
          bubbleImageView:(UIImageView *)bubbleImageView
                  message:(id<JSMessageData>)message
        displaysTimestamp:(BOOL)displaysTimestamp
                   avatar:(BOOL)hasAvatar;

- (void)setText:(NSString *)text;
- (void)setTimestamp:(NSString *)date;

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)longPress;

- (void)handleMenuWillHideNotification:(NSNotification *)notification;
- (void)handleMenuWillShowNotification:(NSNotification *)notification;

@end



@implementation JSBubbleMessageCell

#pragma mark - Setup

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.accessoryView = nil;
    
    self.imageView.image = nil;
    self.imageView.hidden = YES;
    self.textLabel.text = nil;
    self.textLabel.hidden = YES;
    self.detailTextLabel.text = nil;
    self.detailTextLabel.hidden = YES;
    
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(handleLongPressGesture:)];
    [recognizer setMinimumPressDuration:0.4f];
//    [self.bubbleView addGestureRecognizer:recognizer];
}

- (void)configureTimestampLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kJSLabelPadding,
                                                               0,
                                                               self.contentView.frame.size.width - (kJSLabelPadding * 2.0f),
                                                               kJSTimeStampLabelHeight)];
//    label.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor js_messagesTimestampColorClassic];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0.0f, 1.0f);
    label.font = [UIFont fontWithName:@"Helvetica-Light" size:11.0f];
    
    [self.contentView addSubview:label];
    [self.contentView bringSubviewToFront:label];
    _timestampLabel = label;
}

- (void)configureAvatarImageView:(UIImageView *)imageView
                  forMessageType:(JSBubbleMessageType)type
                         message:(id<JSMessageData>)message

{
    CGFloat avatarX = kJSLabelPadding;
    if (type == JSBubbleMessageTypeOutgoing) {
        avatarX = (self.contentView.frame.size.width - kJSAvatarImageSize - kJSLabelPadding);
    }
    
    CGFloat avatarY = self.contentView.frame.size.height - kJSAvatarImageSize - kJSLabelPadding;
    
    if ([message date]) {
        avatarY -= kJSTimeStampLabelHeight;
    }
    
    imageView.frame = CGRectMake(avatarX,
                                 avatarY,
                                 kJSAvatarImageSize,
                                 kJSAvatarImageSize);
    imageView.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin
                                  | UIViewAutoresizingFlexibleLeftMargin
                                  | UIViewAutoresizingFlexibleRightMargin);

    
    [self.contentView addSubview:imageView];
    _avatarImageView = imageView;
    
}

- (void)configureWithType:(JSBubbleMessageType)type
          bubbleImageView:(UIImageView *)bubbleImageView
                  message:(id<JSMessageData>)message
         displaysTimestamp:(BOOL)displaysTimestamp
                   avatar:(BOOL)hasAvatar
{
    CGFloat bubbleX = 0.0f;
    
    self.bubbleType = type;
    
//    if (displaysTimestamp) {
//        [self configureTimestampLabel];
//    }
    
    if (hasAvatar) {
        bubbleX = kJSAvatarImageSize + kJSLabelPadding - 7.f;
        
        if (type == JSBubbleMessageTypeOutgoing) {
            bubbleX = 0;
        }
        
        [self configureAvatarImageView:[[UIImageView alloc] init] forMessageType:type message:message];
    }

    CGFloat bubbleY = 0.f;
    CGFloat bubbleHeight = self.contentView.frame.size.height - /*_timestampLabel.frame.size.height - */kJSLabelPadding;
    if ([message date]) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kJSLabelPadding,
                                                                   bubbleHeight - 12,
                                                                   self.contentView.frame.size.width - (kJSLabelPadding * 2.0f),
                                                                   kJSTimeStampLabelHeight)];
        label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor js_messagesTimestampColorClassic];
        label.font = [UIFont fontWithName:@"Helvetica-Light" size:12.0f];
        
        [self.contentView addSubview:label];
        [self.contentView bringSubviewToFront:label];
        _timestampLabel = label;
        
        bubbleHeight -= kJSTimeStampLabelHeight;
    }
    
    CGRect frame = CGRectMake(bubbleX,
                              bubbleY,
                              self.contentView.frame.size.width - kJSAvatarImageSize - kJSLabelPadding,
                              bubbleHeight);
    
    JSBubbleView *bubbleView = [[JSBubbleView alloc] initWithFrame:frame
                                                        bubbleType:type
                                                   bubbleImageView:bubbleImageView
                                                           message:(id<JSMessageData>)message];
    
    bubbleView.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                                    | UIViewAutoresizingFlexibleHeight
                                    | UIViewAutoresizingFlexibleTopMargin);
    
    [self.contentView addSubview:bubbleView];
    [self.contentView sendSubviewToBack:bubbleView];
    _bubbleView = bubbleView;
    
    if (type == JSBubbleMessageTypeIncoming) {
        [bubbleView.textView setTextColor:[UIColor colorWithRed:181/255.0 green:212/255.0 blue:52/255.0 alpha:1]];
    }
    else {
    }
    
}

#pragma mark - Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithBubbleType:(JSBubbleMessageType)type
                   bubbleImageView:(UIImageView *)bubbleImageView
                           message:(id<JSMessageData>)message
                 displaysTimestamp:(BOOL)displaysTimestamp
                         hasAvatar:(BOOL)hasAvatar
                   reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureWithType:type
                bubbleImageView:bubbleImageView
                        message:message
              displaysTimestamp:displaysTimestamp
                         avatar:hasAvatar];
    }
    return self;
}

- (void)dealloc
{
    _bubbleView = nil;
    _timestampLabel = nil;
    _avatarImageView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - TableViewCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.bubbleView.textView.text = nil;
    self.timestampLabel.text = nil;
//    self.avatarImageView = nil;
}

- (void)setBackgroundColor:(UIColor *)color
{
    [super setBackgroundColor:color];
    [self.contentView setBackgroundColor:color];
    [self.bubbleView setBackgroundColor:color];
}

#pragma mark - Setters

- (void)setTimeStamp:(NSString*)timeStamp{
    
    
    self.bubbleView.lblTimeStamp.text = timeStamp;
    
}

- (void)setText:(NSString *)text
{
    
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:text];
    
    if (self.bubbleType == JSBubbleMessageTypeIncoming) {
        [attrText addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithRed:181/255.0 green:212/255.0 blue:52/255.0 alpha:1]
                         range:NSMakeRange(0, text.length)];
    }
    else {
        [attrText addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1]
                         range:NSMakeRange(0, text.length)];
    }

    [self getAttributedText:text AttributedString:attrText Start:0];
    
    //TCOTS CHAT FONT SIZE
    [attrText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kChatTextFontSize] range:NSMakeRange(0, text.length)];
    
    [self.bubbleView.textView setAttributedText:attrText];
    
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

- (void)setPhoto:(NSString *)photo
{
    UIImage* imgDefaultAvatar = [UIImage imageNamed:@"img_default_user.png"];
    [self.bubbleView.photoView sd_setImageWithURL:[NSURL URLWithString:photo]
                                 placeholderImage:imgDefaultAvatar
                                          options:SDWebImageProgressiveDownload | SDWebImageRetryFailed];
    
}



- (void)setTimestamp:(NSString *)date
{
    self.timestampLabel.text = date;
}

- (void)setMessage:(id<JSMessageData>)message
{
    
    if([message msgType] == TEXT_MESSAGE)
        [self setText:[message text]];
    else if([message msgType] == PHOTO_MESSAGE)
        [self setPhoto:[message photo]];
    else if([message msgType] == BOMB_MESSAGE)
        [self.bubbleView.photoView setImage:[UIImage imageNamed:@"img_timebomb1.png"]];
    
//    [self setTimestamp:[message date]];
//    [self setTimeStamp:[message date]];
}

- (void)setAvatarImageView:(UIImageView *)imageView message:(id<JSMessageData>)message
{
    [_avatarImageView removeFromSuperview];
    _avatarImageView = nil;
    
    [self configureAvatarImageView:imageView forMessageType:[self messageType] message:message];
}

#pragma mark - Getters

- (JSBubbleMessageType)messageType
{
    return _bubbleView.type;
}

#pragma mark - Class methods

+ (CGFloat)neededHeightForBubbleMessageCellWithMessage:(id<JSMessageData>)message
                                                avatar:(BOOL)hasAvatar
{
    CGFloat timestampHeight = 0;
    NSString *strDate = [message date];
    if (strDate != nil && strDate.length > 0) {
        timestampHeight = kJSTimeStampLabelHeight;
    }
    CGFloat avatarHeight = hasAvatar ? kJSAvatarImageSize : 0.0f;
    
    CGFloat subviewHeights = timestampHeight + kJSLabelPadding;
    
    CGFloat bubbleHeight;
    if([message msgType] == TEXT_MESSAGE)
        bubbleHeight = [JSBubbleView neededHeightForText:[message text]];
    else if([message msgType] == PHOTO_MESSAGE)
        bubbleHeight = [[message nImgHeight] intValue] + 20.0f;
    else if([message msgType] == BOMB_MESSAGE)
        bubbleHeight = BOMB_SIZE_HEIGHT + 20.0f;
    else
        bubbleHeight = AUDIO_VIEW_HEIGHT + 20.0f;
    
    return subviewHeights + MAX(avatarHeight, bubbleHeight);
}

#pragma mark - Copying

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    return [super becomeFirstResponder];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return (action == @selector(copy:));
}

- (void)copy:(id)sender
{
    [[UIPasteboard generalPasteboard] setString:self.bubbleView.textView.text];
    [self resignFirstResponder];
}

#pragma mark - Gestures

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state != UIGestureRecognizerStateBegan || ![self becomeFirstResponder] || self.bubbleView.textView.text.length == 0)
        return;
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    CGRect targetRect = [self convertRect:[self.bubbleView bubbleFrame]
                                 fromView:self.bubbleView];
    
    [menu setTargetRect:CGRectInset(targetRect, 0.0f, 4.0f) inView:self];
    
    self.bubbleView.bubbleImageView.highlighted = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillShowNotification:)
                                                 name:UIMenuControllerWillShowMenuNotification
                                               object:nil];
    [menu setMenuVisible:YES animated:YES];
}

#pragma mark - Notifications

- (void)handleMenuWillHideNotification:(NSNotification *)notification
{
    self.bubbleView.bubbleImageView.highlighted = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:nil];
}

- (void)handleMenuWillShowNotification:(NSNotification *)notification
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillHideNotification:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
}

@end