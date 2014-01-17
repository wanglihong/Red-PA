//
//  UserForgetViewController.m
//  Red-PA
//
//  Created by Dennis Yang on 12-9-25.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "UserForgetViewController.h"

@interface UserForgetViewController ()

@end

@implementation UserForgetViewController

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
    
    _firstTitleLabel.text = @"找回密码";
}

- (IBAction)submit
{
    if ([_mobileField.text isEqual:@""] || _mobileField.text.length == 0) {
        [Tools alertWithTitle:@"请输入手机号码"];
        return;
    } else if (_mobileField.text.length != 11) {
        [Tools alertWithTitle:@"请输入正确的手机号码"];
        return;
    }
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            _mobileField.text,  @"mobile",    nil];
    [[RKClient sharedClient] post:@"/forgetpassword" params:params delegate:self];
    
    [[HUD hud] presentWithText:@"正在提交..."];
}

- (void)handleSuccess
{
    [[HUD hud] successWithText:@"密码已发送至您的手机"];
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
                [self handleSuccess];
            else {
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
