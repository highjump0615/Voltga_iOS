//
//  PlaceViewController.h
//  Voltga
//
//  Created by JackQuan on 8/4/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray* m_aryPlace;
    NSMutableArray* m_arySearchedPlace;
    
    BOOL            m_bIsLoaded;
}

@property (strong, nonatomic) IBOutlet UIView *m_viewTitleBar;
//@property (strong, nonatomic) IBOutlet UIImageView *m_imgTitleIcon;
@property (strong, nonatomic) IBOutlet UILabel *m_lblPlaceTitle;
@property (strong, nonatomic) IBOutlet UITableView *m_tblPlace;
@property (strong, nonatomic) IBOutlet UISearchBar *m_schPlace;

@end
