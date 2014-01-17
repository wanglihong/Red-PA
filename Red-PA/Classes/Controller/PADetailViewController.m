//
//  PADetailViewController.m
//  Red-PA
//
//  Created by Dennis Yang on 12-9-5.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "PADetailViewController.h"

#import "MembersViewController.h"

#import "PhotosViewController.h"

#import "HandlePhotoViewController.h"

#import "PersonInfoViewController.h"

#import "HandlePhotosViewController.h"

#import "GuideView.h"

#import "Image.h"
#import "Icon.h"

#import "Parser.h"

@interface PADetailViewController ()

@end

@implementation PADetailViewController

@synthesize party = _party;

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
    
    _firstTitleLabel.text = @"活动资料";
	_secondTitleLabel.text= _party.partyName;
    _refresh_party_info = YES;
    
    
    UIButton *b2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [b2 setImage:[UIImage imageNamed:@"person_normal.png"] forState:UIControlStateNormal];
    [b2 setImage:[UIImage imageNamed:@"person_normal.png"] forState:UIControlStateHighlighted];
    [b2 addTarget:self action:@selector(person) forControlEvents:UIControlEventTouchUpInside];
    [self.menu addSubview:b2];
    
    UIButton *b4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [b4 setImage:[UIImage imageNamed:@"scene_normal.png"] forState:UIControlStateNormal];
    [b4 setImage:[UIImage imageNamed:@"scene_normal.png"] forState:UIControlStateHighlighted];
    [b4 addTarget:self action:@selector(allPhotos) forControlEvents:UIControlEventTouchUpInside];
    [self.menu addSubview:b4];
    
    UIButton *b5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [b5 setImage:[UIImage imageNamed:@"friend_normal.png"] forState:UIControlStateNormal];
    [b5 setImage:[UIImage imageNamed:@"friend_normal.png"] forState:UIControlStateHighlighted];
    [b5 addTarget:self action:@selector(allMembers) forControlEvents:UIControlEventTouchUpInside];
    [self.menu addSubview:b5];
    
    UIButton *b3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [b3 setImage:[UIImage imageNamed:@"camera_normal.png"] forState:UIControlStateNormal];
    [b3 setImage:[UIImage imageNamed:@"camera_normal.png"] forState:UIControlStateHighlighted];
    [b3 addTarget:self action:@selector(camera) forControlEvents:UIControlEventTouchUpInside];
    [self.menu addSubview:b3];
    
    NSString *homeFirst = [[NSUserDefaults standardUserDefaults] objectForKey:@"detlFirst"];
    if (homeFirst == nil)
    {
        GuideView *guide = [[[GuideView alloc] initWithFrame:self.view.bounds] autorelease];
        if (iPhone5) {
            guide.image = [UIImage imageNamed:@"guide_detl-568h@2x.png"];
        } else {
            guide.image = [UIImage imageNamed:@"guide_detl.png"];
        }
        [self.view addSubview:guide];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"detlFirst"];
    }
    
    
    [self performSelector:@selector(setIcon) withObject:nil afterDelay:0.5];
    [self performSelector:@selector(setImg ) withObject:nil afterDelay:0.5];
    [self performSelector:@selector(setText) withObject:nil afterDelay:0.0];
}

- (void)setIcon
{
    NSString *iconURL = [NSString stringWithFormat:@"%@/gridfs/%@", BASE_URL_STRING, self.party.partyIconId];
    
    UIImageView *img = [[[UIImageView alloc] init] autorelease];
    img.contentMode = UIViewContentModeScaleAspectFill;
    img.clipsToBounds = YES;
    img.frame = CGRectMake(0, 140, 108, 108);
    [_scrollView addSubview:img];
    
    [img setImageWithURL:[NSURL URLWithString:iconURL]];
    [Tools fadeIn:img duration:0.5];
}

- (void)setImg
{
    for (int i = 0 ; i < self.party.partyPrevious.count ; i ++) {
        
        GridViewItem *img = [[[GridViewItem alloc] init] autorelease];
        img.frame = CGRectMake(79 * i, 352, 71, 71);
        img.delegate = self;
        img.index = i;
        [_scrollView addSubview:img];
        
        Image *image = (Image *)[self.party.partyPrevious objectAtIndex:i];
        image.people = self.party.sponsor;
        NSString *imgURL = [NSString stringWithFormat:@"%@/gridfs/%@", BASE_URL_STRING, image.imageId];
        [img setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        [Tools fadeIn:img duration:0.5];
    }
    
    NSString *iconURL = [NSString stringWithFormat:@"%@/gridfs/%@", BASE_URL_STRING, self.party.sponsor.peopleHeaderURL];
    [_masterIcon setImageWithURL:[NSURL URLWithString:iconURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
}

- (void)setText
{
    _dateLabel.text = [Tools dateWithDate:self.party.partyDate];
    _timeLabel.text = [Tools timeWithDate:self.party.partyDate];
    _addrLabel.text = self.party.partyPlace;
    _description.text = self.party.partyIntroduce;
    _masterLabel.text = self.party.sponsor.peopleNickName;
    
    [self setContentSize];
}

- (void)setContentSize
{
    float height = _description.contentSize.height > 112.0 ? _description.contentSize.height : 112.0;
    _description.frame = CGRectMake(0.0, 467.0, 226.0, height);
    
    _scrollView.contentSize = CGSizeMake(226.0, 485.0 + height);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateJoinedStatus];
    
    // 更新当前party信息
    if ([User currentUser]._refresh_gridview && _refresh_party_info)
    {
        [[RKClient sharedClient] get:[NSString stringWithFormat:@"/party/%@", self.party.partyId] delegate:self];
        [[HUD hud] presentWithText:@"正在加载..."];
    }
}

- (void)updateJoinedStatus
{
    if (self.party.partyJoined == 1) {
        [_joinButton setTitle:@"已参与" forState:UIControlStateNormal];
        _joinButton.selected = YES;
        _joinButton.userInteractionEnabled = NO;
        _joinButton.layer.borderWidth = 0;
    }
    
    NSComparisonResult result = [(NSDate *)[NSDate date] compare:[Tools dateFromString:self.party.partyDate]];
    if (result == NSOrderedDescending) {
        [_joinButton setTitle:@"已结束" forState:UIControlStateNormal];
        _joinButton.selected = YES;
        _joinButton.userInteractionEnabled = NO;
        _joinButton.layer.borderWidth = 0;
    }
}

- (IBAction)showPersonInformation:(People *)p
{
    PersonInfoViewController *viewController;
    viewController = [[PersonInfoViewController alloc] initWithNibName:@"PersonInfoViewController"
                                                                bundle:nil];
    viewController.people = self.party.sponsor;
    
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

#pragma mark - GridViewItem delegate

- (void)gridViewItem:(GridViewItem *)gridViewItem didSelectedItemAtIndex:(NSInteger)index
{
    HandlePhotosViewController *viewController = [[HandlePhotosViewController alloc] initWithNibName:@"HandlePhotosViewController" bundle:nil];
    viewController.pageIndex = index;
    viewController.party = self.party;
    viewController.photos = self.party.partyPrevious;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)handleResult:(NSObject *)obj lastPathComponent:(NSString *)path
{
    if      ([path isEqualToString:@"user"]) {
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
            [[HUD hud] dismiss];
            
            NSMutableArray *peoples = [[Parser sharedParser] peopleFromArray:[(NSDictionary *)obj objectForKey:@"data"]];
            
            MembersViewController *viewController = [[MembersViewController alloc] init];
            viewController.members = peoples;
            viewController.party = self.party;
            viewController.totalCount = [[(NSDictionary *)obj objectForKey:@"total"] intValue];
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
        }
    }
    
    else if ([path isEqualToString:@"photo"]) {
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
            [[HUD hud] dismiss];
            
            NSMutableArray *photos = [[Parser sharedParser] photoFromArray:[(NSDictionary *)obj objectForKey:@"data"]];
            
            PhotosViewController *viewController = [[PhotosViewController alloc] init];
            viewController.photos = photos;
            viewController.party = self.party;
            viewController.totalCount = [[(NSDictionary *)obj objectForKey:@"total"] intValue];
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
        }
    }
    
    else if ([path isEqualToString:@"join"]) {
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
            [[HUD hud] successWithText:@"报名成功！"];
            
            [User currentUser]._refresh_gridview = YES;
            
            self.party.partyJoined = 1;
            [self updateJoinedStatus];
        }
    }
    
    else if ([path isEqual:self.party.partyId]) {
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
            [[HUD hud] dismiss];
            
            self.party.partyJoined = [[[(NSDictionary *)obj objectForKey:@"data"] objectForKey:@"join"] intValue];
            [self updateJoinedStatus];
            _refresh_party_info = NO;
        }
    }
}

- (IBAction)join
{
    if ([[User currentUser] isLoggedIn] == NO)
    {
        [self login];
        return;
    }
    
    else if ([User currentUser].people.peopleRealName.length <= 0)
    {
        [Tools alertWithTitle:@"请先完善您的个人资料！"];
        return;
    }
    
    else if ([User currentUser].people.peopleHeaderURL.length <= 0)
    {
        [Tools alertWithTitle:@"您还没有设置头像！"];
        return;
    }
    
    else
    {
        NSArray *joinedParties = [User currentUser].people.peopleJoinedParties;
        if ([joinedParties containsObject:_party.partyId])
        {
            [Tools alertWithTitle:@"您已参与此活动！"];
            return;
        }
    }
    
    NSString *path = [NSString stringWithFormat:@"/party/%@/join", _party.partyId];
    [[RKClient sharedClient] get:path delegate:self];
    
    [[HUD hud] presentWithText:@"提交申请..."];
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{
    [super request:request didLoadResponse:response];
    
    if ([request isGET]) {
        
        if ([response isOK]) {
            
            RKJSONParserJSONKit *parser = [[[RKJSONParserJSONKit alloc] init] autorelease];
            NSDictionary *dic = [parser objectFromString:[response bodyAsString] error:nil];
            
            int success = [[dic objectForKey:@"success"] intValue];
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
- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    [super objectLoader:objectLoader didLoadObjects:objects];
    
    RKResponse *response = objectLoader.response;
    RKRequest *request = response.request;
    
    [self handleResult:objects lastPathComponent:request.URL.lastPathComponent];
}
*/
// 个人信息
- (void)person
{
    if ([[User currentUser] isLoggedIn] == NO) {
        [self login];
        return;
    }
    
    PersonInfoViewController *viewController = [[PersonInfoViewController alloc] initWithNibName:@"PersonInfoViewController" bundle:nil];
    viewController.people = [User currentUser].people;
    viewController.CAN_UPDATE = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

// 拍照
- (void)camera
{
    UIActionSheet *sheet = [[[UIActionSheet alloc] initWithTitle:@"添加照片"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"拍照", @"相册", nil]
                            autorelease];
    [sheet showInView:self.view];
}

// 现场照片
- (void)allPhotos
{
    // party 现场照片
    [[HUD hud] presentWithText:@"Loading..."];
    /*
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Image class]];
    
    [mapping mapKeyPath:@"_id" toAttribute:@"_imageId"];
    [mapping mapKeyPath:@"mobile" toAttribute:@"_imageType"];
    [mapping mapKeyPath:@"uploadDate" toAttribute:@"_imageDate"];
    [mapping mapKeyPath:@"metadata" toAttribute:@"_metadata"];
    
    [[RKObjectManager sharedManager].mappingProvider setMapping:mapping forKeyPath:@"data"];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/party/%@/photo?offset=0&limit=100", _party.partyId]
                                                      delegate:self];
    */
    NSString *path = [NSString stringWithFormat:@"/party/%@/photo?offset=0&limit=%d",
                      _party.partyId, _page_size];
    [[RKClient sharedClient] get:path delegate:self];
}

// 参与活动者照片
- (void)allMembers
{
    // 参加party 的会员列表
    [[HUD hud] presentWithText:@"Loading..."];
    /*
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[People class]];
    
    [mapping mapKeyPath:@"_id" toAttribute:@"peopleId"];
    [mapping mapKeyPath:@"mobile" toAttribute:@"peopleMobilePhone"];
    [mapping mapKeyPath:@"name" toAttribute:@"peopleNickName"];
    [mapping mapKeyPath:@"icon" toAttribute:@"peopleHeaderURL"];
    [mapping mapKeyPath:@"truename" toAttribute:@"peopleRealName"];
    [mapping mapKeyPath:@"university" toAttribute:@"peopleUniversity"];
    [mapping mapKeyPath:@"faculty" toAttribute:@"peopleDepartment"];
    [mapping mapKeyPath:@"qq" toAttribute:@"peopleQQ"];
    [mapping mapKeyPath:@"email" toAttribute:@"peopleEmail"];
    [mapping mapKeyPath:@"description" toAttribute:@"peopleInformation"];
    [mapping mapKeyPath:@"" toAttribute:@"peopleEnterDate"];
    
    [[RKObjectManager sharedManager].mappingProvider setMapping:mapping forKeyPath:@"data"];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/party/%@/user?offset=0&limit=100", _party.partyId]
                                                      delegate:self];
    */
    NSString *path = [NSString stringWithFormat:@"/party/%@/user?offset=0&limit=%d",
                      _party.partyId, _page_size];
    [[RKClient sharedClient] get:path delegate:self];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow;
    
	if (buttonIndex == 0) {
        BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];//判断照相机是否可用（是否有摄像头）
        if(hasCamera == NO) {
            [Tools alertWithTitle:@"您的设备没有摄像头！"];
        } else {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            getPhotoFromCamera = YES;
        }
	} else if (buttonIndex == 1) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        getPhotoFromCamera = NO;
    }
    
    
    [self presentModalViewController:imagePicker animated:YES];
    [imagePicker release];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissModalViewControllerAnimated:YES];
    
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    //NSLog(@"___________%d", (UIImagePNGRepresentation(image)).length);
    
    if (getPhotoFromCamera)
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    
    [NSThread detachNewThreadSelector:@selector(useImage:) toTarget:self withObject:image];
}

- (void)useImage:(UIImage *)image
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    CGSize newSize = CGSizeMake(720, 720);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0,newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //NSLog(@"___________%d", (UIImagePNGRepresentation(newImage)).length);
    [self performSelectorOnMainThread:@selector(handlePhoto:) withObject:newImage waitUntilDone:NO];
    
    [pool release];
}

- (void)handlePhoto:(UIImage *)img
{
    HandlePhotoViewController *viewController = [[HandlePhotoViewController alloc] initWithNibName:@"HandlePhotoViewController" bundle:nil];
    viewController.image = img;
    viewController.party = self.party;
    viewController.getPhotoFromCamera = getPhotoFromCamera;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc
{
    [_party release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
