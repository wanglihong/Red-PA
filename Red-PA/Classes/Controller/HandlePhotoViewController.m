//
//  HandlePhotoViewController.m
//  Red-PA
//
//  Created by Dennis Yang on 12-9-6.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "HandlePhotoViewController.h"

@interface HandlePhotoViewController ()

@end

@implementation HandlePhotoViewController

@synthesize getPhotoFromCamera;
@synthesize soundData;

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
    [_shareButton setHidden:YES];
    
    // “上传” 按钮
    _uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //_uploadButton.frame = CGRectMake(25.0, 40.0, 130.0, 37.0);
    _uploadButton.frame = CGRectMake(165.0, self.view.frame.size.height - 52.0, 130.0, 37.0);
    _uploadButton.layer.borderWidth = 1.0;
    _uploadButton.layer.borderColor = milky_white.CGColor;
    [_uploadButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    [_uploadButton setTitle:@"上传" forState:UIControlStateNormal];
    [_uploadButton setTitleColor:milky_white forState:UIControlStateNormal];
    [_uploadButton setBackgroundImage:[UIImage imageNamed:@"button_selected.png"] forState:UIControlStateHighlighted];
    [_uploadButton addTarget:self action:@selector(prepareUpload) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_uploadButton];
    
    
    // “录音” 按钮
    _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _recordButton.frame = CGRectMake(165.0, self.view.frame.size.height - 52.0, 130.0, 37.0);
    _recordButton.layer.borderWidth = 1.0;
    _recordButton.layer.borderColor = milky_white.CGColor;
    [_recordButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    [_recordButton setTitle:@"按住录音" forState:UIControlStateNormal];
    [_recordButton setTitle:@"松开停止录音" forState:UIControlStateHighlighted];
    [_recordButton setTitleColor:milky_white forState:UIControlStateNormal];
    [_recordButton setBackgroundImage:[UIImage imageNamed:@"button_selected.png"] forState:UIControlStateHighlighted];
    [_recordButton addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchDown];
    [_recordButton addTarget:self action:@selector(endRecord) forControlEvents:UIControlEventTouchUpInside];
    [_recordButton addTarget:self action:@selector(endRecord) forControlEvents:UIControlEventTouchUpOutside];
    [self.view addSubview:_recordButton];
    [_recordButton setHidden:YES];
    
    
    // “录音” 控件
    recoder = [[SoundRecorder alloc] initWithFrame:self.view.frame];
    recoder.delegate = self;
    
    
    // “重拍” “重选” 按钮
    _reShootButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _reShootButton.frame = CGRectMake(25.0, self.view.frame.size.height - 52.0, 130.0, 37.0);
    _reShootButton.layer.borderWidth = 1.0;
    _reShootButton.layer.borderColor = milky_white.CGColor;
    [_reShootButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    [_reShootButton setTitle: getPhotoFromCamera == YES ? @"重拍" : @"重选" forState:UIControlStateNormal];
    [_reShootButton setTitleColor:milky_white forState:UIControlStateNormal];
    [_reShootButton setBackgroundImage:[UIImage imageNamed:@"button_selected.png"] forState:UIControlStateHighlighted];
    [_reShootButton addTarget:self action:@selector(camera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_reShootButton];
    
    
    // 大图
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.clipsToBounds = YES;
    _imageView.image = self.image;
    
    super.image = self.image;
}

- (void)startRecord
{
    UIButton *b = _recordButton;
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
    [UIView setAnimationDidStopSelector:@selector(endRecord)];
    
    v.frame = b.bounds;
    
    [UIView commitAnimations];
    
    [self.view addSubview:recoder];
    [recoder startRecord];
}

- (void)endRecord
{
    UIView *v = [_recordButton viewWithTag:100];
    if (v) {
        [v removeFromSuperview];
    }
    
    [recoder removeFromSuperview];
    [recoder stopRecord];
}

#pragma mark - SoundRecorderDelegate

- (void)soundRecordDidFinishWithFile:(NSString *)filePath
{
    NSLog(@"sound file path: %@", filePath);
    
    //self.soundData = [NSData dataWithContentsOfFile:filePath];
    
    //NSAssert(self.soundData, @"file not exist!");
    
    // 对音频数据编码(转成base64)
    //NSData *data = [GTMBase64 encodeData:soundData];
    //NSString *base64String = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease];
    
    hasRecorderFile = YES;
}

- (void)transformFinishedWithFile:(NSString *)filePath
{
    NSLog(@"sound file path: %@", filePath);
    
    self.soundData = [NSData dataWithContentsOfFile:filePath];
    
    NSAssert(self.soundData, @"file not exist!");
    
    [self upload];
}

- (void)prepareUpload
{
    if ([[User currentUser] isLoggedIn] == NO) {
        [User currentUser].just_finished_login = YES;
        [self login];
        return;
    }
    
    if (hasRecorderFile) {
        [[HUD hud] presentWithText:@"处理文件..."];
        [recoder transformFile];
    } else {
        [self upload];
    }
    
    hasRecorderFile = NO;
}

- (void)upload
{
    RKParams *params = [RKParams params];
    NSData *imageData = UIImageJPEGRepresentation(_image, 1.0);
    [params setData:imageData MIMEType:@"image/png" forParam:@"image"];
    if (soundData) {
        [params setData:soundData MIMEType:@"audio/mpeg" forParam:@"voice"];
    }
    [[RKClient sharedClient] post:[NSString stringWithFormat:@"/party/%@/photo", _party.partyId] params:params delegate:self];
    
    [[HUD hud] presentWithText:@"正在上传..."];
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{
    [super request:request didLoadResponse:response];
    
    if ([request isPOST]) {
        if ([response isJSON]) {
            
            RKJSONParserJSONKit *parser = [[[RKJSONParserJSONKit alloc] init] autorelease];
            NSDictionary *dic = [parser objectFromString:[response bodyAsString] error:nil];
            
            int success = [[dic objectForKey:@"success"] intValue];
            if (success == 1) {
                [[HUD hud] successWithText:@"上传成功"];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                //[[HUD hud] failWithText:[dic objectForKey:@"msg"]];
                [[HUD hud] dismiss];
                [Tools alertWithTitle:[dic objectForKey:@"msg"]];
            }
        }
    }
}


- (void)camera
{
    if (getPhotoFromCamera == YES) {
        //判断照相机是否可用（是否有摄像头）
        BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        if(hasCamera == NO) {
            [Tools alertWithTitle:@"您的设备没有摄像头！"];
            return;
        }
    }
    
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = getPhotoFromCamera == YES ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentModalViewController:imagePicker animated:YES];
    [imagePicker release];
}

- (void)photoAlbum
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentModalViewController:imagePicker animated:YES];
    [imagePicker release];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissModalViewControllerAnimated:YES];
    
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    
    if (getPhotoFromCamera)
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    
    [NSThread detachNewThreadSelector:@selector(useImage:) toTarget:self withObject:image];
}

- (void)useImage:(UIImage *)image
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    CGSize newSize = CGSizeMake(720, 720);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self performSelectorOnMainThread:@selector(handlePhoto:) withObject:newImage waitUntilDone:NO];
    
    [pool release];
}

- (void)handlePhoto:(UIImage *)img
{
    _imageView.image = img;
    _image = img;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [super dealloc];
    [soundData release];
    [recoder release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
