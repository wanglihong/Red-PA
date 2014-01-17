//
//  PersonInfoViewController.m
//  Red-PA
//
//  Created by Dennis Yang on 12-9-10.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "PersonInfoViewController.h"

#import "UpdatePersonInfoViewController.h"

@interface PersonInfoViewController ()

@end

@implementation PersonInfoViewController

@synthesize people = _people;
@synthesize CAN_UPDATE;

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
	
    _firstTitleLabel.text = @"个人资料";
    
    if (!CAN_UPDATE) {
        _updateButton.hidden = YES;
    }
    
    [self setInfo:self.people];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.people.peopleId isEqual:[User currentUser].people.peopleId]) {
        [self setInfo:[User currentUser].people];
    }
}

- (void)setInfo:(People *)pop
{
    NSString *imgURL = [NSString stringWithFormat:@"%@/gridfs/%@", BASE_URL_STRING, pop.peopleHeaderURL];
    [_header setImageWithURL:[NSURL URLWithString:imgURL]
            placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    _nameLabel.text = pop.peopleNickName;
    _univLabel.text = pop.peopleUniversity;
    _depaLabel.text = pop.peopleDepartment;
    _qqLabel.text   = pop.peopleQQ;
    _emailLabel.text= pop.peopleEmail;
    _dateLabel.text = pop.peopleRealName;
    _infoLabel.text = pop.peopleInformation;
    
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size = [_infoLabel.text sizeWithFont:font
                              constrainedToSize:CGSizeMake(150.0f, 1000.0f)
                                  lineBreakMode:UILineBreakModeWordWrap];
    CGRect oldRect = _infoLabel.frame;
    float  hight = size.height > oldRect.size.height ? (size.height + 20) : oldRect.size.height ;
    CGRect newRect = CGRectMake(oldRect.origin.x, oldRect.origin.y, oldRect.size.width, hight);
    
    _infoLabel.frame = newRect;
    _infoBg.frame = CGRectMake(0, 253, 226, 71 + hight);
    NSLog(@"%f", _infoBg.frame.origin.y + _infoBg.frame.size.height + 12);
    _updateButton.frame = CGRectMake(0, _infoBg.frame.origin.y + _infoBg.frame.size.height + 12, 226, 37);
    _scrollView.contentSize = CGSizeMake(226, _updateButton.frame.origin.y + 100);
}

- (IBAction)update
{
    UpdatePersonInfoViewController *viewController = [[UpdatePersonInfoViewController alloc] initWithNibName:@"UpdatePersonInfoViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc
{
    [_people release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
