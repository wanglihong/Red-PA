//
//  PADetailViewController.h
//  Red-PA
//
//  Created by Dennis Yang on 12-9-5.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MenuViewController.h"

#import "GridViewItem.h"

@interface PADetailViewController : MenuViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, GridViewItemDelegate>
{
    IBOutlet UIImageView *_bigHeader;
    IBOutlet UILabel *_dateLabel;
    IBOutlet UILabel *_timeLabel;
    IBOutlet UILabel *_addrLabel;
    IBOutlet UITextView *_description;
    IBOutlet UIButton *_joinButton;
    IBOutlet UILabel *_masterLabel;
    IBOutlet UIImageView *_masterIcon;
    
    Party *_party;
    
    BOOL getPhotoFromCamera;
    BOOL _refresh_party_info;
}

@property (nonatomic, retain) Party *party;

@end
