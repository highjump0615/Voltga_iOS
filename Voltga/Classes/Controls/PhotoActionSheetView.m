//
//  PhotoActionSheetView.m
//  Voltga
//
//  Created by highjump on 14-11-13.
//  Copyright (c) 2014年 DIYIN. All rights reserved.
//

#import "PhotoActionSheetView.h"

@implementation PhotoActionSheetView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init {
    self = [super init];
    
    return self;
}

+ (id)initView:(UIView *)parentView {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PhotoActionSheet" owner:nil options:nil];
    PhotoActionSheetView *view = [[PhotoActionSheetView alloc] init];
    view = (PhotoActionSheetView *)[nib objectAtIndex:0];

    [view setView:parentView];
    
    return view;
}

- (void)setView:(UIView *)parentView {
    
    mbIsShowing = NO;
    
    // set View
    [self.mViewButton.layer setMasksToBounds:YES];
    [self.mViewButton.layer setCornerRadius:5];
    
    [self.mViewCancel.layer setMasksToBounds:YES];
    [self.mViewCancel.layer setCornerRadius:5];
    
    [self.mButPhoto setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 30.0, 0, 0.0)];
    [self.mButCamera setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 30.0, 0, 0.0)];
    
    // add popup view
    mPopupView = [[UIView alloc] initWithFrame:parentView.frame];
    [mPopupView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    
    CGRect rtFrame = self.frame;
    rtFrame.origin.y = parentView.frame.size.height;
    [self setFrame:rtFrame];
    
    [mPopupView setAlpha:0];
    [parentView addSubview:mPopupView];
    
    [parentView addSubview:self];
}

- (void)showView {
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect rt = self.frame;
                         rt.origin.y -= self.frame.size.height;
                         self.frame = rt;
                         [mPopupView setAlpha:0.3];
                     }completion:^(BOOL finished) {
                         //						 self.view.userInteractionEnabled = YES;
                     }];
    
    mbIsShowing = YES;
}

- (IBAction)onButPhoto:(id)sender {
    if (self.delegate) {
        [self.delegate onButPhoto];
    }
    
    [self onButCancel:sender];
}

- (IBAction)onButCamera:(id)sender {
    if (self.delegate) {
        [self.delegate onButCamera];
    }
    
    [self onButCancel:sender];
}

- (IBAction)onButCancel:(id)sender {
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect rt = self.frame;
                         rt.origin.y += self.frame.size.height;
                         self.frame = rt;
                         [mPopupView setAlpha:0];
                     }completion:^(BOOL finished) {
                         //						 self.view.userInteractionEnabled = YES;
                     }];
    
    mbIsShowing = NO;
}

- (BOOL)isShowing {
    return mbIsShowing;
}


@end
