//
//  Image.m
//  Red-PA
//
//  Created by Dennis Yang on 12-9-11.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "Image.h"

@implementation Image

@synthesize imageId = _imageId;
@synthesize imageType = _imageType;
@synthesize imageDate = _imageDate;
@synthesize imageVoice = _imageVoice;
@synthesize supportCount = _supportCount;
@synthesize hasSupported = _hasSupported;
@synthesize commentCount = _commentCount;
@synthesize metadata = _metadata;
@synthesize people = _people;

- (void)set_metadata:(NSDictionary *)metadata
{
    if (metadata != _metadata) {
        [_metadata release];
        _metadata = [metadata retain];
        self.people = [[[People alloc] init] autorelease];
        self.people.peopleId = [[metadata objectForKey:@"user"] objectForKey:@"id"];
        self.people.peopleNickName = [[metadata objectForKey:@"user"] objectForKey:@"name"];
        self.people.peopleHeaderURL = [[metadata objectForKey:@"user"] objectForKey:@"icon"];
        self.supportCount = [[metadata objectForKey:@"good"] intValue];
        self.imageVoice = [metadata objectForKey:@"voice"];
        self.commentCount = [[metadata objectForKey:@"comment"] intValue];
    }
}

- (void)set_imageDate:(NSString *)imageDate
{
    if (imageDate != _imageDate) {
        
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'Z";
        NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@GMT+00:00", imageDate]];
        
        //[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        
        NSString *formattedString = [formatter stringFromDate:date];
        [formatter release];
        
        [_imageDate release];
        _imageDate = [formattedString retain];
    }
}

- (void)dealloc
{
    [_imageId release];
    [_imageType release];
    [_imageVoice release];
    [_imageDate release];
    [_metadata release];
    [_people release];
    
    [super dealloc];
}

@end
