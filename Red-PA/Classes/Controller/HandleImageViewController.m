//
//  HandleImageViewController.m
//  Red-PA
//
//  Created by Dennis Yang on 12-9-24.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "HandleImageViewController.h"

#define _share_content [NSString stringWithFormat:@"#Let’s PA！#我在%@活动分享了图片，快来看看吧！[%@]", _party.partyName, [Tools dateStringWithDate:[NSDate date]]]

@interface HandleImageViewController ()

@end

@implementation HandleImageViewController

@synthesize image = _image;
@synthesize party = _party;

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
    
    
    // “分享” 按钮
    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareButton.frame = CGRectMake(165.0, 428.0, 130.0, 37.0);
    _shareButton.layer.borderWidth = 1.0;
    _shareButton.layer.borderColor = milky_white.CGColor;
    [_shareButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    [_shareButton setTitle:@"分享        " forState:UIControlStateNormal];
    [_shareButton setTitleColor:milky_white forState:UIControlStateNormal];
    [_shareButton setTitleColor:background_red forState:UIControlStateHighlighted];
    [_shareButton setBackgroundImage:[UIImage imageNamed:@"share_normal.png"] forState:UIControlStateNormal];
    [_shareButton setBackgroundImage:[UIImage imageNamed:@"share_highlight.png"] forState:UIControlStateHighlighted];
    [_shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [_shareButton setHidden:YES];
    [self.view addSubview:_shareButton];
    
    
    // 向微博注册
    weiBoEngine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
    [weiBoEngine setRootViewController:self];
    [weiBoEngine setDelegate:self];
    [weiBoEngine setRedirectURI:kWBRedirectURI];
    [weiBoEngine setIsUserExclusive:NO];
    
    
    // 向微信注册
    [WXApi registerApp:kWeixinAppId];
}

// 分享图片至 新浪微博、邮件、短信
- (void)share
{
    if ([[User currentUser] isLoggedIn] == NO) {
        [User currentUser].just_finished_login = YES;
        [self login];
        return;
    }
    
    UIActionSheet *sheet = [[[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"分享至微信", @"分享至新浪微博", @"邮件分享", @"短信分享", nil]
                            autorelease];
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self sendWeixin];
            break;
            
        case 1:
            [self sendWeibo];
            break;
            
        case 2:
            [self sendEMail];
            break;
            
        case 3:
            [self sendMessage];
            break;
            
        default:
            break;
    }
}

/*
 *--------------------------------------------------------------------------------------
 *
 * start: 发送微信 的相关函数
 *
 *--------------------------------------------------------------------------------------
 */

- (void)sendWeixin
{/*
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = YES;
    req.text = @"#Let’s PA！#我在xxx活动分享了图片，快来看看吧！";
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
  */
    
    if ([WXApi isWXAppInstalled] == NO) {
        [Tools alertWithTitle:@"请先安装微信"];
        return;
    } else if ([WXApi isWXAppSupportApi] == NO) {
        [Tools alertWithTitle:@"微信当前版本不支持开放接口"];
        return;
    } else if (self.image == nil) {
        [Tools alertWithTitle:@"请选择您要分享的图片"];
        return;
    }
    
    CGSize newSize = CGSizeMake(60, 60);
    UIGraphicsBeginImageContext(newSize);
    [self.image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:newImage];
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImageJPEGRepresentation(self.image, 1.0) ;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}

// 向微信发送请求后，收到来自微信的响应是调用此方法
- (void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送结果"];
        NSString *strMsg = [NSString stringWithFormat:@"发送媒体消息结果:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

/*
 *--------------------------------------------------------------------------------------
 *
 * end__: 发送微信 的相关函数
 *
 *--------------------------------------------------------------------------------------
 */

/*
 *--------------------------------------------------------------------------------------
 *
 * start: 发送微博 的相关函数
 *
 *--------------------------------------------------------------------------------------
 */

- (void)sendWeibo
{
    if (![weiBoEngine isLoggedIn] && [weiBoEngine isAuthorizeExpired]) {
        [weiBoEngine logIn];
    } else {
        [weiBoEngine sendWeiBoWithText:_share_content image:_image];
        [[HUD hud] presentWithText:@"Loading..."];
    }
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    NSLog(@"%@ %d", error.localizedDescription, error.code);
    NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
    
    if(detailedErrors != nil && [detailedErrors count] > 0) {
        for(NSError* detailedError in detailedErrors) {
            NSLog(@" DetailedError: %@", [detailedError userInfo]);
        }
        
    }else {
        NSLog(@"%@",[error userInfo]);
    }
    
    [[HUD hud] dismiss];
    [Tools alertWithTitle:[[error userInfo] objectForKey:@"error"]];
}

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    NSLog(@"%@", result);
    [[HUD hud] successWithText:@"分享成功"];
}

/*
 *--------------------------------------------------------------------------------------
 *
 * end__: 发送微博 的相关函数
 *
 *--------------------------------------------------------------------------------------
 */

/*
 *--------------------------------------------------------------------------------------
 *
 * start: 发送邮件 的相关函数
 *
 *--------------------------------------------------------------------------------------
 */

- (void)sendEMail
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass != nil) {
        if ([mailClass canSendMail]) [self displayComposerSheet];
        else [self launchMailAppOnDevice];
    } else
        [self launchMailAppOnDevice];
}

//可以发送邮件的话
-(void)displayComposerSheet
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    
    mailPicker.mailComposeDelegate = self;
    /*
    //设置主题
    [mailPicker setSubject: @""];
    
    // 添加发送者
    NSArray *toRecipients = [NSArray arrayWithObject: @"first@example.com"];
    NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    //NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com", nil];
    [mailPicker setToRecipients: toRecipients];
    [mailPicker setCcRecipients:ccRecipients];
    //[picker setBccRecipients:bccRecipients];
    */
    
    // 添加图片
    //UIImage *addPic = [UIImage imageNamed: @"3.jpg"];
    //NSData *imageData = UIImagePNGRepresentation(addPic);            // png
    NSData *imageData = UIImageJPEGRepresentation(_image, 1.0);    // jpeg
    [mailPicker addAttachmentData:imageData mimeType:@"" fileName:@"3.jpg"];
     
    NSString *emailBody = _share_content;
    [mailPicker setMessageBody:emailBody isHTML:YES];
    
    [self presentModalViewController: mailPicker animated:YES];
    [mailPicker release];
}

- (void)launchMailAppOnDevice
{
    NSString *recipients = @"mailto:first@example.com&subject=my email!";
    NSString *body = @"&body=email body!";
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *msg;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            msg = @"邮件发送取消";
            break;
        case MFMailComposeResultSaved:
            [[HUD hud] successWithText:@"邮件保存成功"];
            break;
        case MFMailComposeResultSent:
            [[HUD hud] successWithText:@"邮件发送成功"];
            break;
        case MFMailComposeResultFailed:
            [[HUD hud] failWithText:@"邮件发送失败"];
            break;
        default:
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

/*
 *--------------------------------------------------------------------------------------
 *
 * end__: 发送邮件 的相关函数
 *
 *--------------------------------------------------------------------------------------
 */

/*
 *--------------------------------------------------------------------------------------
 *
 * start: 发送短信 的相关函数
 *
 *--------------------------------------------------------------------------------------
 */

- (void)sendMessage
{
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    
    if (messageClass != nil) {
        
        if ([messageClass canSendText]) {
            [self displaySMSComposerSheet];
        }
        else {
            [Tools alertWithTitle:@"设备没有短信功能"];
        }
    }
    else {
        [Tools alertWithTitle:@"iOS版本过低,iOS4.0以上才支持程序内发送短信"];
    }
}

- (void)displaySMSComposerSheet
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    
    picker.body = _share_content;
    
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Result: SMS sending canceled");
            break;
        case MessageComposeResultSent:
            NSLog(@"Result: SMS sent");
            break;
        case MessageComposeResultFailed:
            [Tools alertWithTitle:@"短信发送失败"];
            break;
        default:
            NSLog(@"Result: SMS not sent");
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
    
}

/*
 *--------------------------------------------------------------------------------------
 *
 * end__:  发送短信 的相关函数
 *
 *--------------------------------------------------------------------------------------
 */

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc
{
    [weiBoEngine setDelegate:nil];
    [weiBoEngine release], weiBoEngine = nil;
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
