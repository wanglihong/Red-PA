//
//  CommentViewController.m
//  Red-PA
//
//  Created by Dennis Yang on 12-11-8.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "CommentViewController.h"

#import "Comment.h"

#import "CommentCell.h"

@interface CommentViewController ()

@end

@implementation CommentViewController

@synthesize image = _image;
@synthesize soundData;
@synthesize commentData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _comments = [NSMutableArray new];
    }
    return self;
}

// 点击屏幕事件处理
- (void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    if ([_contentView isFirstResponder]) {
        [_contentView resignFirstResponder];
        //[_scrollView setContentOffset:__beginPoint animated:YES];
    }
}

- (void)playSound:(id)sender
{
    UIButton *soundButton = (UIButton *)sender;
    soundButton.selected = !soundButton.selected;
    Comment *comment = [_comments objectAtIndex:soundButton.tag - 1000];
    
    if (comment.soundId) {
        
        NSString *filePath = [NSString stringWithFormat:@"%@/%@%@", docPath, comment.soundId, @".mp3"];//[docPath  stringByAppendingPathComponent:comment.soundId];
        NSLog(@"____________本地音频文件路径：%@", filePath);
        NSData *voiceData = [NSData dataWithContentsOfFile:filePath];
        
        if (!voiceData) {
            NSString *voiceURL = [NSString stringWithFormat:@"%@/gridfs/%@", BASE_URL_STRING, comment.soundId];
            NSLog(@"____________音频文件地址：%@", voiceURL);
            voiceData = [NSData dataWithContentsOfURL:[NSURL URLWithString:voiceURL]];
            NSLog(@"____________音频文件长度：%d", voiceData.length);
            [voiceData writeToFile:filePath atomically:YES];
        }
        
        NSError *error;
        if (audioPlayer != nil) {
            if ([audioPlayer isPlaying]) {
                [audioPlayer stop];
            }
            [audioPlayer release];
            audioPlayer = nil;
        }
        
        lastPlayButton.selected = NO;
        if (lastPlayButton == soundButton) {
            lastPlayButton = nil;
            return;
        }
        
        audioPlayer = [[AVAudioPlayer alloc] initWithData:voiceData error:&error];
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
        [audioPlayer setDelegate:self];
        [audioPlayer play];
        
        soundButton.selected = YES;
        lastPlayButton = soundButton;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _firstTitleLabel.text = @"评论";
    _firstTitleLabel.frame = CGRectMake(0, -63, _scrollView.frame.size.width, 37);
    
    // “录音” 控件
    recoder = [[SoundRecorder alloc] initWithFrame:self.view.frame];
    recoder.delegate = self;
    
    [_scrollView setContentInset:UIEdgeInsetsMake(100, 0, 60, 0)];
    
    [self requestComments];
}

- (void)requestComments
{
    NSString *requestPath;
    requestPath = [NSString stringWithFormat:@"/photo/%@/comment?offset=%d&limit=%d", _image.imageId, 0, _page_size];
    [[RKClient sharedClient] get:requestPath delegate:self];
    [[HUD hud] presentWithText:@"获取评论..."];
}

- (void)prepareSendComment:(NSString *)text
{
    if ([[User currentUser] isLoggedIn] == NO) {
        [User currentUser].just_finished_login = YES;
        [self login];
        return;
    }
    
    if (([text isEqual:@""] || text.length == 0) && hasRecorderFile == NO) {
        //[Tools alertWithTitle:@"请输入文字或语音评论！"];
        [Tools alertWithTitle:@"请输入评论内容！"];
        return;
    }
    
    if (hasRecorderFile) {
        [[HUD hud] presentWithText:@"处理文件..."];
        [recoder transformFile];
        /*
        NSString *__wavFilePath = [NSString stringWithFormat:@"%@/%@", docPath, @"record.caf"];
        NSString *__amrFilePath = [NSString stringWithFormat:@"%@/%@", docPath, @"record.amr"];
        EncodeWAVEFileToAMRFile([__wavFilePath cStringUsingEncoding:NSASCIIStringEncoding], [__amrFilePath cStringUsingEncoding:NSASCIIStringEncoding], 1, 16);*/
    } else {
        [self doSendComment:nil];
    }
    
    hasRecorderFile = NO;
}

- (void)doSendComment:(NSString *)text
{
    RKParams *params = [RKParams params];
    [params setData:[commentData dataUsingEncoding:NSUTF8StringEncoding] forParam:@"comment"];
    if (soundData) {
        [params setData:soundData MIMEType:@"audio/mpeg" forParam:@"voice"];
    }
    NSString *requestPath;
    requestPath = [NSString stringWithFormat:@"/photo/%@/comment", _image.imageId];
    [[RKClient sharedClient] post:requestPath params:params delegate:self];
    [[HUD hud] presentWithText:@"发表评论..."];
}

#pragma mark - RKObjectLoaderDelegate

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{
    [super request:request didLoadResponse:response];
    
    RKJSONParserJSONKit *parser = [[[RKJSONParserJSONKit alloc] init] autorelease];
    NSDictionary *dic = [parser objectFromString:[response bodyAsString] error:nil];
    int success = [[dic objectForKey:@"success"] intValue];
    
    if ([request isGET]) {
        
        [[HUD hud] dismiss];
        
        NSArray *comments = [[Parser sharedParser] commentFromDictionary:dic];
        if (_comments.count == __commentsCount) {
            [_comments removeAllObjects];
        }
        [_comments addObjectsFromArray:comments];
        __commentsCount = [[Parser sharedParser] arrayLength:dic];
        [(UITableView *)_scrollView reloadData];
    }
    
    else if ([request isPOST]) {
        
        if (success == 1) {
            [[HUD hud] successWithText:@"发表成功"];
            [soundData release];
            soundData = nil;
            [commentData release];
            commentData = nil;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"update" object:nil];
            
            [self requestComments];
        }
    }
}

#pragma mark - TableView dataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return [_comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        static NSString *CellIdentifier = @"Cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        CommentWriter *writer = (CommentWriter *)[cell viewWithTag:4];
        if (!writer) {
            writer = [[CommentWriter alloc] initWithFrame:CGRectMake(0, 10, tableView.bounds.size.width, 210)];
            writer.delegate = self;
            writer.tag = 4;
            [cell addSubview:writer];
            [writer release];
        }
        
        return cell;
        
    } else {
        
        static NSString *CellIdentifier = @"Cell2";
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        CommentWriter *writer = (CommentWriter *)[cell viewWithTag:4];
        if (writer) {
            [writer removeFromSuperview];
        }
        
        Comment *comment = [_comments objectAtIndex:indexPath.row];
        
        UIFont *font = [UIFont systemFontOfSize:16.0];
        CGSize size = [comment.content sizeWithFont:font
                                  constrainedToSize:CGSizeMake(177.0f, 1000.0f)
                                      lineBreakMode:UILineBreakModeWordWrap];
        
        NSString *imgURL = [NSString stringWithFormat:@"%@/gridfs/%@", BASE_URL_STRING, comment.people.peopleHeaderURL];
        [cell.headerView setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        cell.nameLabel.text = comment.people.peopleNickName;
        
        cell.commentView.frame = CGRectMake(49, 0, 160, size.height + 5);
        cell.commentView.text = comment.content;
        
        [cell.recorderButton setImage:[UIImage imageNamed:@"bt_play.png"] forState:UIControlStateNormal];
        [cell.recorderButton setImage:[UIImage imageNamed:@"bt_stop.png"] forState:UIControlStateHighlighted];
        [cell.recorderButton setImage:[UIImage imageNamed:@"bt_stop.png"] forState:UIControlStateSelected];
        [cell.recorderButton addTarget:self action:@selector(playSound:) forControlEvents:UIControlEventTouchUpInside];
        cell.recorderButton.hidden = !comment.soundId;
        cell.recorderButton.tag = 1000 + indexPath.row;
        
        cell.dateLabel.frame = CGRectMake(49, cell.frame.size.height - 15, 177, 15);
        cell.dateLabel.text = comment.date;
        
        cell.sigline.frame = CGRectMake(0, cell.frame.size.height - 1, 226, 1);
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 210;
    }
    
    Comment *comment = [_comments objectAtIndex:indexPath.row];
	UIFont *font = [UIFont systemFontOfSize:16];
    CGSize size = [comment.content sizeWithFont:font
                                    constrainedToSize:CGSizeMake(160.0f, 1000.0f)
                                        lineBreakMode:UILineBreakModeWordWrap];
    NSLog(@"size (%f, %f)", size.width, size.height);
    return 80.0 + ( size.height > 44 ? size.height - 60 : 0 );
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_comments.count < __commentsCount) {
        
        if (scrollView.contentOffset.y + scrollView.frame.size.height - 60 == scrollView.contentSize.height) {
            
            NSString *requestPath;
            requestPath = [NSString stringWithFormat:@"/photo/%@/comment?offset=%d&limit=%d", _image.imageId, _comments.count, _page_size];
            [[RKClient sharedClient] get:requestPath delegate:self];
            [[HUD hud] presentWithText:@"获取评论..."];
        }
    }
}

#pragma mark - AudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag
{
    [player stop];
    [player release];
    audioPlayer = nil;
    
    lastPlayButton.selected = NO;
    lastPlayButton = nil;
}

#pragma mark - CommentWriterDelegate

- (void)commentWriter:(CommentWriter *)writer beginWrite:(UITextView *)textView
{
    __beginPoint = _scrollView.contentOffset;
    _contentView = textView;
    //[_scrollView setContentOffset:CGPointMake(0, _scrollView.contentSize.height - writer.frame.size.height - 160) animated:YES];
}

- (void)commentWriter:(CommentWriter *)writer finishWrite:(UITextView *)textView
{
    //[_scrollView setContentOffset:__beginPoint animated:YES];
}

- (void)startRecord
{
    [self.view addSubview:recoder];
    [recoder startRecord];
}

- (void)stopRecord
{
    [recoder removeFromSuperview];
    [recoder stopRecord];
}

- (void)sendComment:(NSString *)text
{
    self.commentData = text;
    [self prepareSendComment:text];
}

#pragma mark - SoundRecorderDelegate

- (void)soundRecordDidFinishWithFile:(NSString *)filePath
{/*
    NSLog(@"sound file path: %@", filePath);
    
    self.soundData = [NSData dataWithContentsOfFile:filePath];
    
    NSAssert(self.soundData, @"file not exist!");
  */
    
    hasRecorderFile = YES;
}

- (void)transformFinishedWithFile:(NSString *)filePath
{
    NSLog(@"sound file path: %@", filePath);
    
    self.soundData = [NSData dataWithContentsOfFile:filePath];
    
    NSAssert(self.soundData, @"file not exist!");
    
    [self doSendComment:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [_comments release];
    [_image release];
    if (audioPlayer != nil) {
        if ([audioPlayer isPlaying]) {
            [audioPlayer stop];
        }
        [audioPlayer release];
        audioPlayer = nil;
    }
    if (soundData) {
        [soundData release];
    }
    [recoder release];
    if (commentData) {
        [commentData release];
    }
    
    [super dealloc];
}

@end
