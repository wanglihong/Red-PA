//
//  ChangePasswordViewController.h
//  Red-PA
//
//  Created by Dennis Yang on 12-9-19.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MenuViewController.h"

@interface ChangePasswordViewController : MenuViewController
{
    IBOutlet UITextField *_oldPassField;
    IBOutlet UITextField *_newPassField;
    IBOutlet UITextField *_conPassField;
}

@end
