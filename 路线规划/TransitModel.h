//
//  TransitModel.h
//  路线规划
//
//  Created by jgrm on 2017/4/5.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import <UIKit/UIKit.h>
#import "MapSegmentModel.h"

@interface TransitModel : JSONModel

///此公交方案价格（单位：元）
@property (nonatomic, assign)CGFloat    cost;
///此换乘方案预期时间（单位：秒）
@property (nonatomic, assign)NSInteger  duration;
///是否是夜班车
@property (nonatomic, assign)BOOL       nightflag;
///此方案总步行距离（单位：米）
@property (nonatomic, assign)NSInteger  walkingDistance;
///换乘路段 AMapSegment 数组
@property (nonatomic, strong)NSArray<MapSegmentModel *> *segments;
///当前方案的总距离
@property (nonatomic, assign)NSInteger  distance;

@end
