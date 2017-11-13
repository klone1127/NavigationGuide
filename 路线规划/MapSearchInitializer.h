//
//  MapSearchInitializer.h
//  路线规划
//
//  Created by CF on 12/11/2017.
//  Copyright © 2017 klone1127. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMapSearchKit/AMapSearchKit.h"

typedef void(^onGeocodeSearchDoneBlock)(AMapGeocodeSearchRequest *request, CGFloat latitude, CGFloat longitude);
typedef void(^onInputTipsSearchDoneBlock)(AMapInputTipsSearchRequest *request, AMapInputTipsSearchResponse *response);
typedef void(^onRouteSearchDoneBlock)(AMapRouteSearchResponse *response);

@interface MapSearchInitializer : NSObject<AMapSearchDelegate>

@property (nonatomic, copy) onGeocodeSearchDoneBlock geocodeSearchDoneBlock; // 地理编码查询回调
@property (nonatomic, copy) onInputTipsSearchDoneBlock  inputTipsSearchDoneBlock; // 输入提示查询回调
@property (nonatomic, copy) onRouteSearchDoneBlock  routeSearchDoneBlock; // 路径规划查询回调

- (id)init;

// 地址编码查询接口
- (void)mapGeocodeSearch:(AMapGeocodeSearchRequest *)mapGeocodeSearchRequest;

// 输入提示查询接口
- (void)mapInputTipsSearch:(AMapInputTipsSearchRequest *)mapInputTipsSearchRequest;

// 公交路径规划查询接口
- (void)mapTransitRouteSearch:(AMapTransitRouteSearchRequest *)mapTransitRouteSearchRequest;


/**
 发起线路规划

 @param startCoordinate 起点
 @param destinationCoordinate 终点
 @param configuration 配置
 */
- (void)transitRouteSearchWithStartCoordinate:(CLLocationCoordinate2D)startCoordinate DestinationCoordinate:(CLLocationCoordinate2D)destinationCoordinate configurationBlock:(void(^)(AMapTransitRouteSearchRequest *request))configuration;

@end
