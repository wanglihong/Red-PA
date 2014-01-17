//
//  UserRegisterViewController.m
//  Red-PA
//
//  Created by Dennis Yang on 12-9-5.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "UserRegisterViewController.h"

#import "Auth.h"

@interface UserRegisterViewController ()

@end

@implementation UserRegisterViewController

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
    
    _firstTitleLabel.text = @"用户注册";
    
    _scrollView.contentSize = CGSizeMake(226, 680);
    
}

- (IBAction)getVerifyCode
{
    if ([_mobileField.text isEqual:@""] || _mobileField.text.length == 0) {
        [Tools alertWithTitle:@"请输入手机号码！"];
        return;
    }
    
    _getVerifyCodeButton.selected = YES;
    _getVerifyCodeButton.highlighted = YES;
    _getVerifyCodeButton.userInteractionEnabled = NO;
    
    NSDictionary *params = [NSDictionary dictionaryWithObject:_mobileField.text forKey:@"mobile"];
    [[RKClient sharedClient] post:@"/application" params:params delegate:self];
    [[HUD hud] presentWithText:@"正在发送..."];
}

- (IBAction)downRegister
{
    if ([_authField.text isEqual:@""] || _authField.text.length == 0) {
        [Tools alertWithTitle:@"请输入验证码！"];
        return;
    }
    
    if ([_passField.text isEqual:@""] || _passField.text.length == 0) {
        [Tools alertWithTitle:@"请输入密码！"];
        return;
    }
    
    if ([_rePassField.text isEqual:@""] || _rePassField.text.length == 0) {
        [Tools alertWithTitle:@"请再次输入密码！"];
        return;
    }
    
    if ([_nameField.text isEqual:@""] || _nameField.text.length == 0) {
        [Tools alertWithTitle:@"请输入昵称！"];
        return;
    }
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            _authField.text, @"code",
                            _passField.text, @"password",
                            _nameField.text, @"name",       nil];
    [[RKClient sharedClient] post:@"/register" params:params delegate:self];
    
    [[HUD hud] presentWithText:@"正在注册..."];
}

#pragma mark - UITextFiel delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    float y = textField.frame.origin.y;
    CGPoint point = CGPointMake(0, y > 160.0 ? (y - 160.0) : 0);
    [_scrollView setContentOffset:point animated:YES];
    return YES;
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
                
                [self handleResult:dic lastPathComponent:request.resourcePath.lastPathComponent];
            }
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
    if ([path isEqual:@"application"]) {
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
            [[HUD hud] successWithText:@"验证码已发送至您注册的手机"];
        }
    } else if ([path isEqual:@"register"]) {
    
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
            [[HUD hud] successWithText:@"注册成功"];
            
            [self handleRegisterSuccess];
        }
    }
}

- (void)handleRegisterSuccess
{
    [[User currentUser] setJust_finished_register:YES];
    
    [[NSUserDefaults standardUserDefaults] setValue:_mobileField.text forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setValue:_passField.text  forKey:@"password"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
