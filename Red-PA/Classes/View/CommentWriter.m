//
//  CommentWriter.m
//  Red-PA
//
//  Created by Dennis Yang on 12-11-8.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "CommentWriter.h"

@implementation CommentWriter

@synthesize contentView = _contentView;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 15)];
        titLab.text = @"发表评论：";
        titLab.backgroundColor = [UIColor clearColor];
        titLab.textColor = milky_white;
        titLab.font = [UIFont systemFontOfSize:16.0];
        [self addSubview:titLab];
        [titLab release];
        
        _recorderState = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 15)];
        _recorderState.text = @"";
        _recorderState.textAlignment = UITextAlignmentRight;
        _recorderState.backgroundColor = [UIColor clearColor];
        _recorderState.textColor = milky_white;
        _recorderState.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_recorderState];
        [_recorderState release];
        
        _contentView = [[UITextView alloc] initWithFrame:CGRectMake(0, 20, frame.size.width, 100)];
        _contentView.backgroundColor = [UIColor colorWithRed:197.0/255.0 green:025.0/255.0 blue:037.0/255.0 alpha:1.0];
        _contentView.textColor = [UIColor whiteColor];
        _contentView.delegate = self;
        [self addSubview:_contentView];
        [_contentView release];
        
        
        recorder = [UIButton buttonWithType:UIButtonTypeCustom];
        [recorder setFrame:CGRectMake(0, 140, frame.size.width, 37)];
        [recorder setBackgroundImage:[UIImage imageNamed:@"button_normal.png"] forState:UIControlStateNormal];
        [recorder setBackgroundImage:[UIImage imageNamed:@"button_selected.png"] forState:UIControlStateHighlighted];
        [recorder setBackgroundImage:[UIImage imageNamed:@"button_selected.png"] forState:UIControlStateSelected];
        [recorder setTitle:@"按住录音" forState:UIControlStateNormal];
        [recorder setTitle:@"松开停止录音" forState:UIControlStateHighlighted];
        [recorder setTitleColor:background_red forState:UIControlStateNormal];
        [recorder setTitleColor:milky_white forState:UIControlStateHighlighted];
        recorder.layer.borderWidth = 1.0;
        recorder.layer.borderColor = milky_white.CGColor;
        [recorder addTarget:self action:@selector(startRecord:) forControlEvents:UIControlEventTouchDown];
        [recorder addTarget:self action:@selector(endRecord:) forControlEvents:UIControlEventTouchUpInside];
        [recorder addTarget:self action:@selector(endRecord:) forControlEvents:UIControlEventTouchUpOutside];
        [self addSubview:recorder];
        [recorder setHidden:YES];
        
        
        UIButton *sendComment = [UIButton buttonWithType:UIButtonTypeCustom];
        //[sendComment setFrame:CGRectMake(0, 189, frame.size.width, 37)];
        [sendComment setFrame:CGRectMake(0, 140, frame.size.width, 37)];
        [sendComment setBackgroundImage:[UIImage imageNamed:@"button_normal.png"] forState:UIControlStateNormal];
        [sendComment setBackgroundImage:[UIImage imageNamed:@"button_selected.png"] forState:UIControlStateHighlighted];
        [sendComment setBackgroundImage:[UIImage imageNamed:@"button_selected.png"] forState:UIControlStateSelected];
        [sendComment setTitle:@"发送评论" forState:UIControlStateNormal];
        [sendComment setTitleColor:background_red forState:UIControlStateNormal];
        [sendComment setTitleColor:milky_white forState:UIControlStateHighlighted];
        sendComment.layer.borderWidth = 1.0;
        sendComment.layer.borderColor = milky_white.CGColor;
        [sendComment addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendComment];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:@"update" object:nil];
    }
    return self;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([_delegate respondsToSelector:@selector(commentWriter:beginWrite:)]) {
        [_delegate commentWriter:self beginWrite:textView];
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([_delegate respondsToSelector:@selector(commentWriter:finishWrite:)]) {
        [_delegate commentWriter:self finishWrite:textView];
    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{/*
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        if ([_delegate respondsToSelector:@selector(commentWriter:finishWrite:)]) {
            [_delegate commentWriter:self finishWrite:textView];
        }
    }
    */
    return YES;
}

- (void)startRecord:(id)sender
{
    _recorderState.text = @"[正在录音]";
    
    UIButton *b = (UIButton *)sender;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, b.frame.size.height)];
    v.tag = 100;
    v.backgroundColor = background_red;
    [b addSubview:v];
    [b bringSubviewToFront:b.titleLabel];
    [v release];
    
    [UIView beginAnimations:@"grow" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:15.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endRecord:)];
    
    v.frame = b.bounds;
    
    [UIView commitAnimations];
    
    if ([_delegate respondsToSelector:@selector(startRecord)]) {
        [_delegate startRecord];
    }
}

- (void)endRecord:(id)sender
{
    _recorderState.text = @"[已完成录音]";
    
    UIView *v = [recorder viewWithTag:100];
    if (v) {
        [v removeFromSuperview];
    }
    
    if ([_delegate respondsToSelector:@selector(stopRecord)]) {
        [_delegate stopRecord];
    }
}

- (void)sendComment
{
    if ([_delegate respondsToSelector:@selector(sendComment:)]) {
        [_delegate sendComment:_contentView.text];
    }
}

- (void)update
{
    _contentView.text = @"";
    _recorderState.text = @"";
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
