//
//  GridView.h
//  Red-PA
//
//  Created by Dennis Yang on 12-9-6.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GridViewItem.h"

#import "UIImageView+WebCache.h"

@class GridView;

@protocol GridViewDelegate <NSObject>

@optional
- (void)gridViewDidScroll:(UIScrollView *)scrollView;
- (void)gridView:(GridView *)gridView didSelectedItemAtIndex:(NSInteger)index;
- (void)gridview:(GridView *)gridView didSelectItem:(GridViewItem *)gridViewItem atIndex:(NSInteger)index;

@end

@protocol GridViewDataSource <NSObject>

@required
- (NSInteger )numberOfItemsInGridView:(GridView *)gridView;
- (NSString *)gridView:(GridView *)gridView titleForItemAtIndex:(NSInteger)index;
- (NSString *)gridView:(GridView *)gridView imageForItemAtIndex:(NSInteger)index;

@optional
- (BOOL      )gridView:(GridView *)gridView hasJoinPartyAtIndex:(NSInteger)index;

- (BOOL      )gridView:(GridView *)gridView supportImageHiddenAtIndex:(NSInteger)index;
- (NSString *)gridView:(GridView *)gridView supportCountAtIndex:(NSInteger)index;
- (UITextAlignment)gridView:(GridView *)gridView textAlignmentForTitleAtIndex:(NSInteger)index;
- (float     )gridView:(GridView *)gridView titleWidthForItemAtIndex:(NSInteger)index;

@end

@interface GridView : UIView <UITableViewDelegate, UITableViewDataSource, GridViewItemDelegate>
{
    UITableView *_tableView;
    
    NSArray *_items;
    
    id _delegate;
}

@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, assign) id delegate;

@end
