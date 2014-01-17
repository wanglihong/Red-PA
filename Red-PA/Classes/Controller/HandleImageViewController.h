//
//  HandleImageViewController.h
//  Red-PA
//
//  Created by Dennis Yang on 12-9-24.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "MenuViewController.h"

#import "WXApi.h"

#import "WBEngine.h"
#import "WBLogInAlertView.h"

#import "Party.h"

@interface HandleImageViewController : MenuViewController   <UIActionSheetDelegate,
                                                            MFMailComposeViewControllerDelegate,
                                                            MFMessageComposeViewControllerDelegate,
                                                            WBEngineDelegate, WXApiDelegate>
{
    UIButton    *_shareButton;      //分享按钮
    
    UIImage     *_image;            //图片源
    Party       *_party;            //当前PA
    WBEngine    *weiBoEngine;       //微博引擎
}

@property (nonatomic, retain) UIImage   *image;
@property (nonatomic, retain) Party     *party;

- (void)share;

@end
