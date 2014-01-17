//
//  People.h
//  Red-PA
//
//  Created by Dennis Yang on 12-9-5.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface People : NSObject
{
    NSString *peopleId;             //标识
    NSString *peopleRealName;       //真名
    NSString *peopleNickName;       //昵称
    NSString *peopleGender;         //性别
    NSString *peopleAge;            //年龄
    NSString *peopleHeaderURL;      //头像
    NSString *peopleQQ;             //QQ
    NSString *peopleEmail;          //邮箱
    NSString *peopleMobilePhone;    //手机
    NSString *peopleUniversity;     //大学
    NSString *peopleDepartment;     //学系
    NSString *peopleInformation;    //简介
    NSString *peopleEnterDate;      //参加日期
    NSArray  *peopleJoinedParties;  //已参加的PA
}

@property (nonatomic, retain) NSString *peopleId;
@property (nonatomic, retain) NSString *peopleRealName;
@property (nonatomic, retain) NSString *peopleNickName;
@property (nonatomic, retain) NSString *peopleGender;
@property (nonatomic, retain) NSString *peopleAge;
@property (nonatomic, retain) NSString *peopleHeaderURL;
@property (nonatomic, retain, setter = setQQNumber:, getter = getqq) NSString *peopleQQ;
@property (nonatomic, retain) NSString *peopleEmail;
@property (nonatomic, retain) NSString *peopleMobilePhone;
@property (nonatomic, retain, getter = get_university) NSString *peopleUniversity;
@property (nonatomic, retain, getter = get_department) NSString *peopleDepartment;
@property (nonatomic, retain, getter = get_information) NSString *peopleInformation;
@property (nonatomic, retain) NSString *peopleEnterDate;
@property (nonatomic, retain) NSArray  *peopleJoinedParties;

- (void)setQQNumber:(NSString *)qq;

- (NSString *)get_university;
- (NSString *)get_department;
- (NSString *)get_qq;
- (NSString *)get_information;

@end
