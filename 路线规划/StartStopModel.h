//
//  StartStopModel.h
//  路线规划
//
//  Created by jgrm on 2017/4/8.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface StartStopModel : JSONModel

@property (nonatomic, copy)NSString         *staion;
@property (nonatomic, copy)NSString         *departureStop;
@property (nonatomic, copy)NSString         *type;      // 交通类型
@property (nonatomic, copy)NSString         *busTime;
@property (nonatomic, copy)NSString         *stopCount;
@property (nonatomic, strong)NSArray<AMapBusStop *>    *viaBusStops;

/**
 初始化 StartStopModel

 @param busLine busline
 @return StartStopModel
 */
+ (StartStopModel *)initStartStopModelWithBusLine:(AMapBusLine *)busLine;

@end
