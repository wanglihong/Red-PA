//
//  HomeViewController.m
//  Red-PA
//
//  Created by Dennis Yang on 12-9-4.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "HomeViewController.h"

#import "SettingsViewController.h"
#import "PersonInfoViewController.h"

#import "PADetailViewController.h"

#import "GuideView.h"
#import "Image.h"
#import "Icon.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize gridView = _gridView;
@synthesize parties = _parties;

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
    
    //_backgroundImageView.image = [UIImage imageNamed:@"background.jpg"];
    
    _logo = [[UIImageView alloc] initWithFrame:CGRectMake(268.0 - 35.0/2, 33.0 - 112.0/2, 22.0 * 2, 112.0 * 2)];
    _logo.image = [UIImage imageNamed:@"logo_h.png"];
    _logo.alpha = 0;
    [self.view addSubview:_logo];
    [_logo release];
    
    _gridView = [[GridView alloc] initWithFrame:CGRectMake(0, 0, 226, self.view.bounds.size.height)];
    _gridView.delegate = self;
    _gridView.alpha = 0;
    [self.view addSubview:_gridView];
    
    _settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_settingsButton setAlpha:0];
    [_settingsButton setImage:[UIImage imageNamed:@"settings_normal.png"] forState:UIControlStateNormal];
    [_settingsButton setImage:[UIImage imageNamed:@"settings_normal.png"] forState:UIControlStateHighlighted];
    [_settingsButton setBackgroundImage:[UIImage imageNamed:@"selected_button_bg.png"] forState:UIControlStateHighlighted];
    [_settingsButton addTarget:self action:@selector(settings) forControlEvents:UIControlEventTouchUpInside];
    [_settingsButton setFrame:CGRectMake(self.view.bounds.size.width - 65.0 + 20.0, self.view.bounds.size.height -  70.0, 60.0, 60.0)];
    [self.view addSubview:_settingsButton];
    
    _userActionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_userActionButton setAlpha:0];
    [_userActionButton setImage:[UIImage imageNamed:@"person_normal.png"] forState:UIControlStateNormal];
    [_userActionButton setImage:[UIImage imageNamed:@"person_normal.png"] forState:UIControlStateHighlighted];
    [_userActionButton setBackgroundImage:[UIImage imageNamed:@"selected_button_bg.png"] forState:UIControlStateHighlighted];
    [_userActionButton addTarget:self action:@selector(userAction) forControlEvents:UIControlEventTouchUpInside];
    [_userActionButton setFrame:CGRectMake(self.view.bounds.size.width - 65.0 + 20.0, self.view.bounds.size.height - 130.0, 60.0, 60.0)];
    [self.view addSubview:_userActionButton];
    
    NSString *homeFirst = [[NSUserDefaults standardUserDefaults] objectForKey:@"homeFirst"];
    if (homeFirst == nil)
    {
        GuideView *guide = [[[GuideView alloc] initWithFrame:self.view.bounds] autorelease];
        if (iPhone5) {
            guide.image = [UIImage imageNamed:@"guide_home-568h@2x.png"];
        } else {
            guide.image = [UIImage imageNamed:@"guide_home.png"];
        }
        [self.view addSubview:guide];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"homeFirst"];
    }
    
    self.parties = [NSMutableArray array];
    [self displayLoading];
}

- (void)displayLoading
{
    _loadingViewController = [[LoadingViewController alloc] init];
    [self.view addSubview:_loadingViewController.view];
    
    // 监听加载完成时发来的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishLoading:)
                                                 name:@"finishLoading" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(numberOfParties:)
                                                 name:@"totalNumberOfParties" object:nil];
}

- (void)numberOfParties:(NSNotification *)notification
{
    _totalParties = [[notification object] intValue];
}

- (void)finishLoading:(NSNotification *)notification
{
    [self.parties addObjectsFromArray:(NSArray *)[notification object]];
    [_gridView.tableView reloadData];
    
    [_loadingViewController release];
    _loadingViewController = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self performSelector:@selector(fadeInLogo) withObject:nil afterDelay:2.0];
    [self performSelector:@selector(fadeInGridView) withObject:nil afterDelay:0.75];
    [self performSelector:@selector(fadeInButtons) withObject:nil afterDelay:0];
}

- (void)fadeInButtons
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    
    _settingsButton.alpha = 1.0;
    _settingsButton.frame = CGRectMake(self.view.bounds.size.width - 65.0, self.view.bounds.size.height -  70.0, 60.0, 60.0);
    
    _userActionButton.alpha = 1.0;
    _userActionButton.frame = CGRectMake(self.view.bounds.size.width - 65.0, self.view.bounds.size.height - 130.0, 60.0, 60.0);
    
    _gridView.alpha = 0.25;
    _gridView.frame = CGRectMake(20, 0, 226, self.view.bounds.size.height);
    
    [UIView commitAnimations];
}

- (void)fadeInGridView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    
    _gridView.alpha = 1.0;
    
    [UIView commitAnimations];
}

- (void)fadeInLogo
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    
    _logo.alpha = 1.0;
    _logo.frame = CGRectMake(275.0, 35.0, 22.0, 112.0);
    
    [UIView commitAnimations];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 更新 gridview
    if ([User currentUser]._refresh_gridview)
    {
        NSString *path = [NSString stringWithFormat:@"/party?offset=%d&limit=%d", 0, self.parties.count];
        [[RKClient sharedClient] get:path delegate:self];
        
        [[HUD hud] presentWithText:@"更新列表..."];
    }
    [_gridView.tableView reloadData];
}

- (void)userAction
{
    if ([[User currentUser] isLoggedIn] == NO) {
        [self login];
        return;
    }
    
    PersonInfoViewController *viewController = [[PersonInfoViewController alloc] initWithNibName:@"PersonInfoViewController" bundle:nil];
    viewController.people = [User currentUser].people;
    viewController.CAN_UPDATE = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)settings
{
    SettingsViewController *viewController = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)sendRequest:(Party *)pa
{
    [[RKClient sharedClient] get:[NSString stringWithFormat:@"/party/%@", pa.partyId] delegate:self];
    [[HUD hud] presentWithText:@"正在加载..."];
}

- (void)handleResult:(NSObject *)obj lastPathComponent:(NSString *)path
{
    if ([path isEqual:@"party"]) {
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
            NSMutableArray *newGettedParties = [[Parser sharedParser] partyFromArray:[(NSDictionary *)obj objectForKey:@"data"]];
            if ([User currentUser]._refresh_gridview)
            {
                [[User currentUser] set_refresh_gridview:NO];
                [self.parties removeAllObjects];
            }
            [self.parties addObjectsFromArray:newGettedParties];
            [_gridView.tableView reloadData];
        }
    } else if (_selectedParty && [path isEqual:_selectedParty.partyId]) {
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
            _selectedParty.partyName = [[(NSDictionary *)obj objectForKey:@"data"] objectForKey:@"name"];
            _selectedParty.partyPrevious = [self objectsWithDictionary:(NSDictionary *)obj];
        }
        
        [self showPartyDetail];
    }
}

- (NSArray *)objectsWithDictionary:(NSDictionary *)dic
{
    NSMutableArray *arr = [NSMutableArray array];
    
    NSArray *imgs = [[dic objectForKey:@"data"] objectForKey:@"posters"];
    for (int i = 0 ; i < imgs.count ; i++) {
        NSDictionary *imgInfo = [imgs objectAtIndex:i];
        
        Image *image = [[[Image alloc] init] autorelease];
        image.imageId = [imgInfo objectForKey:@"_id"];
        image.imageDate = [imgInfo objectForKey:@"uploadDate"];
        
        [arr addObject:image];
    }
    
    return arr;
}

- (void)showPartyDetail
{
    PADetailViewController *viewController = [[PADetailViewController alloc] initWithNibName:@"PADetailViewController" bundle:nil];
    viewController.party = _selectedParty;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

#pragma mark - Scroll view delegate

- (void)gridViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    if (offset.y > 0)
    {
        _backgroundImageView.frame = CGRectMake(0, - offset.y / 10, _backgroundImageView.frame.size.width, _backgroundImageView.frame.size.height);
    }
}

#pragma mark - GridViewItem delegate

- (void)gridview:(GridView *)gridView didSelectItem:(GridViewItem *)gridViewItem atIndex:(NSInteger)index
{
    if (index == self.parties.count)
    {
        [self loadMore];
        return;
    }
    
    Party *pa = [self.parties objectAtIndex:index];
    [self sendRequest:pa];
    _selectedParty = pa;
}

#pragma makr - GridView data source

- (NSInteger)numberOfItemsInGridView:(GridView *)gridView
{
    NSInteger count = self.parties.count;
    return count  < _totalParties ? count + 1 : count;
}

- (NSString *)gridView:(GridView *)gridView titleForItemAtIndex:(NSInteger)index
{
    if (index == self.parties.count)
    {
        return @"显示更多";
    }
    
    Party *pa = [self.parties objectAtIndex:index];
    return pa.partyTitle;
}

- (NSString *)gridView:(GridView *)gridView imageForItemAtIndex:(NSInteger)index
{
    if (index == self.parties.count)
    {
        return [NSString stringWithFormat:@"file://%@/load_more.png", [[NSBundle mainBundle] bundlePath]];
    }
    
    Party *pa = [self.parties objectAtIndex:index];
    NSString *imgURL = [NSString stringWithFormat:@"%@/gridfs/%@", BASE_URL_STRING, pa.partyIconId];
    
    return imgURL;
}

- (BOOL      )gridView:(GridView *)gridView hasJoinPartyAtIndex:(NSInteger)index
{
    if (index == self.parties.count)
    {
        return NO;
    }
    
    Party *pa = [self.parties objectAtIndex:index];
    if (pa.partyJoined == 1)
    {
        return YES;
    }
    
    return NO;
}

- (void)loadMore
{/*
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Party class]];
    
    [mapping mapKeyPath:@"_id"         toAttribute:@"partyId"];
    [mapping mapKeyPath:@"actived"     toAttribute:@"partyDate"];
    [mapping mapKeyPath:@"address"     toAttribute:@"partyPlace"];
    [mapping mapKeyPath:@"description" toAttribute:@"partyIntroduce"];
    [mapping mapKeyPath:@"name"        toAttribute:@"partyName"];
    [mapping mapKeyPath:@"icon"        toAttribute:@"partyIconId"];
    [mapping mapKeyPath:@"entrepreneur"        toAttribute:@"entrepreneur"];
    
    [[RKObjectManager sharedManager].mappingProvider setMapping:mapping forKeyPath:@"data"];
    
    NSString *path = [NSString stringWithFormat:@"/party?offset=%d&limit=%d", self.parties.count, _page_size];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:path delegate:self];
    */
    NSString *path = [NSString stringWithFormat:@"/party?offset=%d&limit=%d", self.parties.count, _page_size];
    [[RKClient sharedClient] get:path delegate:self];
    [[HUD hud] presentWithText:@"加载更多..."];
}

#pragma mark - RKObjectLoaderDelegate

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{
    [super request:request didLoadResponse:response];
    
    [[HUD hud] dismiss];
    
    RKJSONParserJSONKit *parser = [[[RKJSONParserJSONKit alloc] init] autorelease];
    NSDictionary *dic = [parser objectFromString:[response bodyAsString] error:nil];
    
    if ([request isGET]) {
        if ([response isOK]) {
            
            [self handleResult:dic lastPathComponent:request.URL.lastPathComponent];
        }
    }
}
/*
- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    [super objectLoader:objectLoader didLoadObjects:objects];
    
    [self.parties addObjectsFromArray:objects];
    [_gridView.tableView reloadData];
}
*/
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [_gridView release];
    [_parties release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
