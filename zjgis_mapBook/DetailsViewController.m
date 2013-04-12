//
//  DetailsViewController.m
//  zjgis_mapBook
//
//  Created by Zhefu Wang on 13-4-2.
//  Copyright (c) 2013年 zjgis. All rights reserved.
//

#import "DetailsViewController.h"
#import "ToolBox.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

@synthesize imageView = _imageView;
@synthesize delegate = _delegate;
@synthesize buttonTag = _buttonTag;
@synthesize pageIndex = _pageIndex;

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
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    NSArray *pageData = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pageList" ofType:@"plist"]] objectForKey:@"pageList"];
    NSDictionary *buttonDic = [[[pageData objectAtIndex:self.pageIndex] objectForKey:@"customButtons"] objectAtIndex:self.buttonTag];
    self.imageView.image = [UIImage imageNamed:[buttonDic objectForKey:@"image"]];
    self.view.backgroundColor = [UIColor clearColor];
    self.imageView.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)singleTapHandler:(id)sender
{
    [self.delegate dismissModalView:self];
}

@end
