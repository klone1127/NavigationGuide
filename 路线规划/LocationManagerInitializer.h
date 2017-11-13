//
//  LocationManagerInitializer.h
//  路线规划
//
//  Created by CF on 12/11/2017.
//  Copyright © 2017 klone1127. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapLocationKit/AMapLocationKit.h>

typedef void(^LocationManagerBlock)(CLLocation *location, AMapLocationReGeocode *reGeocode);

@interface LocationManagerInitializer : NSObject

@property (nonatomic, copy) LocationManagerBlock locationManagerBlock;


- (id)init;
/**
 开始定位
 */
-(void)startLocation;

@end
