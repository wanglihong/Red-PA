//
//  Icon.h
//  Red-PA
//
//  Created by Dennis Yang on 12-9-11.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Icon : NSObject
{
    NSString *_iconId;
    NSString *_iconType;
}

@property (nonatomic, retain) NSString *iconId;
@property (nonatomic, retain) NSString *iconType;

@end
