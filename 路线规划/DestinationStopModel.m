//
//  DestinationStopModel.m
//  路线规划
//
//  Created by jgrm on 2017/4/8.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import "DestinationStopModel.h"

@implementation DestinationStopModel

+ (DestinationStopModel *)initDestinationStopModelWithBusLine:(AMapBusLine *)busLine {
    NSError *error;
    NSDictionary *dic = @{@"arrivalStop": busLine.arrivalStop.name};
    DestinationStopModel *model = [[DestinationStopModel alloc] initWithDictionary:dic error:&error];
    if (error) {
        NSLog(@"DestinationStopModel error:%@", error);
    }
    
    return model;
}

@end
