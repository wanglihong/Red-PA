//
//  AppDelegate.m
//  Red-PA
//
//  Created by Dennis Yang on 12-9-3.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "AppDelegate.h"

#import "HomeViewController.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 初始化应用窗口
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    // 设置状态栏风格(半透明)
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;
    
    // 设置 RestKit 的 BaseURL
    [RKClient clientWithBaseURLString:BASE_URL_STRING];
    
    // 设置 RKObjectManager
    RKObjectManager *manager = [RKObjectManager objectManagerWithBaseURL:[NSURL URLWithString:BASE_URL_STRING]];
    manager.acceptMIMEType = RKMIMETypeJSON;
    manager.serializationMIMEType = RKMIMETypeJSON;
    
    // 注册推送通知
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    
    // 用户设置
    NSDictionary *defaultValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   nil,  @"username",
                                   nil,  @"password",
                                   nil,  @"homeFirst",
                                   nil,  @"detlFirst",
                                   nil,  @"logout",
                                   nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
    
    // 创建主程序应用界面
    self.viewController = [[[HomeViewController alloc] init] autorelease];
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:self.viewController] autorelease];
    self.viewController.navigationController.navigationBarHidden = YES;
    self.window.rootViewController = navController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}
- (void)onResp:(BaseResp *)resp {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发送结果"
                                                    message:resp.errStr
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark --
#pragma mark Push notification

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"－－－－－－－－》deviceToken：%@", deviceToken);  // Print token
    //NSString *responseData = [[NSString alloc] initWithData:deviceToken encoding:NSASCIIStringEncoding];
    NSString *responseData = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@""]];
    
    responseData = [responseData stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    responseData = [responseData stringByReplacingOccurrencesOfString:@"<" withString:@""];
    
    responseData = [responseData stringByReplacingOccurrencesOfString:@">" withString:@""];
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"deviceToken" message:responseData delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
     */
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:responseData, @"token", nil];
    [[RKClient sharedClient] post:@"/token" params:params delegate:nil];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (application.applicationState == UIApplicationStateInactive) {
        NSString *url = [userInfo objectForKey:@"URL"];
        if (url) {
            [application openURL:[NSURL URLWithString:url]];
        }
    }
}

@end
