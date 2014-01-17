//
//  Tools.m
//  Red-PA
//
//  Created by Dennis Yang on 12-9-11.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "Tools.h"

@implementation Tools

+ (NSDate *)dateFromString:(NSString *)dateString
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'Z";
    
    return [formatter dateFromString:[NSString stringWithFormat:@"%@GMT+00:00", dateString]];
}

+ (NSString *)dateWithDate:(NSString *)dateString
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    
    formatter.dateFormat = @"yyyy-MM-dd";
    
    return [formatter stringFromDate:[Tools dateFromString:dateString]];
}

+ (NSString *)timeWithDate:(NSString *)dateString
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    
    formatter.dateFormat = @"HH:mm";
    
    return [formatter stringFromDate:[Tools dateFromString:dateString]];
}

+ (NSString *)dateStringWithDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    return [formatter stringFromDate:date];
}

+ (void)fadeIn:(UIView *)view duration:(float)duration
{
    view.alpha = 0.0;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    
    view.alpha = 1.0;
    
    [UIView commitAnimations];
}

+ (void)alertWithTitle:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:title delegate:nil
                                          cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

@end
