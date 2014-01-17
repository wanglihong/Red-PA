//
//  Comment.h
//  Red-PA
//
//  Created by Dennis Yang on 12-11-8.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "People.h"

@interface Comment : NSObject
{
    People *_people;
    
    NSString *_date;
    NSString *_content;
    NSString *_imageId;
    NSString *_soundId;
    NSString *_commentId;
}

@property (nonatomic, retain) People *people;

@property (nonatomic, retain, setter = set_date:) NSString *date;
@property (nonatomic, retain, getter = get_content) NSString *content;
@property (nonatomic, retain) NSString *imageId;
@property (nonatomic, retain) NSString *soundId;
@property (nonatomic, retain) NSString *commentId;

- (void)set_date:(NSString *)date;
- (NSString *)get_content;

@end
