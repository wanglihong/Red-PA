//
//  HandlePhotosViewController.h
//  Red-PA
//
//  Created by Dennis Yang on 12-9-24.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "HandleImageViewController.h"

@interface HandlePhotosViewController :HandleImageViewController <AVAudioPlayerDelegate>
{
    IBOutlet UIView *_informationView;      // 头像、名字、时间的容器
    IBOutlet UIImageView *_header;          // 作者头像
    IBOutlet UILabel *_nameLabel;           // 作者名字
    IBOutlet UILabel *_dateLabel;           // 上传时间
    IBOutlet UILabel *_suppLabel;           // "赞"次数
    IBOutlet UITableView *_menuView;        // 菜单
    
    AVAudioPlayer *audioPlayer;             //音频播放器
    NSMutableArray *_pages;
    NSArray *_photos;
    
    BOOL _rotating;
    BOOL _dragging;
    int  _pageIndex;
    int  _lastPageIndex;
}

@property (nonatomic, retain) NSArray *photos;
@property (nonatomic, retain) NSMutableArray *pages;
@property int pageIndex;
@property BOOL informationHidden;

- (IBAction)toggleMenu:(id)sender;

@end
