//
//  CommentCell.m
//  Red-PA
//
//  Created by Dennis Yang on 12-11-12.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

@synthesize headerView;
@synthesize nameLabel;
@synthesize commentView;
@synthesize dateLabel;
@synthesize recorderButton;
@synthesize sigline;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
