//
//  UpdatePersonInfoViewController.m
//  Red-PA
//
//  Created by Dennis Yang on 12-9-13.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "UpdatePersonInfoViewController.h"

@interface UpdatePersonInfoViewController ()

@end

@implementation UpdatePersonInfoViewController

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
    
    _firstTitleLabel.text = @"完善资料";
    _secondTitleLabel.text= @"只有完善资料，才能参与PA哦！";
    
    [_boy setBackgroundImage:[UIImage imageNamed:@"boy_normal.png"] forState:UIControlStateNormal];
    [_boy setBackgroundImage:[UIImage imageNamed:@"boy_selected.png"] forState:UIControlStateSelected];
    [_boy setBackgroundImage:[UIImage imageNamed:@"boy_selected.png"] forState:UIControlStateHighlighted];
    [_boy setTitleColor:milky_white forState:UIControlStateNormal];
    [_boy setTitleColor:background_red forState:UIControlStateSelected];
    
    [_girl setBackgroundImage:[UIImage imageNamed:@"girl_normal.png"] forState:UIControlStateNormal];
    [_girl setBackgroundImage:[UIImage imageNamed:@"girl_selected.png"] forState:UIControlStateSelected];
    [_girl setBackgroundImage:[UIImage imageNamed:@"girl_selected.png"] forState:UIControlStateHighlighted];
    [_girl setTitleColor:milky_white forState:UIControlStateNormal];
    [_girl setTitleColor:background_red forState:UIControlStateSelected];
    
    NSString *imgURL = [NSString stringWithFormat:@"%@/gridfs/%@", BASE_URL_STRING, [User currentUser].people.peopleHeaderURL];
    [_header setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    [self updateInformation];
    _scrollView.contentSize = CGSizeMake(226, 848);
}

- (void)updateInformation
{
    if ([[User currentUser].people.peopleGender isEqual:@"m"]) {
        [self setGender:_boy];
    } else {
        [self setGender:_girl];
    }
    _nickNameField.text = [User currentUser].people.peopleNickName;
    _realNameField.text = [User currentUser].people.peopleRealName;
    _collegeField.text  = @"国泰广告";//[User currentUser].people.peopleUniversity;
    _departmentField.text = [User currentUser].people.peopleDepartment;
    _qqNumberField.text = [User currentUser].people.peopleQQ;
    _emailField.text    = [User currentUser].people.peopleEmail;
    _informationField.text= [User currentUser].people.peopleInformation;
}

- (void)upload:(UIImage *)photo
{
    RKParams *params = [RKParams params];
    
    NSData *imageData = UIImageJPEGRepresentation(photo, 1.0);
    [params setData:imageData MIMEType:@"image/png" forParam:@"image"];
    
    [[RKClient sharedClient] post:@"/user/icon" params:params delegate:self];
    [[HUD hud] presentWithText:@"上传头像..."];
}

- (IBAction)setHeader
{
    UIActionSheet *sheet = [[[UIActionSheet alloc] initWithTitle:@"添加照片"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"拍照", @"从相册选择", nil]
                            autorelease];
    [sheet showInView:self.view];
}

- (IBAction)setGender:(id)sender
{
    UIButton *b = (UIButton *)sender;
    
    if (b == _boy) {
        _gender = @"m";
        _boy.selected = YES;
        _girl.selected = NO;
    }
    else {
        _gender = @"f";
        _boy.selected = NO;
        _girl.selected = YES;
    }
}

- (IBAction)down
{
    if ([_nickNameField.text isEqual:@""] || _nickNameField.text.length == 0) {
        [Tools alertWithTitle:@"请输入您的昵称"];
        return;
    } else if ([_realNameField.text isEqual:@""] || _realNameField.text.length == 0) {
        [Tools alertWithTitle:@"请输入您的真实姓名"];
        return;
    } else if ([_collegeField.text isEqual:@""] || _collegeField.text.length == 0) {
        [Tools alertWithTitle:@"请输入您的学校"];
        return;
    } else if ([_departmentField.text isEqual:@""] || _departmentField.text.length == 0) {
        [Tools alertWithTitle:@"请输入您所在部门"];
        return;
    } else if ([_qqNumberField.text isEqual:@""] || _qqNumberField.text.length == 0) {
        [Tools alertWithTitle:@"请输入您的QQ号"];
        return;
    } else if ([_emailField.text isEqual:@""] || _emailField.text.length == 0) {
        [Tools alertWithTitle:@"请输入您的电子邮箱"];
        return;
    }/* else if ([_informationField.text isEqual:@""] || _informationField.text.length == 0) {
        [Tools alertWithTitle:@"请输入您的个人简介"];
        return;
    }*/ else if (_header.image == nil) {
        [Tools alertWithTitle:@"请设置您的个人头像"];
        return;
    }
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            _gender,                @"gender",
                            _nickNameField.text,    @"name",
                            _realNameField.text,    @"truename",
                            _collegeField.text,     @"university",
                            _departmentField.text,  @"dept",    //@"faculty",//
                            _qqNumberField.text,    @"qq",
                            _emailField.text,       @"email",
                            _informationField.text, @"description", nil];
    [[RKClient sharedClient] put:@"/user" params:params delegate:self];
    
    [[HUD hud] presentWithText:@"更新资料..."];
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{
    [super request:request didLoadResponse:response];
    
    RKJSONParserJSONKit *parser = [[[RKJSONParserJSONKit alloc] init] autorelease];
    NSDictionary *dic = [parser objectFromString:[response bodyAsString] error:nil];
    
    int success = [[dic objectForKey:@"success"] intValue];
    
    if ([request isPOST]) {
        if ([response isOK]) {
            if (request.resourcePath == @"/user/icon") {
                
                if (success == 1) {
                    [[HUD hud] successWithText:@"上传成功"];
                    [User currentUser].people.peopleHeaderURL = [[dic objectForKey:@"data"] objectForKey:@"_id"];
                }
                else {
                    //[[HUD hud] failWithText:[dic objectForKey:@"msg"]];
                    [[HUD hud] dismiss];
                    [Tools alertWithTitle:[dic objectForKey:@"msg"]];
                }
            }
        }
    }
    
    else if ([request isPUT]) {
        if ([response isOK]) {
            if (request.resourcePath == @"/user") {
                
                if (success == 1) {
                    [[HUD hud] successWithText:@"资料已更新"];
                    [self accessUser:[dic objectForKey:@"data"]];
                } else {
                    //[[HUD hud] failWithText:[dic objectForKey:@"msg"]];
                    [[HUD hud] dismiss];
                    [Tools alertWithTitle:[dic objectForKey:@"msg"]];
                }
            }
        }
    }
}

- (void)accessUser:(NSDictionary *)dic
{
    People *people = [[Parser sharedParser] peopleFromDictionary:dic];
    
    [[User currentUser] setPeople:people];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    float y = textField.frame.origin.y;
    CGPoint point = CGPointMake(0, y > 130.0 ? (y - 130.0) : 0);
    [_scrollView setContentOffset:point animated:YES];
    return YES;
}

#pragma mark - UITextView delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    float y = textView.frame.origin.y;
    CGPoint point = CGPointMake(0, y > 130.0 ? (y - 130.0) : 0);
    [_scrollView setContentOffset:point animated:YES];
    
    if ([_informationField.text isEqual:@"个人简介"]) {
        _informationField.text = @"";
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([_informationField.text isEqual:@""] || _informationField.text.length == 0)
        
        textView.text = @"个人简介";
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if (range.location > 60 && range.length == 0)
        
        return NO;
    
    else
        
        return YES;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if        (buttonIndex == 2) {
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
	if        (buttonIndex == 0) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        getPhotoFromCamera = YES;
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
    
    if (getPhotoFromCamera) 
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    
    [NSThread detachNewThreadSelector:@selector(useImage:) toTarget:self withObject:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)useImage:(UIImage *)image
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    CGSize newSize = CGSizeMake(320, 320);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0,newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [_header setImage:newImage];
    [self performSelectorOnMainThread:@selector(upload:) withObject:newImage waitUntilDone:NO];
    
    [pool release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc
{
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
