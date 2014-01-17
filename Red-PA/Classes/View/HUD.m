//
//  HUD.m
//  Red-PA
//
//  Created by Dennis Yang on 12-9-18.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "HUD.h"

#define timeout 30.0

@implementation HUD

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        contentView = [[[UIView alloc] initWithFrame:CGRectMake(55, 220, 210, 50)] autorelease];
        contentView.backgroundColor = [UIColor blackColor];
        
        textLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 50)] autorelease];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.textAlignment = UITextAlignmentCenter;
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.font = [UIFont systemFontOfSize:14.0];
        
        animView = [[[UIImageView alloc] initWithFrame:CGRectMake(130, 17, 15, 15)] autorelease];
        animView.image = [UIImage imageNamed:@"loading_refresh.png"];
        
        lineView = [[[UIImageView alloc] initWithFrame:CGRectMake(160, 0, 1, 50)] autorelease];
        lineView.image = [UIImage imageNamed:@"loading_line.png"];
        
        closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.titleLabel.textColor = [UIColor whiteColor];
        closeButton.frame = CGRectMake(160, 0, 50, 50);
        [closeButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [closeButton setImage:[UIImage imageNamed:@"loading_cancel.png"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        
        stateView = [[[UIImageView alloc] initWithFrame:CGRectMake(175, 17, 15, 15)] autorelease];
        
        [contentView addSubview:textLabel];
        [contentView addSubview:animView];
        [contentView addSubview:lineView];
        [contentView addSubview:closeButton];
        [contentView addSubview:stateView];
        
        [self addSubview:contentView];
    }
    return self;
}

static HUD *_instance = nil;

+ (HUD *)hud {
    
    @synchronized(self){
		if (!_instance){
			_instance = [[HUD alloc] initWithFrame:[UIScreen mainScreen].bounds];
            _instance.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.35];
		}
	}
	
	return _instance;
}

- (void)presentWithText:(NSString *)text
{
    textLabel.text = text;
    [self animationWillStart];
    
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.25];
    
    [[HUD hud] setAlpha:1];
    
    [UIView commitAnimations];
}

- (void)dismiss
{
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop)];
    
    [[HUD hud] setAlpha:0];
    
    [UIView commitAnimations];
}

- (void)cancel
{
    [[RKClient sharedClient].requestQueue cancelAllRequests];
    
    [self dismiss];
}

- (void)animationWillStart
{
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
    
    textLabel.frame = CGRectMake(0, 0, 120, 50);
    animView.alpha = 1;
    lineView.alpha = 1;
    closeButton.alpha = 1;
    stateView.alpha = 0;
    
    [self rotate];
}

- (void)animationDidStop
{
    [self removeFromSuperview];
}

- (void)rotate
{
	CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
	rotationAnimation.duration = 1.0f;
    rotationAnimation.repeatCount = HUGE_VALF;
	rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [animView.layer addAnimation:rotationAnimation forKey:@"rotateAnimation"];
}

- (void)successWithText:(NSString *)text
{
    textLabel.text = text;
    textLabel.frame = CGRectMake(0, 0, 175, 50);
    animView.alpha = 0;
    lineView.alpha = 0;
    closeButton.alpha = 0;
    stateView.alpha = 1;
    stateView.image = [UIImage imageNamed:@"success.png"];
    
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.25];
}

- (void)failWithText:(NSString *)text
{
    textLabel.text = text;
    textLabel.frame = CGRectMake(0, 0, 175, 50);
    animView.alpha = 0;
    lineView.alpha = 0;
    closeButton.alpha = 0;
    stateView.alpha = 1;
    stateView.image = [UIImage imageNamed:@"error.png"];
    
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.25];
}

@end
