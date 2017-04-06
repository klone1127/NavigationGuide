//
//  ReGoecode.h
//  路线规划
//
//  Created by jgrm on 2017/4/6.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapSearchKit/AMapSearchKit.h>

typedef void(^GeoCodeResponseBlock)(NSString *address);

@interface ReGoecode : NSObject


/**
 逆地理编码

 @param coordinate
 */
- (void)reGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate;

@property (nonatomic, copy)GeoCodeResponseBlock     geoCodeResponseBlock;

@end
