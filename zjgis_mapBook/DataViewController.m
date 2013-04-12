//
//  DataViewController.m
//  zjgis_mapBook
//
//  Created by Zhefu Wang on 13-3-26.
//  Copyright (c) 2013年 zjgis. All rights reserved.
//

#import "DataViewController.h"
#import "ContentListTableViewController.h"
#import <ArcGIS/ArcGIS.h>
#import "mapViewController.h"
#import "ToolBox.h"
#import "DismissModalViewProtocol.h"
#import "DetailsViewController.h"
#import "macroDefinition.h"

@interface DataViewController () <UIScrollViewDelegate, UIPopoverControllerDelegate,DismissModalViewDelegate>

@end

@implementation DataViewController

@synthesize imageView = _imageView;
@synthesize pageList = _pageList;
@synthesize picIndex = _picIndex;
@synthesize contentListButton = _contentListButton;
@synthesize toolbarView = _toolbarView;
@synthesize customButton01 = _customButton01;
@synthesize customButton02 = _customButton02;
@synthesize customButton03 = _customButton03;
@synthesize customButton04 = _customButton04;
@synthesize mapButton01 = _mapButton01;
@synthesize mapButton02 = _mapButton02;
@synthesize toolBarGotoMap = _toolBarGotoMap;
@synthesize dataLabel = _dataLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pageList = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pageList" ofType:@"plist"]] objectForKey:@"pageList"];
    self.toolbarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"toolbarBackground.png"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.dataLabel.text = [NSString stringWithFormat:@"%@",[self.dataObject objectForKey:@"title"]];
    self.imageView.image = [UIImage imageNamed:[[self.pageList objectAtIndex:self.picIndex] objectForKey:@"pic"]];
    [self setupButtons];
    if (self.picIndex == 0)
        self.toolbarView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupButtons
{
    [self setupButtonWithName:@"customButton01" buttonIndex:0];
    [self setupButtonWithName:@"customButton02" buttonIndex:1];
    [self setupButtonWithName:@"customButton03" buttonIndex:2];
    [self setupButtonWithName:@"customButton04" buttonIndex:3];
    [self setupButtonWithName:@"mapButton01" buttonIndex:0];
    [self setupButtonWithName:@"mapButton02" buttonIndex:1];
}

- (void)setupButtonWithName:(NSString*)buttonName buttonIndex:(NSInteger)index
{
    UIButton *button = (UIButton*)[self valueForKey:buttonName];
    NSString *className = [[buttonName stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]] stringByAppendingString:@"s"];
    NSArray *buttonArry = [[self.pageList objectAtIndex:self.picIndex] objectForKey:className];
    if (!buttonArry || [buttonArry count] < index + 1)
    {
        button.hidden = YES;
        return;
    }
    
    
    NSDictionary *buttonDic = [buttonArry objectAtIndex:index];
    button.hidden = NO;
    button.frame = CGRectMake([[[buttonDic objectForKey:@"frame"] objectForKey:@"x"] floatValue],[[[buttonDic objectForKey:@"frame"] objectForKey:@"y"] floatValue],[[[buttonDic objectForKey:@"frame"] objectForKey:@"width"] floatValue],[[[buttonDic objectForKey:@"frame"] objectForKey:@"height"] floatValue]);
}

#pragma mark Methods
- (IBAction)singleTapHandler:(id)sender
{
    if (self.picIndex != 0)
    {
        if (!self.toolbarView.hidden)
        {
            [UIView animateWithDuration:0.5
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.toolbarView.alpha = 0.0;
                             }
                             completion:^(BOOL finished){
                                 if (finished)
                                     self.toolbarView.hidden = YES;
                             }];
        }
        else
        {
            self.toolbarView.hidden = NO;
            [UIView animateWithDuration:0.5
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.toolbarView.alpha = 1.0;
                             }
                             completion:nil];
        }
    }
}

- (IBAction)customButtonTouched:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"detailsViewSegue" sender:sender];
}

- (IBAction)mapButtonTouched:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"mapViewSegue" sender:sender];
}

#pragma mark Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"bookContentListSegue"])
    {
        UIStoryboardPopoverSegue *popoverSegue = (UIStoryboardPopoverSegue *)segue;
        
        [segue.destinationViewController setPageList:self.pageList];
        [segue.destinationViewController setPopoverController:popoverSegue.popoverController];
    }
    else if ([segue.identifier isEqualToString:@"mapViewSegue"])
    {
        mapViewController *mapViewController = segue.destinationViewController;
        mapViewController.delegate = self;
        mapViewController.mapView = [[AGSMapView alloc] initWithFrame:CGRectMake(0, 0, [ToolBox getApplicationFrameSize].width, [ToolBox getApplicationFrameSize].height)];
        mapViewController.mapView.touchDelegate = mapViewController;
        mapViewController.mapView.calloutDelegate = mapViewController;
        mapViewController.mapView.layerDelegate = mapViewController;
        [mapViewController.view addSubview:mapViewController.mapView];
        
        mapViewController.pageIndex = self.picIndex;
        mapViewController.mapTitle.text = self.dataLabel.text;
        UIButton *button = sender;
        mapViewController.buttonTag = button.tag;
        AGSLocalTiledLayer *jhskLocalTiledLayer;
        NSDictionary *buttonDic = [[[self.pageList objectAtIndex:self.picIndex] objectForKey:@"mapButtons"] objectAtIndex:button.tag];
        jhskLocalTiledLayer = [AGSLocalTiledLayer localTiledLayerWithName:[buttonDic objectForKey:@"tpk"]];
        UIView<AGSLayerView> *jhlyrView = [mapViewController.mapView addMapLayer:jhskLocalTiledLayer withName:@"地图"];
        

        
        [mapViewController.mapView zoomToEnvelope:jhskLocalTiledLayer.fullEnvelope animated:YES];
        
        NSDictionary *centerPointDic = [buttonDic objectForKey:CENTER_POINT];
        
        [mapViewController.mapView zoomToScale:[[buttonDic objectForKey:@"zoomToScale"] floatValue] withCenterPoint:(centerPointDic)?[[AGSPoint alloc] initWithX:[[centerPointDic objectForKey:@"x"] floatValue] y:[[centerPointDic objectForKey:@"y"] floatValue] spatialReference:mapViewController.mapView.spatialReference]:nil animated:YES];
        
        jhlyrView.drawDuringZooming = YES;
        jhlyrView.drawDuringPanning = YES;
    }
    else if ([segue.identifier isEqualToString:@"detailsViewSegue"])
    {
        UIButton *button = sender;
        DetailsViewController *detailsViewController = segue.destinationViewController;

        detailsViewController.buttonTag = button.tag;
        detailsViewController.delegate = self;
        detailsViewController.pageIndex = self.picIndex;
    }
}

#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
}

#pragma mark mapViewController Delegate
- (void)dismissModalView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)viewDidUnload {
    [self setToolBarGotoMap:nil];
    [super viewDidUnload];
}
@end
