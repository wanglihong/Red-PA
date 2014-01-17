//
//  CommentViewController.h
//  Red-PA
//
//  Created by Dennis Yang on 12-11-8.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MenuViewController.h"
#import "CommentWriter.h"
#import "SoundRecorder.h"

@interface CommentViewController : MenuViewController <AVAudioPlayerDelegate, CommentWriterDelegate, SoundRecorderDelegate>
{
    //IBOutlet UITableView *_tableView;
    UITextView *_contentView;
    CGPoint __beginPoint;
    
    NSMutableArray *_comments;
    NSInteger __commentsCount;
    
    Image *_image;
    
    SoundRecorder *recoder;         //录音控件
    NSData *soundData;              //录音文件
    AVAudioPlayer *audioPlayer;     //音频播放器
    UIButton *lastPlayButton;
    
    BOOL hasRecorderFile;
}

@property (nonatomic, retain) Image *image;
@property (nonatomic, retain) NSData *soundData;
@property (nonatomic, retain) NSString *commentData;

@end
