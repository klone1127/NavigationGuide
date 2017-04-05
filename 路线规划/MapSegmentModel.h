//
//  MapSegmentModel.h
//  路线规划
//
//  Created by jgrm on 2017/4/5.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MapSegmentModel : JSONModel

///此路段步行导航信息
@property (nonatomic, strong) AMapWalking  *walking;
///此路段可供选择的不同公交线路 AMapBusLine 数组
@property (nonatomic, strong) NSArray<AMapBusLine *> *buslines;
///出租车信息，跨城时有效
@property (nonatomic, strong) AMapTaxi     *taxi;
///火车信息，跨城时有效
@property (nonatomic, strong) AMapRailway  *railway;
///入口名称
@property (nonatomic, copy)   NSString     *enterName;
///入口经纬度
@property (nonatomic, copy)   AMapGeoPoint *enterLocation;
///出口名称
@property (nonatomic, copy)   NSString     *exitName;
///出口经纬度
@property (nonatomic, copy)   AMapGeoPoint *exitLocation;

@end
