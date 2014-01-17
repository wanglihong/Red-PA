//
//  MembersViewController.h
//  Red-PA
//
//  Created by Dennis Yang on 12-9-6.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MenuViewController.h"

#import "GridView.h"
#import "GridViewItem.h"

@interface MembersViewController : MenuViewController <GridViewDelegate, GridViewDataSource>
{
    GridView            *_gridView;
    
    Party               *_party;
    
    NSMutableArray      *_members;
    NSInteger           _totalCount;
}

@property (nonatomic, retain) Party *party;
@property (nonatomic, retain) NSMutableArray *members;
@property NSInteger totalCount;

@end
