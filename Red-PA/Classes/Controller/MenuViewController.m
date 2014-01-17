//
//  MenuViewController.m
//  Red-PA
//
//  Created by Dennis Yang on 12-9-5.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "MenuViewController.h"

#define MENU_WIDTH 65.0
#define CONTENT_WIDTH 226.0
#define DOUBLE_STATUS_BUTTON_TAG 100

@interface MenuViewController ()

@end

@implementation MenuViewController

@synthesize menu = _menu;
@synthesize backButton = _backButton;
@synthesize homeButton = _homeButton;
@synthesize firstTitleLabel = _firstTitleLabel;
@synthesize secondTitleLabel = _secondTitleLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    int count = 0;
    
    for (UIButton *b in self.menu.subviews) {
        
        if ([b isKindOfClass:[UIButton class]]) {
            
            if (count == 0) {
                b.frame = CGRectMake(0, 20, 60, 60);
            }
            else {
                b.frame = CGRectMake(0, self.menu.bounds.size.height - 60 * count - 20, 60, 60);
            }
            
            [b setBackgroundImage:[UIImage imageNamed:@"selected_button_bg.png"] forState:UIControlStateHighlighted];
            
            count ++;
        }
    }
    
    for (UIButton *b in _scrollView.subviews) {
    
        if ([b isKindOfClass:[UIButton class]] && b.tag == DOUBLE_STATUS_BUTTON_TAG) {
            
            [b setBackgroundImage:[UIImage imageNamed:@"button_normal.png"] forState:UIControlStateNormal];
            [b setBackgroundImage:[UIImage imageNamed:@"button_selected.png"] forState:UIControlStateHighlighted];
            [b setBackgroundImage:[UIImage imageNamed:@"button_selected.png"] forState:UIControlStateSelected];
            b.layer.borderWidth = 1.0;
            b.layer.borderColor = milky_white.CGColor;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化 －－ 菜单栏
    _menu = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - MENU_WIDTH, 0, MENU_WIDTH,
                                                         self.view.bounds.size.height)];
    _menu.backgroundColor = [UIColor clearColor];
    _menu.alpha = 0;
    [self.view addSubview:self.menu];
    
    // 初始化 －－ 返回按钮
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [_backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateHighlighted];
    [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.menu addSubview:_backButton];
    
    // 初始化 －－ 首页按钮
    _homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_homeButton setImage:[UIImage imageNamed:@"home.png"] forState:UIControlStateNormal];
    [_homeButton setImage:[UIImage imageNamed:@"home.png"] forState:UIControlStateHighlighted];
    [_homeButton addTarget:self action:@selector(home) forControlEvents:UIControlEventTouchUpInside];
    [self.menu addSubview:_homeButton];
    
    // 初始化 －－ 一级标题
    self.firstTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 37, CONTENT_WIDTH, 37)];
    _firstTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:40.0];
    _firstTitleLabel.backgroundColor = [UIColor clearColor];
    _firstTitleLabel.textColor = title_color;
    
    // 初始化 －－ 二级标题
    _secondTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 84, CONTENT_WIDTH, 50)];
    _secondTitleLabel.font = [UIFont systemFontOfSize:14.0];
    _secondTitleLabel.backgroundColor = [UIColor clearColor];
    _secondTitleLabel.textColor = milky_white;
    _secondTitleLabel.lineBreakMode = UILineBreakModeWordWrap;
    _secondTitleLabel.numberOfLines = 2;
    
    // 初始化 －－ 内容浏览区域
    if (_scrollView) {
        [_scrollView addSubview:_firstTitleLabel];
        [_scrollView addSubview:_secondTitleLabel];
        _scrollView.contentSize = CGSizeMake(226.0, 481.0);
        _scrollView.delegate = self;
    }
    
    // 屏幕点击事件的识别
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    [tapGr release];
}

- (void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    for (UIView *view in _scrollView.subviews) {
        [view resignFirstResponder];
    }
}

// 返回上一页
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 返回首页
- (void)home
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    
    self.menu.alpha = 1;
    
    [UIView commitAnimations];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    
    self.menu.alpha = 0;
    
    [UIView commitAnimations];
}

- (void)setHomeButtonHidden:(BOOL)hide
{
    _homeButton.alpha = hide == YES ? 0 : 1;
    _menu.frame = CGRectMake(self.view.bounds.size.width - MENU_WIDTH, 0, MENU_WIDTH, 100);
}

#pragma makr - UITextField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.layer.borderColor = milky_white.CGColor;
    textField.layer.borderWidth = 1.0;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.layer.borderColor = [UIColor clearColor].CGColor;
    textField.layer.borderWidth = 0.0;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma makr - UITextView delegate

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [_menu release];
    [_firstTitleLabel release];
    [_secondTitleLabel release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
