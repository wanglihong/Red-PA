//
//  UpdatePersonInfoViewController.h
//  Red-PA
//
//  Created by Dennis Yang on 12-9-13.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MenuViewController.h"

@interface UpdatePersonInfoViewController : MenuViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
{
    IBOutlet UIImageView *_header;
    IBOutlet UIButton *_boy;
    IBOutlet UIButton *_girl;
    
    IBOutlet UITextField *_nickNameField;
    IBOutlet UITextField *_realNameField;
    IBOutlet UITextField *_collegeField;
    IBOutlet UITextField *_departmentField;
    IBOutlet UITextField *_qqNumberField;
    IBOutlet UITextField *_emailField;
    IBOutlet UITextView  *_informationField;
    
    NSString *_gender;
    
    BOOL getPhotoFromCamera;
}

@end
