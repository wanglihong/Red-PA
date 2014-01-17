//
//  BaseViewController.h
//  Red-PA
//
//  Created by Dennis Yang on 12-9-5.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import <RestKit/RKJSONParserJSONKit.h>
#import <QuartzCore/QuartzCore.h>

#import "UIImageView+WebCache.h"

#import "HUD.h"
#import "Tools.h"
#import "User.h"
#import "Party.h"
#import "People.h"
#import "Parser.h"

@interface BaseViewController : UIViewController <RKObjectLoaderDelegate>
{
    UIImageView *_backgroundImageView;
}

@property (nonatomic, assign) UIImageView *backgroundImageView;

- (void)login;

@end
