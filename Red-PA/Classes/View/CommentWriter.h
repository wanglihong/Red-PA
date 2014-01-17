//
//  CommentWriter.h
//  Red-PA
//
//  Created by Dennis Yang on 12-11-8.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentWriter;

@protocol CommentWriterDelegate <NSObject>

- (void)commentWriter:(CommentWriter *)writer beginWrite:(UITextView *)textView;
- (void)commentWriter:(CommentWriter *)writer finishWrite:(UITextView *)textView;
- (void)startRecord;
- (void)stopRecord;
- (void)sendComment:(NSString *)text;

@end

@interface CommentWriter : UIView <UITextViewDelegate>
{
    UITextView *_contentView;
    UIButton *recorder;
    UILabel *_recorderState;
    
    id<CommentWriterDelegate> _delegate;
}

@property (nonatomic, retain) UITextView *contentView;
@property (nonatomic, assign) id<CommentWriterDelegate> delegate;

@end
