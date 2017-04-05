//
//  MapBusLineModel.h
//  路线规划
//
//  Created by jgrm on 2017/4/5.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MapGeoPoint.h"
#import "MapBusStopModel.h"

@interface MapBusLineModel : JSONModel

///公交线路ID
@property (nonatomic, copy) NSString     *uid;
///公交类型
@property (nonatomic, copy) NSString     *type;
///公交线路名称
@property (nonatomic, copy) NSString     *name;
///坐标集合
@property (nonatomic, copy) NSString     *polyline;
///城市编码
@property (nonatomic, copy) NSString     *citycode;
///首发站
@property (nonatomic, copy) NSString     *startStop;
///终点站
@property (nonatomic, copy) NSString     *endStop;
///当查询公交站点时，返回的 AMapBusLine 中含有该字段
@property (nonatomic, copy) MapGeoPoint *location;

///首班车时间
@property (nonatomic, copy)   NSString *startTime;
///末班车时间
@property (nonatomic, copy)   NSString *endTime;
///所属公交公司
@property (nonatomic, copy)   NSString *company;
///距离。在公交线路查询时，该值为此线路的全程距离，单位为千米; 在公交路径规划时，该值为乘坐此路公交车的行驶距离，单位为米
@property (nonatomic, assign) CGFloat distance;
///起步价
@property (nonatomic, assign) CGFloat basicPrice;
///全程票价
@property (nonatomic, assign) CGFloat totalPrice;
///矩形区域左下、右上顶点坐标
//@property (nonatomic, copy)   AMapGeoPolygon *bounds;
///本线路公交站 AMapBusStop 数组
@property (nonatomic, strong) NSMutableArray<MapBusStopModel *> *busStops;

///起程站
@property (nonatomic, strong) MapBusStopModel *departureStop;
///下车站
@property (nonatomic, strong) MapBusStopModel *arrivalStop;
///途径公交站 AMapBusStop 数组
@property (nonatomic, strong) NSMutableArray<MapBusStopModel *> *viaBusStops;
///预计行驶时间（单位：秒）
@property (nonatomic, assign) NSInteger duration;

@end
