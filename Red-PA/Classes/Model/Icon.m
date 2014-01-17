//
//  Icon.m
//  Red-PA
//
//  Created by Dennis Yang on 12-9-11.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "Icon.h"

@implementation Icon

@synthesize iconId = _iconId;
@synthesize iconType = _iconType;

- (void)dealloc
{
    [_iconId release];
    [_iconType release];
    
    [super dealloc];
}

@end
