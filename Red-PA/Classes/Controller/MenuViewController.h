//
//  MenuViewController.h
//  Red-PA
//
//  Created by Dennis Yang on 12-9-5.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

@interface MenuViewController : BaseViewController <UIScrollViewDelegate>
{
    UIView *_menu;                      // 菜单栏
    
    UIButton *_backButton;              // 返回按钮
    
    UIButton *_homeButton;              // 首页按钮
    
    UILabel *_firstTitleLabel;          // 一级标题
    
    UILabel *_secondTitleLabel;         // 二级标题
    
    IBOutlet UIScrollView *_scrollView; // 内容浏览区域（滚动）
}

@property (nonatomic, assign) UIView *menu;
@property (nonatomic, assign) UIButton *backButton;
@property (nonatomic, assign) UIButton *homeButton;
@property (nonatomic, assign) UILabel *firstTitleLabel;
@property (nonatomic, assign) UILabel *secondTitleLabel;

- (void)back;
- (void)setHomeButtonHidden:(BOOL)hide;

@end
