//
//  ContentListTableViewController.h
//  zjgis_mapBook
//
//  Created by Zhefu Wang on 13-3-27.
//  Copyright (c) 2013年 zjgis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentListTableViewController : UITableViewController

@property (nonatomic, strong) NSArray* pageList;
@property (nonatomic, strong) UIPopoverController* popoverController;

@end
