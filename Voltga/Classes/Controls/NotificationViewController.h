//
//  NotificationViewController.h
//  Voltga
//
//  Created by JackQuan on 8/5/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray*         m_aryNotification;
    BOOL                    m_bIsLoaded;
}

@property (strong, nonatomic) IBOutlet UITableView *m_tblNotification;
@end
