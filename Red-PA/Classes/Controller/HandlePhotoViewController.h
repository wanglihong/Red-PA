//
//  HandlePhotoViewController.h
//  Red-PA
//
//  Created by Dennis Yang on 12-9-6.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HandleImageViewController.h"
#import "SoundRecorder.h"
//#import "GTMBase64.h"

@interface HandlePhotoViewController : HandleImageViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, SoundRecorderDelegate>
{
    IBOutlet UIImageView *_imageView;       // 大图
    IBOutlet UIButton *_reShootButton;      // 重拍
    
    UIButton    *_recordButton;     //录音按钮
    UIButton    *_uploadButton;     //上传按钮
    
    
    SoundRecorder *recoder;         //录音控件
    NSData *soundData;              //录音文件
    
    
    BOOL getPhotoFromCamera;
    BOOL hasRecorderFile;
}

@property (nonatomic) BOOL getPhotoFromCamera;
@property (nonatomic, retain) NSData *soundData;

@end
