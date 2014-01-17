//
//  HomeViewController.h
//  Red-PA
//
//  Created by Dennis Yang on 12-9-4.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"
#import "LoadingViewController.h"

#import "Party.h"
#import "GridView.h"
#import "GridViewItem.h"

@interface HomeViewController : BaseViewController <GridViewDelegate, GridViewDataSource>
{
    Party *_selectedParty;
    GridView *_gridView;
    LoadingViewController *_loadingViewController;
    UIImageView *_logo;
    UIButton *_settingsButton;
    UIButton *_userActionButton;
    
    NSMutableArray *_parties;
    NSInteger _totalParties;
}

@property (nonatomic, assign) GridView *gridView;
@property (nonatomic, retain) NSMutableArray *parties;

@end
