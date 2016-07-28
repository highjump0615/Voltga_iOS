//
//  PlaceViewCell.h
//  Voltga
//
//  Created by JackQuan on 8/4/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *m_imgPlacePicture;

@property (strong, nonatomic) IBOutlet UILabel *m_lblPlaceTitle;
@property (weak, nonatomic) IBOutlet UILabel *m_lblPlaceAddress;

@property (weak, nonatomic) IBOutlet UIButton *m_btnUser;

@end
