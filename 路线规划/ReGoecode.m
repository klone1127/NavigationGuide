//
//  ReGoecode.m
//  路线规划
//
//  Created by jgrm on 2017/4/6.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import "ReGoecode.h"

@interface ReGoecode ()<AMapSearchDelegate>

@property (nonatomic, strong)AMapSearchAPI  *search;

@end

@implementation ReGoecode

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initMapSearch];
    }
    return self;
}

- (void)initMapSearch {
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
}


/**
 逆地理编码

 @param coordinate
 */
- (void)reGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate {
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location                    = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [self.search AMapReGoecodeSearch:regeo];
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"geoCode request:%@ \n geoCode error:%@", request, error);
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    
    self.geoCodeResponseBlock(response.regeocode.formattedAddress);
}

@end
