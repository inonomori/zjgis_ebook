//
//  DetailsViewController.h
//  zjgis_mapBook
//
//  Created by Zhefu Wang on 13-4-2.
//  Copyright (c) 2013年 zjgis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DismissModalViewProtocol.h"

@interface DetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) id<DismissModalViewDelegate> delegate;
@property (nonatomic) NSInteger buttonTag;
@property (nonatomic) NSInteger pageIndex;

@end
