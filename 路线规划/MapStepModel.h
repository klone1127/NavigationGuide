//
//  MapStepModel.h
//  路线规划
//
//  Created by jgrm on 2017/4/5.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import <UIKit/UIKit.h>

@interface MapStepModel : JSONModel

///行走指示
@property (nonatomic, copy)   NSString  *instruction;
///方向
@property (nonatomic, copy)   NSString  *orientation;
///道路名称
@property (nonatomic, copy)   NSString  *road;
///此路段长度（单位：米）
@property (nonatomic, assign) NSInteger  distance;
///此路段预计耗时（单位：秒）
@property (nonatomic, assign) NSInteger  duration;
///此路段坐标点串
@property (nonatomic, copy)   NSString  *polyline;
///导航主要动作
@property (nonatomic, copy)   NSString  *action;
///导航辅助动作
@property (nonatomic, copy)   NSString  *assistantAction;
///此段收费（单位：元）
@property (nonatomic, assign) CGFloat    tolls;
///收费路段长度（单位：米）
@property (nonatomic, assign) NSInteger  tollDistance;
///主要收费路段
@property (nonatomic, copy)   NSString  *tollRoad;

///途径城市 AMapCity 数组，只有驾车路径规划时有效
//@property (nonatomic, strong) NSArray<AMapCity *> *cities;
/////路况信息数组，只有驾车路径规划时有效
//@property (nonatomic, strong) NSArray<AMapTMC *> *tmcs;

@end
