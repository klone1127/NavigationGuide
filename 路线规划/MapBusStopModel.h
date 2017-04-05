//
//  MapBusStopModel.h
//  路线规划
//
//  Created by jgrm on 2017/4/5.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MapGeoPoint.h"

#import "MapBusLineModel.h"

@interface MapBusStopModel : JSONModel

///公交站点ID
@property (nonatomic, copy)   NSString     *uid;
///区域编码
@property (nonatomic, copy)   NSString     *adcode;
///公交站名
@property (nonatomic, copy)   NSString     *name;
///城市编码
@property (nonatomic, copy)   NSString     *citycode;
///经纬度坐标
@property (nonatomic, copy)   MapGeoPoint *location;
///途径此站的公交路线 AMapBusLine 数组
//@property (nonatomic, strong) NSMutableArray<MapBusLineModel *> *buslines;
///查询公交线路时的第几站
@property (nonatomic, copy)   NSString *sequence;

@end
