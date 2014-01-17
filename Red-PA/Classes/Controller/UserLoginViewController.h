//
//  UserLoginViewController.h
//  Red-PA
//
//  Created by Dennis Yang on 12-9-5.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MenuViewController.h"

@interface UserLoginViewController : MenuViewController
{
    IBOutlet UITextField *_mobileField;
    IBOutlet UITextField *_passField;
    IBOutlet UIButton *_loginBt;
    IBOutlet UIButton *_registerBt;
}

@end
