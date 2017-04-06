//
//  RouteMapDetailViewController.h
//  路线规划
//
//  Created by jgrm on 2017/4/6.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import "BaseViewController.h"
@class AMapTransit;
@class AMapRoute;

@interface RouteMapDetailViewController : BaseViewController

@property (nonatomic, copy)NSString             *originLocation;
@property (nonatomic, copy)NSString             *destinationLocation;

@property (nonatomic, strong)AMapRoute          *mapRoute;
@property (nonatomic, strong)AMapTransit        *mapTransit;
@end
