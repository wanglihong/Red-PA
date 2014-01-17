//
//  CommentCell.h
//  Red-PA
//
//  Created by Dennis Yang on 12-11-12.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UIImageView *headerView;
@property (nonatomic, assign) IBOutlet UILabel *nameLabel;
@property (nonatomic, assign) IBOutlet UITextView *commentView;
@property (nonatomic, assign) IBOutlet UILabel *dateLabel;
@property (nonatomic, assign) IBOutlet UIButton *recorderButton;
@property (nonatomic, assign) IBOutlet UILabel *sigline;

@end
