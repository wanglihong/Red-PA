//
//  User.h
//  Red-PA
//
//  Created by Dennis Yang on 12-9-5.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "People.h"

@interface User : NSObject
{
    People *people;
    BOOL just_finished_register;
    BOOL just_finished_login;
    BOOL _refresh_gridview;
}

@property (nonatomic, retain) People *people;
@property (nonatomic) BOOL just_finished_register;
@property (nonatomic) BOOL just_finished_login;
@property (nonatomic) BOOL _refresh_gridview;

+ (User *)currentUser;

- (BOOL)isLoggedIn;

@end
