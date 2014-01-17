//
//  ChangePasswordViewController.m
//  Red-PA
//
//  Created by Dennis Yang on 12-9-19.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

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
    
    _firstTitleLabel.text = @"修改密码";
}

- (IBAction)down
{
    if ([_oldPassField.text isEqual:@""] || _oldPassField.text.length == 0) {
        [Tools alertWithTitle:@"请输入旧密码！"];
        return;
    } else if ([_newPassField.text isEqual:@""] || _newPassField.text.length == 0) {
        [Tools alertWithTitle:@"请输入新密码！"];
        return;
    } else if ([_conPassField.text isEqual:@""] || _conPassField.text.length == 0) {
        [Tools alertWithTitle:@"请再输入一次新密码！"];
        return;
    } else if (![_newPassField.text isEqual:_conPassField.text]) {
        [Tools alertWithTitle:@"两次输入的密码不一致！"];
        return;
    }
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            _oldPassField.text,  @"oldpassword",
                            _newPassField.text,  @"password",    nil];
    [[RKClient sharedClient] post:@"/password" params:params delegate:self];
    
    [[HUD hud] presentWithText:@"提交请求..."];
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{
    [super request:request didLoadResponse:response];
    
    if ([request isPOST]) {
        
        if ([response isJSON]) {
            
            RKJSONParserJSONKit *parser = [[[RKJSONParserJSONKit alloc] init] autorelease];
            NSDictionary *dic = [parser objectFromString:[response bodyAsString] error:nil];
            
            int success = [[dic objectForKey:@"success"] intValue];
            if (success == 1)
                [self successOfChange];
            else {
                //[[HUD hud] failWithText:[dic objectForKey:@"msg"]];
                [[HUD hud] dismiss];
                [Tools alertWithTitle:[dic objectForKey:@"msg"]];
            }
        }
    }
}

- (void)successOfChange
{
    [[HUD hud] successWithText:@"修改成功"];
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
