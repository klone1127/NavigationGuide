//
//  MapSearchInitializer.m
//  路线规划
//
//  Created by CF on 12/11/2017.
//  Copyright © 2017 klone1127. All rights reserved.
//

#import "MapSearchInitializer.h"

@interface MapSearchInitializer()

@property (nonatomic, strong)AMapSearchAPI  *mapSearch;

@end

@implementation MapSearchInitializer

- (id)init {
    self = [super init];
    if (self) {
        self.mapSearch = [[AMapSearchAPI alloc] init];
        self.mapSearch.delegate = self;
    }
    return self;
}

#pragma mark - amapSearch Delegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"search request:%@, error:%@", request, error);
}

- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response {
    // 在这里进行 线路规划的请求工作， 在点击 完成的时候也会获取一次编码（如果有编码不存在）
    if ([response.geocodes firstObject].location.latitude == 0) {
        return;
    }
    
    CGFloat latitude = [response.geocodes firstObject].location.latitude;
    CGFloat longitude = [response.geocodes firstObject].location.longitude;

    self.geocodeSearchDoneBlock(request, latitude, longitude);
}

// 输入提示
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response {
    self.inputTipsSearchDoneBlock(request, response);
    NSLog(@"----------------------");
    NSLog(@"tips request:%@, response:%@",request, response);
}

#pragma mark - 线路规划
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response {
    NSLog(@"routeSearchDone request:%@, response:%@", request, response);
    if (response.count == 0) { return; }
    self.routeSearchDoneBlock(response);
}

// 地址编码查询接口
- (void)mapGeocodeSearch:(AMapGeocodeSearchRequest *)mapGeocodeSearchRequest {
    [self.mapSearch AMapGeocodeSearch:mapGeocodeSearchRequest];
}

// 输入提示查询接口
- (void)mapInputTipsSearch:(AMapInputTipsSearchRequest *)mapInputTipsSearchRequest {
    [self.mapSearch AMapInputTipsSearch:mapInputTipsSearchRequest];
}

// 公交路径规划查询接口
- (void)mapTransitRouteSearch:(AMapTransitRouteSearchRequest *)mapTransitRouteSearchRequest {
    [self.mapSearch AMapTransitRouteSearch:mapTransitRouteSearchRequest];
}

@end
