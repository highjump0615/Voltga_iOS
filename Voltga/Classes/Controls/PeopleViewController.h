//
//  PeopleViewController.h
//  Voltga
//
//  Created by JackQuan on 8/5/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeopleViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>
{
    
@public
    NSMutableArray* m_aryPeople;
    BOOL            m_bIsLoaded;
    
}

@property (strong, nonatomic) IBOutlet UICollectionView *m_colPeople;
@end
