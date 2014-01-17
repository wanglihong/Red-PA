//
//  PhotosViewController.m
//  Red-PA
//
//  Created by Dennis Yang on 12-9-6.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "PhotosViewController.h"

#import "HandlePhotosViewController.h"

#import "HandlePhotoViewController.h"

@interface PhotosViewController ()

@end

@implementation PhotosViewController

@synthesize party = _party;
@synthesize photos = _photos;
@synthesize totalCount = _totalCount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _firstTitleLabel.text = @"PA图秀";
    _secondTitleLabel.text= _party.partyName;
    
    _firstTitleLabel.frame = CGRectMake(0, _firstTitleLabel.frame.origin.y - 130, _firstTitleLabel.frame.size.width, _firstTitleLabel.frame.size.height);
    _secondTitleLabel.frame = CGRectMake(0, _secondTitleLabel.frame.origin.y - 130, _secondTitleLabel.frame.size.width, _secondTitleLabel.frame.size.height);
    
    _gridView = [[GridView alloc] initWithFrame:CGRectMake(25, 0, 226, self.view.bounds.size.height)];
    _gridView.tableView.contentInset = UIEdgeInsetsMake(130, 0, 15, 0);
    [_gridView.tableView addSubview:_firstTitleLabel];
    [_gridView.tableView addSubview:_secondTitleLabel];
    [self.view addSubview:_gridView];
    [_gridView release];
    
    _gridView.delegate = self;
    [_gridView.tableView reloadData];
    
    UIButton *b3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [b3 setImage:[UIImage imageNamed:@"camera_normal.png"] forState:UIControlStateNormal];
    [b3 setImage:[UIImage imageNamed:@"camera_normal.png"] forState:UIControlStateHighlighted];
    [b3 addTarget:self action:@selector(camera) forControlEvents:UIControlEventTouchUpInside];
    [self.menu addSubview:b3];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(just_finished_login:)
                                                 name:@"just_finished_login" object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 更新 gridview
    if (_refresh_gridview == YES)
    {
        NSString *path = [NSString stringWithFormat:@"/party/%@/photo?offset=%d&limit=%d",
                          _party.partyId, 0, self.photos.count];
        [[RKClient sharedClient] get:path delegate:self];
        
        [[HUD hud] presentWithText:@"更新列表..."];
    }
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
    
    _refresh_gridview = YES;
}

- (void)just_finished_login:(NSNotification *)notification
{
    self.photos = [NSMutableArray arrayWithArray:[notification object]];
    [_gridView.tableView reloadData];
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

#pragma makr - GridView data source

- (NSInteger)numberOfItemsInGridView:(GridView *)gridView
{
    NSInteger count = self.photos.count;
    return count  < _totalCount ? count + 1 : count;
}

- (NSString *)gridView:(GridView *)gridView titleForItemAtIndex:(NSInteger)index
{
    if (index == self.photos.count) {
        return @"显示更多";
    }
    
    Image *img = [self.photos objectAtIndex:index];
    return [NSString stringWithFormat:@"  %@", img.people.peopleNickName];
}

- (float     )gridView:(GridView *)gridView titleWidthForItemAtIndex:(NSInteger)index
{
    if (index == self.photos.count) {
        return 108.0;
    }
    
    return 78.0;
}

- (NSString *)gridView:(GridView *)gridView imageForItemAtIndex:(NSInteger)index
{
    if (index == self.photos.count) {
        return [NSString stringWithFormat:@"file://%@/load_more.png", [[NSBundle mainBundle] bundlePath]];
    }
    
    Image *img = [self.photos objectAtIndex:index];
    NSString *imgURL = [NSString stringWithFormat:@"%@/gridfs/%@", BASE_URL_STRING, img.imageId];
    return imgURL;
}

- (UITextAlignment)gridView:(GridView *)gridView textAlignmentForTitleAtIndex:(NSInteger)index
{
    if (index == self.photos.count) {
        return UITextAlignmentCenter;
    }
    
    return UITextAlignmentLeft;
}

- (BOOL      )gridView:(GridView *)gridView supportImageHiddenAtIndex:(NSInteger)index
{
    if (index == self.photos.count) {
        return YES;
    }
    
    return NO;
}

- (NSString *)gridView:(GridView *)gridView supportCountAtIndex:(NSInteger)index
{
    if (index == self.photos.count) {
        return @"";
    }
    
    Image *img = [self.photos objectAtIndex:index];
    return [NSString stringWithFormat:@"%d", img.supportCount];
}

#pragma mark - GridViewItem delegate

- (void)gridview:(GridView *)gridView didSelectItem:(GridViewItem *)gridViewItem atIndex:(NSInteger)index
{
    if (index == self.photos.count) {
        [self loadMore];
        return;
    }
    
    [self showPhotoInformationAtIndex:index image:gridViewItem.image];
}

- (void)showPhotoInformationAtIndex:(NSInteger)index image:(UIImage *)image
{
    HandlePhotosViewController *viewController;
    viewController = [[HandlePhotosViewController alloc] initWithNibName:@"HandlePhotosViewController" bundle:nil];
    viewController.image = image;
    viewController.pageIndex = index;
    viewController.photos = self.photos;
    viewController.party = self.party;
    
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)loadMore
{
    NSString *path = [NSString stringWithFormat:@"/party/%@/photo?offset=%d&limit=%d",
                      _party.partyId, self.photos.count, _page_size];
    [[RKClient sharedClient] get:path delegate:self];
    
    [[HUD hud] presentWithText:@"加载更多..."];
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

- (void)handleResult:(NSObject *)obj lastPathComponent:(NSString *)path
{
    if ([path isEqualToString:@"photo"]) {
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
            [[HUD hud] dismiss];
            
            NSMutableArray *photos = [[Parser sharedParser] photoFromArray:[(NSDictionary *)obj objectForKey:@"data"]];
            
            if (_refresh_gridview == YES) {
                [self.photos removeAllObjects];
                _refresh_gridview = NO;
            }
            [self.photos addObjectsFromArray:photos];
            [_gridView.tableView reloadData];
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc
{
    [_photos release];
    [_party release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
