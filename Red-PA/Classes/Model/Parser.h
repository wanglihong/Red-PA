//
//  Parser.h
//  Red-PA
//
//  Created by Dennis Yang on 12-9-27.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "People.h"

@interface Parser : NSObject

+ (Parser *)sharedParser;

/*
 *--------------------------------------------------------------------------------------
 *
 *方法说明：
 *      解析PA列表
 *方法结果：
 *      返回party对象数组
 *
 *--------------------------------------------------------------------------------------
 */
- (NSMutableArray *)partyFromArray:(NSArray *)arr;


/*
 *--------------------------------------------------------------------------------------
 *
 *方法说明： 
 *      解析PA图秀种的照片
 *方法结果：
 *      返回Image对象数组
 *
 *--------------------------------------------------------------------------------------
 */
- (NSMutableArray *)photoFromArray:(NSArray *)arr;

/*
 *--------------------------------------------------------------------------------------
 *
 *方法说明：
 *      解析PA会员列表中参与的会员
 *方法结果：
 *      返回People对象数组
 *
 *--------------------------------------------------------------------------------------
 */
- (NSMutableArray *)peopleFromArray:(NSArray *)arr;

/*
 *--------------------------------------------------------------------------------------
 *
 *方法说明：
 *      解析登陆用户数据
 *方法结果：
 *      返回People对象
 *
 *--------------------------------------------------------------------------------------
 */
- (People *)peopleFromDictionary:(NSDictionary *)dic;

/*
 *--------------------------------------------------------------------------------------
 *
 *方法说明：
 *      解析用户评论信息
 *方法结果：
 *      返回Comment对象数组
 *
 *--------------------------------------------------------------------------------------
 */
- (NSArray *)commentFromDictionary:(NSDictionary *)dictionary;

/*
 *--------------------------------------------------------------------------------------
 *
 *方法说明：
 *      解析活动列表、用户评论、图秀、会员等数组的长度
 *方法结果：
 *      返回NSInter类型数组长度
 *
 *--------------------------------------------------------------------------------------
 */
- (NSInteger)arrayLength:(NSDictionary *)dictionary;

@end