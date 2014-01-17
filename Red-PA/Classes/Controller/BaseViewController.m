//
//  BaseViewController.m
//  Red-PA
//
//  Created by Dennis Yang on 12-9-5.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "BaseViewController.h"

#import "UserLoginViewController.h"

#import "SDImageCache.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

@synthesize backgroundImageView = _backgroundImageView;

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
	// Do any additional setup after loading the view.
    
    [self setWantsFullScreenLayout:YES];
    [self.view setBackgroundColor:background_red];
    [self.view setFrame:[UIScreen mainScreen].bounds];
    
    _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,
                                                                         self.view.bounds.size.height * 2)];
    [self.view addSubview:_backgroundImageView];
    [self.view sendSubviewToBack:_backgroundImageView];
}

- (void)login
{
    UserLoginViewController *viewController = [[UserLoginViewController alloc] initWithNibName:@"UserLoginViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

#pragma mark - RKObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", [error localizedDescription]);
    //[[HUD hud] failWithText:error.localizedDescription];
    [[HUD hud] dismiss];
    [Tools alertWithTitle:error.localizedDescription];
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{
    NSLog(@"response status code: %d", [response statusCode]);
    
    if ([request isGET]) {
        if ([response isOK]) {
            NSLog(@"Retrieved XML: %@", [response bodyAsString]);
        }
        
    } else if ([request isPOST]) {
        if ([response isJSON]) {
            NSLog(@"Got a JSON response back from our POST! %@", [response bodyAsString]);
        }
        
    } else if ([request isPUT]) {
        if ([response isOK]) {
            NSLog(@"The put result:%@", [response bodyAsString]);
        }
        
    } else if ([request isDELETE]) {
        if ([response isNotFound]) {
            NSLog(@"The resource path '%@' was not found.", [request resourcePath]);
        }
        
    } else if (response.statusCode >= 400) {
        [[HUD hud] failWithText:@"服务器异常！"];
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    NSLog(@"objects[%d]", [objects count]);
    [[HUD hud] dismiss];
}

- (void)dealloc
{
    [_backgroundImageView release];
    
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
