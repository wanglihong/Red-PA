//
//  PersonSettingsViewController.m
//  Red-PA
//
//  Created by Dennis Yang on 12-9-13.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "PersonSettingsViewController.h"

#import "UpdatePersonInfoViewController.h"

#import "ChangePasswordViewController.h"

@interface PersonSettingsViewController ()

@end

@implementation PersonSettingsViewController

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
    
    _firstTitleLabel.text = @"个人设置";
}

// 更新帐号资料
- (IBAction)updateUserInfo
{
    UpdatePersonInfoViewController *viewController = [[UpdatePersonInfoViewController alloc] initWithNibName:@"UpdatePersonInfoViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

// 绑定微博
- (IBAction)bindWeibo
{
    // 微博Engine
    if (!engine)
    {
        engine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
        [engine setRootViewController:self];
        [engine setDelegate:self];
        [engine setRedirectURI:kWBRedirectURI];
        [engine setIsUserExclusive:NO];
    }
    
    
    if ([engine isLoggedIn] && ![engine isAuthorizeExpired]) {
        [Tools alertWithTitle:@"您已绑定过微博"];
    }
    else {
        [engine logIn];
    }
    
    //[engine release];
}

// 修改密码
- (IBAction)changePassword
{
    ChangePasswordViewController *viewController = [[ChangePasswordViewController alloc] initWithNibName:@"ChangePasswordViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

// 注销
- (IBAction)logout
{
    [[RKClient sharedClient] post:@"/logout" params:nil delegate:self];
    [[HUD hud] presentWithText:@"正在注销..."];
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
            if (success == 1) {
                [[HUD hud] successWithText:@"注销成功"];
                [User currentUser].people = nil;
                [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"logout"];
                [[User currentUser] set_refresh_gridview:YES];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                //[[HUD hud] failWithText:[dic objectForKey:@"msg"]];
                [[HUD hud] dismiss];
                [Tools alertWithTitle:[dic objectForKey:@"msg"]];
            }
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
    [super dealloc];
    
    if (engine)
    {
        [engine setDelegate:nil];
        [engine release];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
