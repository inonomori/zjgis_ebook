//
//  ModelController.h
//  zjgis_mapBook
//
//  Created by Zhefu Wang on 13-3-26.
//  Copyright (c) 2013年 zjgis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataViewController;

@interface ModelController : NSObject <UIPageViewControllerDataSource>

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(DataViewController *)viewController;

@end
