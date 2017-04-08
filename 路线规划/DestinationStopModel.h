//
//  DestinationStopModel.h
//  路线规划
//
//  Created by jgrm on 2017/4/8.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface DestinationStopModel : JSONModel

@property (nonatomic, copy)NSString                   *arrivalStop;
@property (nonatomic, copy)NSString<Optional>         *otherStop;
#warning TODO - 添加其他可乘路线


/**
 初始化到达站数据

 @param busLine busline
 @return DestinationStopModel
 */
+ (DestinationStopModel *)initDestinationStopModelWithBusLine:(AMapBusLine *)busLine;
@end
