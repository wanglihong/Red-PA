//
//  Party.h
//  Red-PA
//
//  Created by Dennis Yang on 12-9-5.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Icon.h"
#import "Image.h"
#import "People.h"

@interface Party : NSObject
{
    NSString *partyId;          //红PA id
    NSString *partyName;        //红PA名称
    NSString *partyTitle;       //红PA标题
    NSString *partyDate;        //红PA举办日期
    NSString *partyPlace;       //红PA举办地点
    NSString *partyIntroduce;   //红PA介绍
    NSString *partyTheme;       //红PA主题图片地址
    NSString *partyIconId;      //红PA主题图片 id
    NSArray  *partyPrevious;    //红PA预告图片地址［数组］
    NSInteger partyJoined;      //是否已参与
    
    Icon     *icon;             //红PA icon
    People   *sponsor;          //举办人
    NSArray  *images;           //红PA 图片集
    NSDictionary *entrepreneur;
}

@property (nonatomic, retain) NSString *partyId;
@property (nonatomic, retain) NSString *partyName;
@property (nonatomic, retain) NSString *partyTitle;
@property (nonatomic, retain) NSString *partyDate;
@property (nonatomic, retain) NSString *partyPlace;
//@property (nonatomic, retain) NSString *partySponsor;
@property (nonatomic, retain) NSString *partyIntroduce;
@property (nonatomic, retain) NSString *partyTheme;
@property (nonatomic, retain) NSString *partyIconId;
@property (nonatomic, retain) NSArray  *partyPrevious;
@property (nonatomic) NSInteger partyJoined;
@property (nonatomic, retain) Icon     *icon;
@property (nonatomic, retain) People   *sponsor;
@property (nonatomic, retain) NSArray  *images;
@property (nonatomic, retain, setter = set_Entrepreneur:) NSDictionary *entrepreneur;

- (void)set_Entrepreneur:(NSDictionary *)_entrepreneur;

@end
