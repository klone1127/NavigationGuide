//
//  MapWalkingModel.h
//  
//
//  Created by jgrm on 2017/4/5.
//
//

#import <JSONModel/JSONModel.h>
#import "MapGeoPoint.h"
#import "MapStepModel.h"

@interface MapWalkingModel : JSONModel

///起点坐标
@property (nonatomic, copy)   MapGeoPoint *origin;
///终点坐标
@property (nonatomic, copy)   MapGeoPoint *destination;
///起点和终点的步行距离
@property (nonatomic, assign) NSInteger     distance;
///步行预计时间
@property (nonatomic, assign) NSInteger     duration;
///步行路段 AMapStep 数组
@property (nonatomic, strong) NSMutableArray<MapStepModel *> *steps;

@end
