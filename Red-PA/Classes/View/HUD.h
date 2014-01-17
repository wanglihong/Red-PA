//
//  HUD.h
//  Red-PA
//
//  Created by Dennis Yang on 12-9-18.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface HUD : UIView
{
    UIView *contentView;
    UILabel *textLabel;
    UIImageView *animView;
    UIImageView *lineView;
    UIButton *closeButton;
    UIImageView *stateView;
}

+ (HUD *)hud;

- (void)dismiss;

- (void)presentWithText:(NSString *)text;

- (void)successWithText:(NSString *)text;

- (void)failWithText:(NSString *)text;

@end
