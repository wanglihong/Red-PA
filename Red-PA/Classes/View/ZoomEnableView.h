//
//  ZoomEnableView.h
//  Red-PA
//
//  Created by Dennis Yang on 12-11-27.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZoomEnableView : UIScrollView<UIScrollViewDelegate> {
    UIImageView *imageView;
}

@property (nonatomic, retain) UIImageView *imageView;

@end
