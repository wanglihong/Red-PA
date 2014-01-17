//
//  GuideView.m
//  Red-PA
//
//  Created by Dennis Yang on 12-10-23.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "GuideView.h"

@implementation GuideView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self performSelector:@selector(cancelHighLight) withObject:nil afterDelay:0.2];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self performSelector:@selector(cancelHighLight) withObject:nil afterDelay:0.2];
}

- (void)cancelHighLight
{
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDidStopSelector:@selector(removeHighLight)];
    
    [self setAlpha:0];
    
    [UIView commitAnimations];
}

- (void)removeHighLight
{
    [self removeFromSuperview];
}

@end
