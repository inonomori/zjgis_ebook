//
//  mapViewController.m
//  zjgis_mapBook
//
//  Created by Zhefu Wang on 13-4-1.
//  Copyright (c) 2013年 zjgis. All rights reserved.
//

#import "mapViewController.h"
#import "ToolBox.h"

#define SYMBOLSHIFT_OFFSET 350

@interface mapViewController ()

@property (weak, nonatomic) IBOutlet UIView *toolbarView;

@end

@implementation mapViewController

@synthesize mapView = _mapView;
@synthesize delegate = _delegate;
@synthesize graphicSymbolView = _graphicSymbolView;
@synthesize graphicSymbolImageView = _graphicSymbolImageView;
@synthesize showSymbolButton = _showSymbolButton;
@synthesize pageIndex = _pageIndex;
@synthesize isGraphicSymbolShowed = _isGraphicSymbolShowed;
@synthesize xyLabel = _xyLabel;
@synthesize buttonTag = _buttonTag;
@synthesize toolbarView = _toolbarView;
@synthesize mapTitle = _mapTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib
{
    self.isGraphicSymbolShowed = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.graphicSymbolView.layer.cornerRadius = 20.0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCenterLabel) name:@"MapDidEndPanning" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCenterLabel) name:@"MapDidEndZooming" object:nil];
    self.toolbarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"toolbarBackground.png"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.view bringSubviewToFront:self.graphicSymbolView];
    [self.view bringSubviewToFront:self.xyLabel];
    [self.view bringSubviewToFront:self.toolbarView];
    
    NSArray *pageData = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pageList" ofType:@"plist"]] objectForKey:@"pageList"];
    NSDictionary *buttonDic = [[[pageData objectAtIndex:self.pageIndex] objectForKey:@"mapButtons"] objectAtIndex:self.buttonTag];
    self.graphicSymbolImageView.image = [UIImage imageNamed:[buttonDic objectForKey:@"graphicSymbol"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MapDidEndPanning" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MapDidEndZooming" object:nil];
}


- (void)updateCenterLabel
{
    AGSPoint* centerPoint = [self.mapView toMapPoint:self.mapView.center];
    self.xyLabel.text = [NSString stringWithFormat:@"%.4f  %.4f  %.8f",centerPoint.x,centerPoint.y,self.mapView.mapScale];
}

- (IBAction)showSymbolButtonTouched:(UIButton *)sender
{
    if (!self.isGraphicSymbolShowed) //show it
    {
        self.graphicSymbolView.backgroundColor = [UIColor whiteColor];
        [UIView animateWithDuration:0.6
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.graphicSymbolView.frame = CGRectOffset(self.graphicSymbolView.frame, 0, -SYMBOLSHIFT_OFFSET);
                         }
                         completion:^(BOOL finished)
        {
            if (finished)
            {
                self.isGraphicSymbolShowed = YES;
                [self.showSymbolButton setImage:[UIImage imageNamed:@"downArrow.png"] forState:UIControlStateNormal];
            }
        }];
    }
    else //hide it
    {
        self.isGraphicSymbolShowed = NO;
        [UIView animateWithDuration:0.6
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.graphicSymbolView.frame = CGRectOffset(self.graphicSymbolView.frame, 0, SYMBOLSHIFT_OFFSET);
                         }
                         completion:^(BOOL finished)
         {
             if (finished){
                 [self.showSymbolButton setImage:[UIImage imageNamed:@"upArrow.png"] forState:UIControlStateNormal];
                 self.graphicSymbolView.backgroundColor = [UIColor clearColor];
             }
         }];
    }
}

- (IBAction)symbolViewSwipeDownHandler:(id)sender
{
    self.isGraphicSymbolShowed = NO;
    [UIView animateWithDuration:0.6
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.graphicSymbolView.frame = CGRectOffset(self.graphicSymbolView.frame, 0, SYMBOLSHIFT_OFFSET);
                     }
                     completion:^(BOOL finished)
     {
         if (finished){
             [self.showSymbolButton setImage:[UIImage imageNamed:@"upArrow.png"] forState:UIControlStateNormal];
             self.graphicSymbolView.backgroundColor = [UIColor clearColor];
         }
     }];
}

- (IBAction)buttonTouched:(UIButton *)sender
{
    [self.delegate dismissModalView:self];
}

#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{

}

#pragma mark mapViewTouchDelegate
- (void)mapView:(AGSMapView *)mapView didTapAndHoldAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint graphics:(NSDictionary *)graphics
{
    [self.delegate dismissModalView:self];
}

- (void)mapView:(AGSMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint graphics:(NSDictionary *)graphics
{
    if (!self.toolbarView.hidden)
    {
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.toolbarView.alpha = 0.0;
                             self.graphicSymbolView.alpha = 0.0;
                         }
                         completion:^(BOOL finished){
                             if (finished)
                             {
                                 self.toolbarView.hidden = YES;
                                 self.graphicSymbolView.hidden = YES;
                             }
                         }];
    }
    else
    {
        self.toolbarView.hidden = NO;
        self.graphicSymbolView.hidden = NO;
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.toolbarView.alpha = 1.0;
                             self.graphicSymbolView.alpha = 1.0;
                         }
                         completion:nil];
    }

}

- (void)viewDidUnload {
    [self setToolbarView:nil];
    [self setTitle:nil];
    [self setMapTitle:nil];
    [super viewDidUnload];
}
@end
