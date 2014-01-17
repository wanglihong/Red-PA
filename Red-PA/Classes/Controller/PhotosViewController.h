//
//  PhotosViewController.h
//  Red-PA
//
//  Created by Dennis Yang on 12-9-6.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MenuViewController.h"

#import "GridView.h"
#import "GridViewItem.h"

@interface PhotosViewController : MenuViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, GridViewDelegate, GridViewDataSource>
{
    GridView            *_gridView;
    Party               *_party;
    
    NSMutableArray      *_photos;
    NSInteger           _totalCount;
    
    BOOL                getPhotoFromCamera;
    BOOL                _refresh_gridview;
}

@property (nonatomic, retain) Party *party;
@property (nonatomic, retain) NSMutableArray *photos;
@property NSInteger totalCount;

@end
