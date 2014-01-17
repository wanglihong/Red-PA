//
//  MembersViewController.m
//  Red-PA
//
//  Created by Dennis Yang on 12-9-6.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "MembersViewController.h"

#import "PersonInfoViewController.h"

@interface MembersViewController ()

@end

@implementation MembersViewController

@synthesize party = _party;
@synthesize members = _members;
@synthesize totalCount = _totalCount;

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
	
    _firstTitleLabel.text = @"参与PA友";
    _secondTitleLabel.text= _party.partyName;
    
    _firstTitleLabel.frame = CGRectMake(0, _firstTitleLabel.frame.origin.y - 130, _firstTitleLabel.frame.size.width, _firstTitleLabel.frame.size.height);
    _secondTitleLabel.frame = CGRectMake(0, _secondTitleLabel.frame.origin.y - 130, _secondTitleLabel.frame.size.width, _secondTitleLabel.frame.size.height);
    
    _gridView = [[GridView alloc] initWithFrame:CGRectMake(25, 0, 226, self.view.bounds.size.height)];
    _gridView.tableView.contentInset = UIEdgeInsetsMake(130, 0, 15, 0);
    [_gridView.tableView addSubview:_firstTitleLabel];
    [_gridView.tableView addSubview:_secondTitleLabel];
    [self.view addSubview:_gridView];
    [_gridView release];
    
    _gridView.delegate = self;
    [_gridView.tableView reloadData];
}

#pragma makr - GridView data source

- (NSInteger)numberOfItemsInGridView:(GridView *)gridView
{
    NSInteger count = self.members.count;
    return count  < _totalCount ? count + 1 : count;
}

- (NSString *)gridView:(GridView *)gridView titleForItemAtIndex:(NSInteger)index
{
    if (index == self.members.count) {
        return @"显示更多";
    }
    
    People *p = [self.members objectAtIndex:index];
    return p.peopleNickName;
}

- (NSString *)gridView:(GridView *)gridView imageForItemAtIndex:(NSInteger)index
{
    if (index == self.members.count) {
        return [NSString stringWithFormat:@"file://%@/load_more.png", [[NSBundle mainBundle] bundlePath]];
    }
    
    People *p = [self.members objectAtIndex:index];
    NSString *imgURL = [NSString stringWithFormat:@"%@/gridfs/%@", BASE_URL_STRING, p.peopleHeaderURL];
    return imgURL;
}

#pragma mark - GridViewItem delegate

- (void)gridview:(GridView *)gridView didSelectItem:(GridViewItem *)gridViewItem atIndex:(NSInteger)index
{
    if (index == self.members.count) {
        [self loadMore];
        return;
    }
    
    People *p = [self.members objectAtIndex:index];
    [self showPersonInformation:p];
}

- (void)showPersonInformation:(People *)p
{
    PersonInfoViewController *viewController;
    viewController = [[PersonInfoViewController alloc] initWithNibName:@"PersonInfoViewController"
                                                                bundle:nil];
    viewController.people = p;
    
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)loadMore
{
    NSString *path = [NSString stringWithFormat:@"/party/%@/user?offset=%d&limit=%d",
                      _party.partyId, self.members.count, _page_size];
    [[RKClient sharedClient] get:path delegate:self];
    
    [[HUD hud] presentWithText:@"加载更多..."];
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{
    [super request:request didLoadResponse:response];
    
    if ([request isGET]) {
        
        if ([response isOK]) {
            
            RKJSONParserJSONKit *parser = [[[RKJSONParserJSONKit alloc] init] autorelease];
            NSDictionary *dic = [parser objectFromString:[response bodyAsString] error:nil];
            
            int success = [[dic objectForKey:@"success"] intValue];
            if (success == 1)
                [self handleResult:dic lastPathComponent:request.URL.lastPathComponent];
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
    if ([path isEqualToString:@"user"]) {
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
            [[HUD hud] dismiss];
            
            NSMutableArray *peoples = [[Parser sharedParser] peopleFromArray:[(NSDictionary *)obj objectForKey:@"data"]];
            
            [self.members addObjectsFromArray:peoples];
            [_gridView.tableView reloadData];
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
    [_members release];
    [_party release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
