//
//  CurrentViewController.m
//  Voltga
//
//  Created by JackQuan on 8/5/14.
//  Copyright (c) 2014 DIYIN. All rights reserved.
//

#import "CurrentViewController.h"
#import "AppDelegate.h"

@interface CurrentViewController ()

@end

@implementation CurrentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_m_lblPlaceTitle setText:((GlobalData*) [GlobalData sharedData]).g_currentPlace.place_name];
    
    m_viewCtrlPeople = [self.storyboard instantiateViewControllerWithIdentifier:@"PeopleViewController"];
    m_viewCtrlChat = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
    m_viewCtrlNotification = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationViewController"];
    
    [self addChildViewController:m_viewCtrlPeople];
    [self addChildViewController:m_viewCtrlChat];
    [self addChildViewController:m_viewCtrlNotification];
    
    CGRect viewFrame = m_viewCtrlPeople.view.frame;
    viewFrame.size = _m_viewMain.frame.size;
    [m_viewCtrlPeople.view setFrame:viewFrame];
    
    viewFrame = m_viewCtrlNotification.view.frame;
    viewFrame.size = _m_viewMain.frame.size;
    [m_viewCtrlNotification.view setFrame:viewFrame];

    [_m_viewMain addSubview:m_viewCtrlPeople.view];
    [_m_viewMain addSubview:m_viewCtrlChat.view];
    [_m_viewMain addSubview:m_viewCtrlNotification.view];
    
    [self.m_btnBadge.layer setCornerRadius:self.m_btnBadge.frame.size.width / 2];
    [self.m_btnBadge.titleLabel setFont:[UIFont systemFontOfSize:11.0f]];
    [self.m_btnBadge.titleLabel setTintColor:[UIColor whiteColor]];
    [self.m_btnBadge.layer setMasksToBounds:YES];
    [self.m_btnBadge setTitle:@"0" forState:UIControlStateDisabled];
    [self.m_btnBadge setBackgroundColor:[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.f]];
    [self.m_btnBadge setHidden:YES];
    [self.m_btnBadge setEnabled:NO];
    
    [self initControls:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNewNotification:) name:NEW_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSetNotification:) name:SET_TOTAL_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRemoveNotificationBadge:) name:REMOVE_NOTIFICATION object:nil];
    
    // google analytics init
    [self setScreenName:@"Current Screen"];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_m_lblPlaceTitle setText:((GlobalData*) [GlobalData sharedData]).g_currentPlace.place_name];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SET_TOTAL_NOTIFICATION object:nil];

    // if on chat tab, start polling
    if (!m_viewCtrlChat.view.hidden)
    {
        [m_viewCtrlChat startGetMessage];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) initControls:(NSInteger)index
{
    [m_viewCtrlPeople.view setHidden:YES];
    [m_viewCtrlNotification.view setHidden:YES];
    [m_viewCtrlChat.view setHidden:YES];
    m_viewCtrlChat.mbLoop = NO;
    
    // set button icons
    [self.m_btnPeople setImage:[UIImage imageNamed:@"current_people_tab.png"] forState:UIControlStateNormal];
    [self.m_btnChat setImage:[UIImage imageNamed:@"current_chat_tab.png"] forState:UIControlStateNormal];
    [self.m_btnNotification setImage:[UIImage imageNamed:@"current_notify_tab.png"] forState:UIControlStateNormal];
    
    switch (index)
    {
        case 0:
            [m_viewCtrlPeople.view setHidden:NO];
            [self.m_btnPeople setImage:[UIImage imageNamed:@"current_people_tab_selected.png"] forState:UIControlStateNormal];
            
            break;
            
        case 1:
            // start polling
            [m_viewCtrlChat.view setHidden:NO];
            [m_viewCtrlChat startGetMessage];
            [self.m_btnChat setImage:[UIImage imageNamed:@"current_chat_tab_selected.png"] forState:UIControlStateNormal];
            
            break;
            
        case 2:

            [m_viewCtrlNotification.view setHidden:NO];
            [self.m_btnNotification setImage:[UIImage imageNamed:@"current_notify_tab_selected.png"] forState:UIControlStateNormal];
            
            //TCOTS
            // ****************** SEND REMOVE BADGE REQUEST TO SERVER ****************** //
            //API : removeBadgesWithUserID
            [[CommAPIManager sharedCommAPIManager] removeBadgesWithUserID:[[[GlobalData sharedData] g_selfUser].user_id stringValue]
                                                                  PlaceID:[[[GlobalData sharedData] g_selfUser].user_place_id stringValue]
                                                                successed:^(id responseObject)
                                                                    {
                                                                        NSLog(@"%@", responseObject);
                                                                        if ([[responseObject objectForKey:WEBAPI_RETURN_RESULT] isEqualToString:WEBAPI_RETURN_SUCCESS])
                                                                        {
                                                                            [[NSNotificationCenter defaultCenter] postNotificationName:REMOVE_NOTIFICATION object:nil];
                                                                        }
                                                                    }
                                                                  failure:^(NSError *error)
                                                                    {
                                                                        
                                                                    }];

            break;
            
        default:
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onClickPeople:(id)sender
{
    [self onChangeTab:0];
}

- (IBAction)onClickChat:(id)sender
{
    [self onChangeTab:1];
}

- (IBAction)onClickNotification:(id)sender
{
    [self onChangeTab:2];
}

- (IBAction)onChangeTab:(NSInteger)index {
    if (index != 1)
        [self->m_viewCtrlChat.messageInputView.textView resignFirstResponder];
    [self initControls:index];
}



#pragma NSNotification observer
- (void)onNewNotification:(NSNotification*)notificcation
{
    [self plusBadegeNumber];
    NSLog(@"%@", notificcation);
}

- (void)onRemoveNotificationBadge:(NSNotification*)notificcation
{
    ((GlobalData*) [GlobalData sharedData]).g_nBadgeNumber = 0;
    [self setBadgeNumber:((GlobalData*) [GlobalData sharedData]).g_nBadgeNumber];
    NSLog(@"%@", notificcation);
}

- (void)onSetNotification:(NSNotification*)notificcation
{
    [self  setBadgeNumber:((GlobalData*) [GlobalData sharedData]).g_nBadgeNumber];
    NSLog(@"%@", notificcation);
}


#pragma - mark badge setting.
- (void)setBadgeNumber:(int)badge
{
    [self.m_btnBadge setTitle:[NSString stringWithFormat:@"%d", badge] forState:UIControlStateDisabled];
    [self.m_btnBadge setHidden:badge == 0];
}

- (void)plusBadegeNumber
{
    [self.m_btnBadge setTitle:[NSString stringWithFormat:@"%d", ((GlobalData*)[GlobalData sharedData]).g_nBadgeNumber] forState:UIControlStateDisabled];
    [self.m_btnBadge setHidden:((GlobalData*)[GlobalData sharedData]).g_nBadgeNumber == 0];
}


@end
