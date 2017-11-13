//
//  SearchViewController.h
//  路线规划
//
//  Created by jgrm on 2017/4/5.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MapSearchInitializer.h"
#import "SearchTipsCell.h"
#import "SearchView.h"

@interface SearchViewController : BaseViewController

@property (nonatomic, strong)UITableView        *searchTipsTableView;
@property (nonatomic, strong)NSMutableArray     *tipsArray;
@property (nonatomic, strong)id                 currentTextfield;
@property (nonatomic, strong)SearchView         *searchView;
@property (assign, nonatomic) CLLocationCoordinate2D startCoordinate; //起始点经纬度
@property (assign, nonatomic) CLLocationCoordinate2D destinationCoordinate; //终点经纬度
@property (nonatomic, copy)NSString             *recognitionString;

- (void)transitRouteSearchWithStartCoordinate:(CLLocationCoordinate2D)startCoordinate DestinationCoordinate:(CLLocationCoordinate2D)destinationCoordinate;

@end
