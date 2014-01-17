//
//  Auth.m
//  Red-PA
//
//  Created by Dennis Yang on 12-9-12.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "Auth.h"

@implementation Auth

@synthesize code;

- (void)dealloc
{
    [code release];
    
    [super dealloc];
}

@end
