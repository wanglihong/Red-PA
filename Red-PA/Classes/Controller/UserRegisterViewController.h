//
//  UserRegisterViewController.h
//  Red-PA
//
//  Created by Dennis Yang on 12-9-5.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MenuViewController.h"

@interface UserRegisterViewController : MenuViewController
{
    IBOutlet UITextField *_mobileField;
    IBOutlet UITextField *_authField;
    IBOutlet UITextField *_passField;
    IBOutlet UITextField *_rePassField;
    IBOutlet UITextField *_nameField;
    
    IBOutlet UIButton *_getVerifyCodeButton;
}

@end
