//
//  People.m
//  Red-PA
//
//  Created by Dennis Yang on 12-9-5.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "People.h"

@implementation People

@synthesize peopleId;
@synthesize peopleRealName;
@synthesize peopleNickName;
@synthesize peopleGender;
@synthesize peopleAge;
@synthesize peopleHeaderURL;
@synthesize peopleQQ;
@synthesize peopleEmail;
@synthesize peopleMobilePhone;
@synthesize peopleUniversity;
@synthesize peopleDepartment;
@synthesize peopleInformation;
@synthesize peopleEnterDate;
@synthesize peopleJoinedParties;

- (void)setQQNumber:(NSString *)qq
{
    [peopleQQ release];
    if ([qq intValue] == 0)
        peopleQQ = [@"" retain];
    else
        peopleQQ = [[NSString stringWithFormat:@"%@", qq] retain];
}

- (NSString *)get_university
{
    if (nil != peopleUniversity || [@"(null)" isEqual:peopleUniversity])
        return peopleUniversity;
    else
        return @"";
}

- (NSString *)get_department
{
    if (nil != peopleDepartment || [@"(null)" isEqual:peopleDepartment])
        return peopleDepartment;
    else
        return @"";
}

- (NSString *)get_qq
{
    if (nil != peopleQQ && ![@"(null)" isEqual:peopleQQ])
        return peopleQQ;
    else
        return @"";
}

- (NSString *)get_information
{
    if (nil != peopleInformation && ![@"(null)" isEqual:peopleInformation] && ![[NSNull null] isEqual:peopleInformation])
        return peopleInformation;
    else
        return @"";
}

- (void)dealloc
{
    [peopleId release];
    [peopleRealName release];
    [peopleNickName release];
    [peopleGender release];
    [peopleAge release];
    [peopleHeaderURL release];
    [peopleQQ release];
    [peopleEmail release];
    [peopleMobilePhone release];
    [peopleUniversity release];
    [peopleDepartment release];
    [peopleInformation release];
    [peopleEnterDate release];
    [peopleJoinedParties release];
    
    [super dealloc];
}

@end
