//
//  HandlePhotosViewController.m
//  Red-PA
//
//  Created by Dennis Yang on 12-9-24.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "HandlePhotosViewController.h"
#import "CommentViewController.h"
#import "ZoomEnableView.h"

@interface HandlePhotosViewController ()

@end

@implementation HandlePhotosViewController

@synthesize photos = _photos;
@synthesize pages = _pages;
@synthesize pageIndex = _pageIndex;
@synthesize informationHidden;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setHomeButtonHidden:YES];
    
    // 隐藏图片信息
    if (informationHidden == YES) {
        [self setInformationHidden];
    }
    
    // 第一张图片
    [self setUpScrollViewContent];
    [self setupScrollViewContentSize];
    [self moveToPageAtIndex:_pageIndex animated:NO];
}

// 隐藏图片信息
- (void)setInformationHidden
{
    _informationView.hidden = YES;
    _suppLabel.hidden = YES;
}

// 切换菜单
- (IBAction)toggleMenu:(id)sender
{
    CGRect frame = _menuView.frame;
    float variableHeight = ( frame.origin.y == self.view.bounds.size.height ? -132.0 : 132.0 ) ;
    CGRect newFrame = CGRectMake(0, frame.origin.y + variableHeight, frame.size.width, frame.size.height);
    
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.25];
    
    _menuView.frame = newFrame;
    
    [UIView commitAnimations];
}

// 点击屏幕事件处理
- (void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    if (_menuView.frame.origin.y < self.view.bounds.size.height) {
         [self toggleMenu:nil];
    }
}

// 切换图片时刷新信息
- (void)updateInfoAtIndex:(NSInteger)index
{
    Image *__image = [self.photos objectAtIndex:index];
    super.image = ((UIImageView *)[self.pages objectAtIndex:index]).image;
    
    NSString *imgURL = [NSString stringWithFormat:@"%@/gridfs/%@", BASE_URL_STRING, __image.people.peopleHeaderURL];
    [_header setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [_nameLabel setText:__image.people.peopleNickName];
    [_dateLabel setText:__image.imageDate];
    [_suppLabel setText:[NSString stringWithFormat:@"此图片已被 %d 人赞过哦", __image.supportCount]];
    
    [_menuView reloadData];
    
    if (index != _lastPageIndex) {
        if (audioPlayer != nil) {
            if ([audioPlayer isPlaying]) {
                [audioPlayer stop];
            }
            [audioPlayer release];
            audioPlayer = nil;
        }
    }
    _lastPageIndex = index;
}

// 播放录音
- (void)playSound
{
    Image *__image = [self.photos objectAtIndex:_pageIndex];
    
    if (__image.imageVoice) {
        /*
        NSString *voiceURL = [NSString stringWithFormat:@"%@/gridfs/%@", BASE_URL_STRING, __image.imageVoice];
        NSData *voiceData = [NSData dataWithContentsOfURL:[NSURL URLWithString:voiceURL]];
        */
        NSString *filePath = [NSString stringWithFormat:@"%@/%@%@", docPath, __image.imageVoice, @".mp3"];//[docPath  stringByAppendingPathComponent:comment.soundId];
        NSLog(@"____________本地音频文件路径：%@", filePath);
        NSData *voiceData = [NSData dataWithContentsOfFile:filePath];
        
        if (!voiceData) {
            NSString *voiceURL = [NSString stringWithFormat:@"%@/gridfs/%@", BASE_URL_STRING, __image.imageVoice];
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
        audioPlayer= [[AVAudioPlayer alloc] initWithData:voiceData error:&error];
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
        [audioPlayer setDelegate:self];
        [audioPlayer play];
    }
}

// 赞一下该图片
- (void)addSupport
{
    if ([[User currentUser] isLoggedIn] == NO) {
        [User currentUser].just_finished_login = YES;
        [self login];
        return;
    }
    
    Image *__image = [self.photos objectAtIndex:_pageIndex];
    if (__image.hasSupported < 1) {
        [[RKClient sharedClient] get:[NSString stringWithFormat:@"/photo/%@/good", __image.imageId] delegate:self];
        [[HUD hud] presentWithText:@"正在提交..."];
    }
}

- (void)handleSupport
{
    [[HUD hud] successWithText:@"提交成功"];
    
    Image *__image = [self.photos objectAtIndex:_pageIndex];
    __image.supportCount += 1;
    [self updateInfoAtIndex:_pageIndex];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([User currentUser].just_finished_login == YES)
    {
        [[HUD hud] presentWithText:@"Loading..."];
        NSString *path = [NSString stringWithFormat:@"/party/%@/photo?offset=0&limit=%d",
                          _party.partyId, self.photos.count];
        [[RKClient sharedClient] get:path delegate:self];
        
        [User currentUser].just_finished_login = NO;
    }
}

- (void)handleResult:(NSObject *)obj lastPathComponent:(NSString *)path
{
    if ([path isEqualToString:@"photo"]) {
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
            [[HUD hud] dismiss];
            
            NSMutableArray *photos = [[Parser sharedParser] photoFromArray:[(NSDictionary *)obj objectForKey:@"data"]];
            
            self.photos = photos;
            
            // 通知前一个页面的数据与当前页面同步
            [[NSNotificationCenter defaultCenter] postNotificationName:@"just_finished_login" object:self.photos];
            
            // 更新当前页面数据
            [self moveToPageAtIndex:_pageIndex animated:NO];
        }
    }
    
    else if ([path isEqualToString:@"good"]) {
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
            Image *__image = [self.photos objectAtIndex:_pageIndex];
            __image.hasSupported = 1;
            
            // 通知前一个页面的数据与当前页面同步
            [[NSNotificationCenter defaultCenter] postNotificationName:@"just_finished_login" object:self.photos];
            
            [self handleSupport];
        }
    }
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{
    [super request:request didLoadResponse:response];
    
    RKJSONParserJSONKit *parser = [[[RKJSONParserJSONKit alloc] init] autorelease];
    NSDictionary *dic = [parser objectFromString:[response bodyAsString] error:nil];
    
    int success = [[dic objectForKey:@"success"] intValue];
    
    if ([request isGET]) {
        if ([response isOK]) {
            
            if (success == 1)
                [self handleResult:dic lastPathComponent:request.URL.lastPathComponent];
            else {
                //[[HUD hud] failWithText:[dic objectForKey:@"msg"]];
                [[HUD hud] dismiss];
                [Tools alertWithTitle:[dic objectForKey:@"msg"]];
            }
        }
    }
}

/*
 *--------------------------------------------------------------------------------------
 *
 * start:  滑动浏览照片
 *
 *--------------------------------------------------------------------------------------
 */
- (void)setUpScrollViewContent
{
    NSMutableArray *pages = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [self.photos count]; i++) {
        [pages addObject:[NSNull null]];
    }
    self.pages = pages;
    [pages release];
}

- (void)setupScrollViewContentSize
{
	CGSize contentSize = CGSizeMake(_scrollView.bounds.size.width, _scrollView.bounds.size.height);//self.view.bounds.size;
	contentSize.width = (contentSize.width * [self.pages count]);
    contentSize.height = _scrollView.bounds.size.height;//self.view.bounds.size.height;
	
	if (!CGSizeEqualToSize(contentSize, _scrollView.contentSize)) {
		_scrollView.contentSize = contentSize;
	}
}

- (void)enqueuePageViewAtIndex:(int)theIndex
{
    for (int i = 0; i < [self.pages count]; i++)
    {
        UIImageView *view = [self.pages objectAtIndex:i];
        if((NSNull *)view != [NSNull null])
        {
            if(i < theIndex-1 || i > theIndex+1)
            {
                [view removeFromSuperview];
                [self.pages replaceObjectAtIndex:i withObject:[NSNull null]];
            }
        }
    }
}

- (int )centerPageIndex
{
    CGFloat pageWidth = _scrollView.frame.size.width;
	return floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

- (void)loadScrollViewWithPage:(int)page
{
#define PAGE_GAP 25
    if (page < 0) return;
    if (page >= [self.pages count]) return;
    
    UIImageView *view = (UIImageView *)[self.pages objectAtIndex:page];
    
    if ((NSNull*)view == [NSNull null]) {
		
        Image *img = [self.photos objectAtIndex:page];
        NSString *imgURL = [NSString stringWithFormat:@"%@/gridfs/%@", BASE_URL_STRING, img.imageId];
        
        view = [[UIImageView alloc] initWithFrame:[_scrollView frame]];
        view.contentMode = UIViewContentModeScaleAspectFit;
        view.clipsToBounds = YES;
        [view setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:nil];
		[self.pages replaceObjectAtIndex:page withObject:view];
        [view release];
	}
	
    if (nil == view.superview) {
        [_scrollView addSubview:view];
    }
    
    CGRect frame = _scrollView.frame;
	NSInteger centerPageIndex = _pageIndex;
	CGFloat xOrigin = (frame.size.width * page);
	if (page > centerPageIndex) {
		xOrigin = (frame.size.width * page) + PAGE_GAP;
	} else if (page < centerPageIndex) {
		xOrigin = (frame.size.width * page) - PAGE_GAP;
	}
	
	frame.origin.x = xOrigin;
	frame.origin.y = 0;
	view.frame = frame;
}

- (void)moveToPageAtIndex:(NSInteger)index animated:(BOOL)animated
{
	_pageIndex = index;
    
	[self enqueuePageViewAtIndex:index];
	
	[self loadScrollViewWithPage:index-1];
	[self loadScrollViewWithPage:index];
	[self loadScrollViewWithPage:index+1];
	
	
	[_scrollView scrollRectToVisible:((UIImageView *)[self.pages objectAtIndex:index]).frame animated:animated];
    [self updateInfoAtIndex:index];
}

- (void)layoutScrollViewSubviews
{
	NSInteger index = [self centerPageIndex];
	
	for (NSInteger page = index-1; page < index+1; page++) {
		
		if (page >= 0 && page < [self.pages count]){
			
			CGFloat originX = _scrollView.bounds.size.width * page;
			
			if (page < index) {
				originX -= PAGE_GAP;
			}
			if (page > index) {
				originX += PAGE_GAP;
			}
			
			if ([self.pages objectAtIndex:page] == [NSNull null] || !((UIImageView *)[self.pages objectAtIndex:page]).superview){
				[self loadScrollViewWithPage:page];
			}
			
			UIImageView *view = (UIImageView *)[self.pages objectAtIndex:page];
			CGRect newframe = CGRectMake(originX, 0.0f, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
			
			if (!CGRectEqualToRect(view.frame, newframe)) {
				
				[UIView beginAnimations:nil context:NULL];
				[UIView setAnimationDuration:0.1];
				view.frame = newframe;
				[UIView commitAnimations];
                
			}
			
		}
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView != _scrollView) {
        return;
    }
    
    NSInteger index = [self centerPageIndex];
	if (index >= [self.pages count] || index < 0) {
		return;
	}
    
    if (_pageIndex != index && !_rotating) {
        
		_pageIndex = index;
		
		if (![_scrollView isTracking]) {
			[self layoutScrollViewSubviews];
		}
		
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView != _scrollView) {
        return;
    }
    
    if (_rotating) {
        return;
    }
    
	int index = [self centerPageIndex];
	if (index >= [self.pages count] || index < 0) {
		return;
	}
	
	[self moveToPageAtIndex:index animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _dragging = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _dragging = NO;
}

/*
 *--------------------------------------------------------------------------------------
 *
 * end__:  滑动浏览照片
 *
 *--------------------------------------------------------------------------------------
 */

/*
 *--------------------------------------------------------------------------------------
 *
 * start:  菜单
 *
 *--------------------------------------------------------------------------------------
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.textColor = milky_white;
    cell.textLabel.font = [UIFont systemFontOfSize:18.0];
    cell.contentView.backgroundColor = old_red;
    
    UIView *selectionView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
    selectionView.backgroundColor = background_red;
    cell.selectedBackgroundView = selectionView;
    
    Image *__image = [self.photos objectAtIndex:_pageIndex];
    
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"分享          ";
            cell.textLabel.textAlignment = UITextAlignmentRight;
            UIImageView *icon = (UIImageView *)[cell viewWithTag:6];
            if (!icon) {
                icon = [[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width - 55, 11, 23, 23)];
                icon.tag = 6;
                [cell addSubview:icon];
                [icon release];
            }
            icon.image = [UIImage imageNamed:@"icon_share.png"];
        }
            break;
        /*
        case 1:
        {
            cell.textLabel.text = @"播放录音          ";
            cell.textLabel.textAlignment = UITextAlignmentRight;
            UIImageView *icon = (UIImageView *)[cell viewWithTag:7];
            if (!icon) {
                icon = [[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width - 55, 11, 23, 23)];
                icon.tag = 7;
                [cell addSubview:icon];
                [icon release];
            }
            if (__image.imageVoice) {
                cell.textLabel.textColor = milky_white;
            } else {
                cell.textLabel.textColor = [UIColor darkGrayColor];
            }
            icon.image = [UIImage imageNamed:@"icon_recorder.png"];
        }
            break;
        */    
        case 1:
        {
            Image *__image = [self.photos objectAtIndex:_pageIndex];
            if (__image.hasSupported < 1) {
                cell.textLabel.text = [NSString stringWithFormat:@"赞一下(%d)          ", __image.supportCount];
                cell.textLabel.textColor = milky_white;
            } else {
                cell.textLabel.text = [NSString stringWithFormat:@"已赞(%d)          ", __image.supportCount];
                cell.textLabel.textColor = [UIColor darkGrayColor];
            }
            cell.textLabel.textAlignment = UITextAlignmentRight;
            UIImageView *icon = (UIImageView *)[cell viewWithTag:8];
            if (!icon) {
                icon = [[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width - 55, 11, 23, 23)];
                icon.tag = 8;
                [cell addSubview:icon];
                [icon release];
            }
            icon.image = [UIImage imageNamed:@"icon_support.png"];
        }
            break;
            
        case 2:
        {
            cell.textLabel.text = [NSString stringWithFormat:@"评论(%d)          ", __image.commentCount];
            cell.textLabel.textAlignment = UITextAlignmentRight;
            UIImageView *icon = (UIImageView *)[cell viewWithTag:9];
            if (!icon) {
                icon = [[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width - 55, 11, 23, 23)];
                icon.tag = 9;
                [cell addSubview:icon];
                [icon release];
            }
            icon.image = [UIImage imageNamed:@"icon_comment.png"];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Image *__image = [self.photos objectAtIndex:_pageIndex];
    
    switch (indexPath.row) {
        case 0:
        {
            [self share];
        }
            break;
            
        case 1:
        {
            //[self playSound];
            [self addSupport];
        }
            break;
            
        case 2:
        {
            //[self addSupport];
            CommentViewController *con;
            con = [[[CommentViewController alloc] initWithNibName:@"CommentViewController"
                                                           bundle:nil] autorelease];
            con.image = __image;
            [self.navigationController pushViewController:con animated:YES];
        }
            break;
            
        case 3:
        {/*
            CommentViewController *con;
            con = [[[CommentViewController alloc] initWithNibName:@"CommentViewController"
                                                           bundle:nil] autorelease];
            con.image = __image;
            [self.navigationController pushViewController:con animated:YES];*/
        }
            break;
            
        default:
            break;
    }
}

/*
 *--------------------------------------------------------------------------------------
 *
 * end__:  菜单
 *
 *--------------------------------------------------------------------------------------
 */

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [_photos release];
    [_pages release];
    if (audioPlayer != nil) {
        if ([audioPlayer isPlaying]) {
            [audioPlayer stop];
        }
        [audioPlayer release];
        audioPlayer = nil;
    }
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - AudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag
{
    [player stop];
    [player release];
    audioPlayer = nil;
}

@end
