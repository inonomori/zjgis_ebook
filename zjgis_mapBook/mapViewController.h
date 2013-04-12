//
//  mapViewController.h
//  zjgis_mapBook
//
//  Created by Zhefu Wang on 13-4-1.
//  Copyright (c) 2013年 zjgis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import "DismissModalViewProtocol.h"



@interface mapViewController : UIViewController <AGSMapViewLayerDelegate,AGSMapViewTouchDelegate,
AGSMapViewCalloutDelegate>

@property (nonatomic, strong) AGSMapView *mapView;
@property (nonatomic, strong) id<DismissModalViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *graphicSymbolView;
@property (weak, nonatomic) IBOutlet UIButton *showSymbolButton;
@property (weak, nonatomic) IBOutlet UIImageView *graphicSymbolImageView;
@property (nonatomic) NSInteger pageIndex;
@property (nonatomic) NSInteger buttonTag;
@property (nonatomic) BOOL isGraphicSymbolShowed;
@property (weak, nonatomic) IBOutlet UILabel *xyLabel;
@property (weak, nonatomic) IBOutlet UILabel *mapTitle;

@end
