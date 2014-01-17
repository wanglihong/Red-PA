//
//  Comment.m
//  Red-PA
//
//  Created by Dennis Yang on 12-11-8.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "Comment.h"

@implementation Comment

@synthesize people = _people;

@synthesize date = _date;
@synthesize content = _content;
@synthesize imageId = _imageId;
@synthesize soundId = _soundId;
@synthesize commentId = _commentId;

- (void)set_date:(NSString *)date
{
    if (date != _date) {
        
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'Z";
        NSDate *__date = [formatter dateFromString:[NSString stringWithFormat:@"%@GMT+00:00", date]];
        
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        
        NSString *formattedString = [formatter stringFromDate:__date];
        [formatter release];
        
        [_date release];
        _date = [formattedString retain];
    }
}

- (NSString *)get_content
{
    if (nil != _content && ![@"(null)" isEqual:_content] && ![[NSNull null] isEqual:_content])
        return _content;
    else
        return @"";
}

- (void)dealloc
{
    [_people release];
    
    [_date release];
    [_content release];
    [_imageId release];
    [_soundId release];
    [_commentId release];
    
    [super dealloc];
}

@end
