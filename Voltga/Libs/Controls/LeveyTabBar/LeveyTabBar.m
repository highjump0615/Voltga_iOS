//
//  LeveyTabBar.m
//  LeveyTabBarController
//
//  Created by Levey Zhu on 12/15/10.
//  Copyright 2010 SlyFairy. All rights reserved.
//

#import "LeveyTabBar.h"
#import "AppDelegate.h"

@implementation LeveyTabBar
@synthesize backgroundView = _backgroundView;
@synthesize delegate = _delegate;
@synthesize buttons = _buttons;
@synthesize animatedView = _animatedView;
@synthesize badgeButton = _badgeButton;

- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray
{
    self = [super initWithFrame:frame];
    if (self)
	{
		self.backgroundColor = [UIColor clearColor];
		_backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
		[self addSubview:_backgroundView];
		
		self.buttons = [NSMutableArray arrayWithCapacity:[imageArray count]];
		UIButton *btn;
		CGFloat width = (IS_IPHONE ? 320 : 768) / [imageArray count];
		for (int i = 0; i < [imageArray count]; i++)
		{
			btn = [UIButton buttonWithType:UIButtonTypeCustom];
			btn.showsTouchWhenHighlighted = YES;
			btn.tag = i;
			btn.frame = CGRectMake(width * i + 1, 0, width, frame.size.height);
			[btn setBackgroundImage:[[imageArray objectAtIndex:i] objectForKey:@"Default"] forState:UIControlStateNormal];
			[btn setBackgroundImage:[[imageArray objectAtIndex:i] objectForKey:@"Highlighted"] forState:UIControlStateHighlighted];
			[btn setBackgroundImage:[[imageArray objectAtIndex:i] objectForKey:@"Selected"] forState:UIControlStateSelected];
            if ([[imageArray objectAtIndex:i] objectForKey:@"Selected|Highlighted"]) {
                [btn setBackgroundImage:[[imageArray objectAtIndex:i] objectForKey:@"Selected|Highlighted"] forState:UIControlStateSelected | UIControlStateHighlighted];
            }
			[btn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
			[self.buttons addObject:btn];
			[self addSubview:btn];
		}
        self.badgeButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        if (IS_IPHONE)
        {
            [self.badgeButton setFrame:CGRectMake(width + width * 2 / 3.0, width / 20, width / 10, width / 10)];
        }
        else
        {
            [self.badgeButton setFrame:CGRectMake(width + width / 1.9f, width / 20, width / 4, width / 4)];
        }
        
        [self.badgeButton.layer setCornerRadius:self.badgeButton.frame.size.width / 2];
        [self.badgeButton.titleLabel setFont:[UIFont systemFontOfSize:11.0f]];
        [self.badgeButton.titleLabel setTintColor:[UIColor whiteColor]];
        [self.badgeButton.layer setMasksToBounds:YES];
//        [self.badgeButton setTitle:@"0" forState:UIControlStateDisabled];
        [self.badgeButton setBackgroundColor:[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.f]];
        [self.badgeButton setHidden:YES];
        [self.badgeButton setEnabled:NO];
        [self addSubview:self.badgeButton];
        
    }
    return self;
}

- (void)setBackgroundImage:(UIImage *)img
{
	[_backgroundView setImage:img];
}

- (void)setAnimatedView:(UIImageView *)animatedView
{
    _animatedView = animatedView;
    [self addSubview:animatedView];
}

- (void)tabBarButtonClicked:(id)sender
{
    UIButton *btn = sender;
    int index = (int)btn.tag;
    if ([_delegate respondsToSelector:@selector(tabBar:shouldSelectIndex:)])
    {
        if (![_delegate tabBar:self shouldSelectIndex:index])
        {
            return;
        }
    }
    [self selectTabAtIndex:index];
}

- (void)selectTabAtIndex:(NSInteger)index
{
	for (int i = 0; i < [self.buttons count]; i++)
	{
		UIButton *b = [self.buttons objectAtIndex:i];
		b.selected = NO;
	}
	UIButton *btn = [self.buttons objectAtIndex:index];
	btn.selected = YES;
    if ([_delegate respondsToSelector:@selector(tabBar:didSelectIndex:)])
    {
        [_delegate tabBar:self didSelectIndex:btn.tag];
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        _animatedView.frame = CGRectMake(btn.frame.origin.x, _animatedView.frame.origin.y, _animatedView.frame.size.width, _animatedView.frame.size.height);
    }];
    
    NSLog(@"Select index: %d", (int)btn.tag);
}

- (void)removeTabAtIndex:(NSInteger)index
{
    // Remove button
    [(UIButton *)[self.buttons objectAtIndex:index] removeFromSuperview];
    [self.buttons removeObjectAtIndex:index];
   
    // Re-index the buttons
     CGFloat width = (IS_IPHONE ? 320 : 768) / [self.buttons count];
    for (UIButton *btn in self.buttons) 
    {
        if (btn.tag > index)
        {
            btn.tag --;
        }
        btn.frame = CGRectMake(width * btn.tag, 0, width, self.frame.size.height);
    }
}
- (void)insertTabWithImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index
{
    // Re-index the buttons
    CGFloat width = (IS_IPHONE ? 320 : 768) / ([self.buttons count] + 1);
    for (UIButton *b in self.buttons) 
    {
        if (b.tag >= index)
        {
            b.tag ++;
        }
        b.frame = CGRectMake(width * b.tag, 0, width, self.frame.size.height);
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.showsTouchWhenHighlighted = YES;
    btn.tag = index;
    btn.frame = CGRectMake(width * index, 0, width, self.frame.size.height);
    [btn setBackgroundImage:[dict objectForKey:@"Default"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[dict objectForKey:@"Highlighted"] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[dict objectForKey:@"Selected"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttons insertObject:btn atIndex:index];
    [self addSubview:btn];
}

- (void)setBadgeNumber:(int)badge
{
//    [self.badgeButton setTitle:[NSString stringWithFormat:@"%d", badge] forState:UIControlStateDisabled];
    [self.badgeButton setHidden:badge == 0];
}

- (void)plusBadegeNumber
{
//    [self.badgeButton setTitle:[NSString stringWithFormat:@"%d", ((GlobalData*)[GlobalData sharedData]).g_nBadgeNumber] forState:UIControlStateDisabled];
    [self.badgeButton setHidden:((GlobalData*)[GlobalData sharedData]).g_nBadgeNumber == 0];
}

- (void)dealloc
{
    [_backgroundView release];
    [_buttons release];
    [_animatedView release];
    [super dealloc];
}

@end
