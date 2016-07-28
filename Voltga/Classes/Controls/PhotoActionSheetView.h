//
//  PhotoActionSheetView.h
//  Voltga
//
//  Created by highjump on 14-11-13.
//  Copyright (c) 2014年 DIYIN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoActionDelegate <NSObject>
- (void)onButPhoto;
- (void)onButCamera;
@end

@interface PhotoActionSheetView : UIView {
    UIView *mPopupView;
    BOOL mbIsShowing;
}

@property (weak, nonatomic) IBOutlet UIView *mViewButton;
@property (weak, nonatomic) IBOutlet UIView *mViewCancel;
@property (weak, nonatomic) IBOutlet UIButton *mButPhoto;
@property (weak, nonatomic) IBOutlet UIButton *mButCamera;
@property (weak, nonatomic) IBOutlet UIButton *mButCancel;

@property (strong) id <PhotoActionDelegate> delegate;

+ (id)initView:(UIView *)parentView;
- (void)showView;
- (BOOL)isShowing;

@end
