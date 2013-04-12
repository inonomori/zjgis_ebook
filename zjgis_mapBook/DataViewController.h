//
//  DataViewController.h
//  zjgis_mapBook
//
//  Created by Zhefu Wang on 13-3-26.
//  Copyright (c) 2013年 zjgis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) id dataObject;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,strong) NSArray *pageList;
@property (nonatomic) NSInteger picIndex;
@property (weak, nonatomic) IBOutlet UIButton *contentListButton;
@property (weak, nonatomic) IBOutlet UIView *toolbarView;
@property (weak, nonatomic) IBOutlet UIButton *customButton01;
@property (weak, nonatomic) IBOutlet UIButton *customButton02;
@property (weak, nonatomic) IBOutlet UIButton *customButton03;
@property (weak, nonatomic) IBOutlet UIButton *customButton04;
@property (weak, nonatomic) IBOutlet UIButton *mapButton01;
@property (weak, nonatomic) IBOutlet UIButton *mapButton02;
@property (weak, nonatomic) IBOutlet UIButton *toolBarGotoMap;

@end
