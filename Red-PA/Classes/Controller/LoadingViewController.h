//
//  LoadingViewController.h
//  Red-PA
//
//  Created by Dennis Yang on 12-9-7.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

@interface LoadingViewController : BaseViewController
{
    UIImageView *_bg;
    UILabel *_prompt;
    UIActivityIndicatorView *_activity;
    RKReachabilityObserver *_observer;
    
    NSArray *_parties;
}

@property (nonatomic, retain) NSArray *parties;

@end
