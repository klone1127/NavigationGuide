//
//  LocationManagerInitializer.m
//  路线规划
//
//  Created by CF on 12/11/2017.
//  Copyright © 2017 klone1127. All rights reserved.
//

#import "LocationManagerInitializer.h"

@interface LocationManagerInitializer()<AMapLocationManagerDelegate>

@property (nonatomic, strong) AMapLocationManager    *locationManager;

@end

@implementation LocationManagerInitializer

- (id)init {
    self = [super init];
    if (self) {
        self.locationManager = [[AMapLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 10;
        self.locationManager.locatingWithReGeocode = YES; // 返回逆地理信息(仅限国内)
        
        [self.locationManager setPausesLocationUpdatesAutomatically:NO];
        if ([UIDevice currentDevice].systemVersion.floatValue >= 9) {
            self.locationManager.allowsBackgroundLocationUpdates = YES;
        }
    }
    return self;
}

-(void)startLocation {
    // 持续返回逆地理编码信息
    [self.locationManager setLocatingWithReGeocode:YES];
    [self.locationManager startUpdatingLocation];
}

#pragma mark - 定位 delegate
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode {
    // 初始位置默认显示 -> 我的位置
    self.locationManagerBlock(location, reGeocode);
}
- (void)amapLocationManager:(AMapLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [self showNoAuthorizedTips:status];
    NSLog(@"定位权限改变！！！");
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"locationManager error:%@", error);
}

/**
 授权提示

 @param status
 */
- (void)showNoAuthorizedTips:(CLAuthorizationStatus)status {
    if ( status == kCLAuthorizationStatusNotDetermined || status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您还没有授权使用定位" message:@"请前往设置授权" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"好的"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  // TODO: 改为跳转？
                                                              }];
        
        
        [alertController addAction:cancelAction];
        [alertController addAction:defaultAction];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
}

@end
