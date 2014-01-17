//
//  Image.h
//  Red-PA
//
//  Created by Dennis Yang on 12-9-11.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "People.h"

@interface Image : NSObject
{
    NSString *_imageId;         // 图片id
    NSString *_imageType;       // 图片类型(image/png image/jpg)
    NSString *_imageDate;       // 图片上传日期
    NSString *_imageVoice;      // 图片声音
    NSInteger _supportCount;    // 赞（次数）
    NSInteger _hasSupported;    // (是否:1\0)已赞过
    NSInteger _commentCount;    // 评论数量
    NSDictionary *_metadata;    // 包含上传作者、图片尺寸、partyId信息的字典
    
    People *_people;
}

@property (nonatomic, retain) NSString *imageId;
@property (nonatomic, retain) NSString *imageType;
@property (nonatomic, retain) NSString *imageVoice;
@property (nonatomic, retain, setter = set_imageDate:) NSString *imageDate;
@property (nonatomic, retain, setter = set_metadata:) NSDictionary *metadata;
@property NSInteger supportCount;
@property NSInteger hasSupported;
@property NSInteger commentCount;

@property (nonatomic, retain) People *people;

- (void)set_metadata:(NSDictionary *)metadata;
- (void)set_imageDate:(NSString *)imageDate;

@end
