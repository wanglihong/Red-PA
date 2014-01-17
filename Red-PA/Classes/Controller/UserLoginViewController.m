//
//  UserLoginViewController.m
//  Red-PA
//
//  Created by Dennis Yang on 12-9-5.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "UserLoginViewController.h"

#import "UserRegisterViewController.h"

#import "UserForgetViewController.h"

@interface UserLoginViewController ()

@end

@implementation UserLoginViewController

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
    
    _firstTitleLabel.text = @"用户登录";
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    _mobileField.text = username;
    _passField .text = password;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([User currentUser].just_finished_register)
    {
        NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
        _mobileField.text = username;
        _passField .text = password;
        
        [self userLogin];
        [User currentUser].just_finished_register = NO;
    }
}

- (IBAction)userRegister
{
    UserRegisterViewController *viewController = [[UserRegisterViewController alloc] initWithNibName:@"UserRegisterViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (IBAction)userForget
{
    UserForgetViewController *viewController = [[UserForgetViewController alloc] initWithNibName:@"UserForgetViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (IBAction)userLogin
{
    if ([_mobileField.text isEqual:@""] || _mobileField.text.length == 0) {
        [Tools alertWithTitle:@"请输入手机号码！"];
        return;
    }
    
    if ([_passField.text isEqual:@""] || _passField.text.length == 0) {
        [Tools alertWithTitle:@"请输入密码！"];
        return;
    }
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            _mobileField.text,  @"mobile",
                            _passField.text,    @"password",    nil];
    [[RKClient sharedClient] post:@"/login" params:params delegate:self];
    
    [[HUD hud] presentWithText:@"正在登录..."];
}

- (void)accessUser:(NSDictionary *)dic
{
    [[HUD hud] successWithText:@"登录成功"];
    
    People *people = [[Parser sharedParser] peopleFromDictionary:dic];
    
    [[User currentUser] setPeople:people];
    [[User currentUser] set_refresh_gridview:YES];
    
    // 保存登录帐号及密码
    [[NSUserDefaults standardUserDefaults] setValue:_mobileField.text forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setValue:_passField.text  forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"logout"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - RKObjectLoaderDelegate

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{
    [super request:request didLoadResponse:response];
    
    if ([request isPOST]) {
        if ([response isJSON]) {
            
            RKJSONParserJSONKit *parser = [[[RKJSONParserJSONKit alloc] init] autorelease];
            NSDictionary *dic = [parser objectFromString:[response bodyAsString] error:nil];
            
            int success = [[dic objectForKey:@"success"] intValue];
            if (success == 1)
                [self accessUser:[dic objectForKey:@"data"]];
            else {
                //[[HUD hud] failWithText:[dic objectForKey:@"msg"]];
                [[HUD hud] dismiss];
                [Tools alertWithTitle:[dic objectForKey:@"msg"]];
            }
        }
    }
}

#pragma makr - UITextField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.layer.borderColor = milky_white.CGColor;
    textField.layer.borderWidth = 1.0;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.layer.borderColor = [UIColor clearColor].CGColor;
    textField.layer.borderWidth = 0.0;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == _passField) {
        [self userLogin];
    }
    return YES;
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
