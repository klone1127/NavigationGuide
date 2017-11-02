//
//  StartStopModel.m
//  路线规划
//
//  Created by jgrm on 2017/4/8.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import "StartStopModel.h"
#import "NSString+Common.h"

@implementation StartStopModel

+ (StartStopModel *)initStartStopModelWithBusLine:(AMapBusLine *)busLine {
    NSError *error;
    
    NSString *busTime = [NSString stringWithFormat:@"线路  首班 %@  末班 %@", [NSString showTime:busLine.startTime], [NSString showTime:busLine.endTime]];
    NSString *stopCount = [NSString stringWithFormat:@"%ld", busLine.viaBusStops.count + 1];
    NSDictionary *startStopDic = @{@"staion":busLine.name, @"departureStop": busLine.departureStop.name, @"busTime": busTime, @"stopCount": stopCount, @"viaBusStops":busLine.viaBusStops, @"type":busLine.type};
    
    StartStopModel *startStopModel = [[StartStopModel alloc] initWithDictionary:startStopDic error:&error];
    if (error) {
        NSLog(@"startStopModel error:%@", error);
    }
    return startStopModel;
}

@end
