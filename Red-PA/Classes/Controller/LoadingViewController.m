//
//  LoadingViewController.m
//  Red-PA
//
//  Created by Dennis Yang on 12-9-7.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "LoadingViewController.h"

#import "HomeViewController.h"

@interface LoadingViewController ()

@end

@implementation LoadingViewController

@synthesize parties = _parties;

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
	
    if (iPhone5)
        _bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default-568h.png"]];
    else
        _bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_bg];
    [_bg release];
    
    /*
    _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activity.frame = CGRectMake(self.view.bounds.size.width / 2 - 37 / 2, 360, 37, 37);
    [self.view addSubview:_activity];
    [_activity startAnimating];
    [_activity release];*/
    
    
    _prompt = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 80, self.view.bounds.size.width, 21)];
    _prompt.backgroundColor = [UIColor clearColor];
    _prompt.textAlignment = UITextAlignmentCenter;
    _prompt.textColor = [UIColor whiteColor];
    //_prompt.text = @"Loading...";
    [self.view addSubview:_prompt];
    [_prompt release];
    
    
    //[self sendRequest];
    
    
    _observer = [[RKReachabilityObserver alloc] initWithHost:HOST_ADDRESS];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:RKReachabilityDidChangeNotification
                                               object:_observer];
}

- (void)reachabilityChanged:(NSNotification *)notification
{
    RKReachabilityObserver *observer = (RKReachabilityObserver *)[notification object];
    
    
    if ([observer isNetworkReachable]) {
        /*
        if ([observer isConnectionRequired]) {
            _prompt.text = @"Connection is available...";
            _prompt.textColor = [UIColor yellowColor];
            return;
        }
        
        _prompt.textColor = [UIColor greenColor];
        
        if (RKReachabilityReachableViaWiFi == [observer networkStatus]) {
            _prompt.text = @"Online via WiFi";
        } else if (RKReachabilityReachableViaWWAN == [observer networkStatus]) {
            _prompt.text = @"Online via 3G or Edge";
        }*/
        //_prompt.text = NSLocalizedString(@"loading", @"");
        _prompt.text = @"Loading...";
        //[self sendRequest];
        [self doLogin];
    } else {
        //_prompt.text = NSLocalizedString(@"unreachable", @"");
        _prompt.text = @"无网络连接...";
    }
}

- (void)doLogin
{
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    NSString *logout   = [[NSUserDefaults standardUserDefaults] objectForKey:@"logout"];
    NSLog(@">>>----------------->%@", logout);
    NSLog(@">>>----------------->%@", username);
    NSLog(@">>>----------------->%@", password);
    if (logout==nil && username && password) {
        // 否则自动登录
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                username,  @"mobile",
                                password,  @"password",    nil];
        [[RKClient sharedClient] post:@"/login" params:params delegate:self];
    } else {
        [self sendRequest];
    }
    
}

- (void)sendRequest
{/*
    // 获取party列表
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Party class]];
    
    [mapping mapKeyPath:@"_id"         toAttribute:@"partyId"];
    [mapping mapKeyPath:@"actived"     toAttribute:@"partyDate"];
    [mapping mapKeyPath:@"address"     toAttribute:@"partyPlace"];
    [mapping mapKeyPath:@"description" toAttribute:@"partyIntroduce"];
    [mapping mapKeyPath:@"name"        toAttribute:@"partyName"];
    [mapping mapKeyPath:@"icon"        toAttribute:@"partyIconId"];
    [mapping mapKeyPath:@"entrepreneur"        toAttribute:@"entrepreneur"];
    
    [[RKObjectManager sharedManager].mappingProvider setMapping:mapping forKeyPath:@"data"];
    
    NSString *path = [NSString stringWithFormat:@"/party?offset=%d&limit=%d", 0, _page_size];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:path delegate:self]; 
  */
    NSString *path = [NSString stringWithFormat:@"/party?offset=%d&limit=%d", 0, _page_size];
    [[RKClient sharedClient] get:path delegate:self];
}

- (void)accessUser:(NSDictionary *)dic
{
    People *people = [[Parser sharedParser] peopleFromDictionary:dic];
    [[User currentUser] setPeople:people];
    [self sendRequest];
}

#pragma mark - RKObjectLoaderDelegate

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{
    [super request:request didLoadResponse:response];
    
    RKJSONParserJSONKit *parser = [[[RKJSONParserJSONKit alloc] init] autorelease];
    NSDictionary *dic = [parser objectFromString:[response bodyAsString] error:nil];
    
    if ([request isGET]) {
        if ([response isOK]) {
            
            NSString *count = [dic objectForKey:@"total"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"totalNumberOfParties" object:count];
            
            self.parties = [[Parser sharedParser] partyFromArray:[dic objectForKey:@"data"]];
            [self performSelectorOnMainThread:@selector(enter) withObject:nil waitUntilDone:NO];
        }
    }
    
    if ([request isPOST]) {
        if ([response isJSON]) {
            
            int success = [[dic objectForKey:@"success"] intValue];
            if (success == 1) {
                [self accessUser:[dic objectForKey:@"data"]];
            } else {
                //[[HUD hud] failWithText:[dic objectForKey:@"msg"]];
                [[HUD hud] dismiss];
                //[Tools alertWithTitle:[dic objectForKey:@"msg"]];
                [self sendRequest];
            }
        }
    }
}
/*
- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    self.parties = objects;
    [self performSelectorOnMainThread:@selector(enter) withObject:nil waitUntilDone:NO];
}
*/
- (void)enter
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishLoading)];
    
    [_bg setFrame:CGRectMake(- self.view.frame.size.width / 2, - self.view.frame.size.height / 2,
                                   self.view.frame.size.width * 2, self.view.frame.size.height * 2)];
    [self.view setAlpha:0.0];
    
    [UIView commitAnimations];
}

- (void)finishLoading
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"finishLoading" object:self.parties];
    [self.view removeFromSuperview];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_observer release];
    [_parties release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
