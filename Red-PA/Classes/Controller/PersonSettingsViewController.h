//
//  PersonSettingsViewController.h
//  Red-PA
//
//  Created by Dennis Yang on 12-9-13.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MenuViewController.h"

#import "WBEngine.h"
#import "WBLogInAlertView.h"

@interface PersonSettingsViewController : MenuViewController <WBEngineDelegate>
{
    WBEngine *engine;
}

@end
