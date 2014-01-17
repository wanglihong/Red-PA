//
//  User.m
//  Red-PA
//
//  Created by Dennis Yang on 12-9-5.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize people;
@synthesize just_finished_register;
@synthesize just_finished_login;
@synthesize _refresh_gridview;

static User *_instance = nil;

+ (User *)currentUser {
    
    @synchronized(self){
		if (!_instance){
			_instance = [[User alloc] init];
		}
	}
	
	return _instance;
}

- (BOOL)isLoggedIn
{
    if (self.people)
        return YES;
    else
        return NO;
}

- (void)dealloc
{
    [people release];
    
    [super dealloc];
}

@end
