//
//  PersonInfoViewController.h
//  Red-PA
//
//  Created by Dennis Yang on 12-9-10.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MenuViewController.h"

#import "People.h"

@interface PersonInfoViewController : MenuViewController
{
    IBOutlet UIImageView *_header;
    IBOutlet UILabel *_nameLabel;
    IBOutlet UILabel *_univLabel;
    IBOutlet UILabel *_depaLabel;
    IBOutlet UILabel *_qqLabel;
    IBOutlet UILabel *_emailLabel;
    IBOutlet UILabel *_dateLabel;
    IBOutlet UITextView *_infoLabel;
    IBOutlet UIView  *_infoBg;
    
    IBOutlet UIButton *_updateButton;
    
    People *_people;
    BOOL CAN_UPDATE;
}

@property (nonatomic, retain) People *people;
@property BOOL CAN_UPDATE;

@end
