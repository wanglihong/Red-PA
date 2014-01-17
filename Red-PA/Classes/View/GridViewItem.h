//
//  GridViewItem.h
//  Red-PA
//
//  Created by Dennis Yang on 12-9-6.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GridViewItem;

@protocol GridViewItemDelegate <NSObject>

- (void)gridViewItem:(GridViewItem *)gridViewItem didSelectedItemAtIndex:(NSInteger)index;

@end

@interface GridViewItem : UIImageView
{
    id<GridViewItemDelegate> _delegate;
    
    NSInteger _index;
    
    UILabel *_titleLabel;
    
    UIImageView *_joining;
    
    UIImageView *_support;
    
    UILabel *_supportCount;
}

@property (nonatomic, assign) id<GridViewItemDelegate> delegate;
@property (nonatomic, assign) UILabel *titleLabel;
@property (nonatomic, assign) UILabel *supportCount;
@property (nonatomic, assign) UIImageView *joining;
@property (nonatomic, assign) UIImageView *support;
@property NSInteger index;

- (void)setTitleWidth:(float)width;

@end
