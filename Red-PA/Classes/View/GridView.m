//
//  GridView.m
//  Red-PA
//
//  Created by Dennis Yang on 12-9-6.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "GridView.h"
#import "Party.h"

@implementation GridView

@synthesize items = _items;
@synthesize tableView = _tableView;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tableView = [ [UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] ;
        self.tableView.delegate = self ;
        self.tableView.dataSource = self ;
        self.tableView.scrollsToTop = NO ;
        self.tableView.clipsToBounds = YES;
        self.tableView.showsVerticalScrollIndicator = NO ;
        self.tableView.showsHorizontalScrollIndicator = NO ;
        self.tableView.backgroundColor = [UIColor clearColor] ;
        self.tableView.contentInset = UIEdgeInsetsMake(30, 0, 10, 0);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin ;
        [self addSubview:self.tableView] ;
        [self.tableView release] ;
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ceil([_delegate numberOfItemsInGridView:self] / 2.0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    GridViewItem *lImg = (GridViewItem *)[cell viewWithTag:101];
    if (!lImg) {
        lImg = [[GridViewItem alloc] initWithFrame:CGRectMake(  0, 5, 108, 108)];
        lImg.delegate = self;
        lImg.tag = 101;
        [cell addSubview:lImg];
        [lImg release];
    }
    
    GridViewItem *rImg = (GridViewItem *)[cell viewWithTag:102];
    if (!rImg && (indexPath.row * 2 + 1) < [_delegate numberOfItemsInGridView:self]) {
        rImg = [[GridViewItem alloc] initWithFrame:CGRectMake(118, 5, 108, 108)];
        rImg.delegate = self;
        rImg.tag = 102;
        [cell addSubview:rImg];
        [rImg release];
    }
    
    if (rImg && (indexPath.row * 2 + 1) >= [_delegate numberOfItemsInGridView:self]) {
        [rImg removeFromSuperview];
        rImg = nil;
    }
    
    // 在下面开始对每个item项设置数据
    
    if (lImg) {
        lImg.index = indexPath.row * 2;
        lImg.titleLabel.text = [_delegate gridView:self titleForItemAtIndex:lImg.index];
        [lImg setImageWithURL:[NSURL URLWithString:[_delegate gridView:self imageForItemAtIndex:lImg.index]]
             placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        BOOL joined = NO;
        if ([_delegate respondsToSelector:@selector(gridView:hasJoinPartyAtIndex:)]) {
            joined = [_delegate gridView:self hasJoinPartyAtIndex:lImg.index];
        }
        lImg.joining.image = joined ? [UIImage imageNamed:@"join.png"] : nil;
        
        if ([_delegate respondsToSelector:@selector(gridView:textAlignmentForTitleAtIndex:)]) {
            lImg.titleLabel.textAlignment = [_delegate gridView:self textAlignmentForTitleAtIndex:lImg.index];
        }
        
        if ([_delegate respondsToSelector:@selector(gridView:supportImageHiddenAtIndex:)]) {
            lImg.support.hidden = [_delegate gridView:self supportImageHiddenAtIndex:lImg.index];
        }
        
        if ([_delegate respondsToSelector:@selector(gridView:supportCountAtIndex:)]) {
            lImg.supportCount.text = [_delegate gridView:self supportCountAtIndex:lImg.index];
        }
        
        if ([_delegate respondsToSelector:@selector(gridView:titleWidthForItemAtIndex:)]) {
            [lImg setTitleWidth:[_delegate gridView:self titleWidthForItemAtIndex:lImg.index]];
        }
    }
    
    if (rImg) {
        rImg.index = indexPath.row * 2 + 1;
        rImg.titleLabel.text = [_delegate gridView:self titleForItemAtIndex:rImg.index];
        [rImg setImageWithURL:[NSURL URLWithString:[_delegate gridView:self imageForItemAtIndex:rImg.index]]
             placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        BOOL joined = NO;
        if ([_delegate respondsToSelector:@selector(gridView:hasJoinPartyAtIndex:)]) {
            joined = [_delegate gridView:self hasJoinPartyAtIndex:rImg.index];
        }
        rImg.joining.image = joined ? [UIImage imageNamed:@"join.png"] : nil;
        
        if ([_delegate respondsToSelector:@selector(gridView:textAlignmentForTitleAtIndex:)]) {
            rImg.titleLabel.textAlignment = [_delegate gridView:self textAlignmentForTitleAtIndex:rImg.index];
        }
        
        if ([_delegate respondsToSelector:@selector(gridView:supportImageHiddenAtIndex:)]) {
            rImg.support.hidden = [_delegate gridView:self supportImageHiddenAtIndex:rImg.index];
        }
        
        if ([_delegate respondsToSelector:@selector(gridView:supportCountAtIndex:)]) {
            rImg.supportCount.text = [_delegate gridView:self supportCountAtIndex:rImg.index];
        }
        
        if ([_delegate respondsToSelector:@selector(gridView:titleWidthForItemAtIndex:)]) {
            [rImg setTitleWidth:[_delegate gridView:self titleWidthForItemAtIndex:lImg.index]];
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 118.0f;
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([_delegate respondsToSelector:@selector(gridViewDidScroll:)]) {
        [_delegate gridViewDidScroll:scrollView];
    }
}

#pragma mark - GridViewItem delegate

- (void)gridViewItem:(GridViewItem *)gridViewItem didSelectedItemAtIndex:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(gridview:didSelectItem:atIndex:)]) {
        [_delegate gridview:self didSelectItem:gridViewItem atIndex:index];
    }
}

- (void)dealloc
{
    [_items release];
    [_tableView release];
    
    [super dealloc];
}

@end
