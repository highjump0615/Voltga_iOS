//
//  AVIMInstantMessagesViewController.h
//  Hollerr
//
//  Created by galaxy.d on 5/27/14.
//  Copyright (c) 2014 AVIM. All rights reserved.
//

#import "JSMessagesViewController.h"

@interface ChatViewController : JSMessagesViewController<JSMessagesViewDataSource, JSMessagesViewDelegate, UIGestureRecognizerDelegate>
{
    BOOL                bShowInvitation;
    BOOL                initialized;
    NSMutableArray      *m_aryMessages;
    CGFloat _centerX;
}

@property (readwrite, nonatomic) int base_id;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (readwrite, nonatomic) BOOL isReadMore;
@property (readwrite, nonatomic) BOOL isReadMore_;

@property (nonatomic) BOOL mbLoop;

- (void)startGetMessage;

@end
