//
//  MapGeoPoint.h
//  路线规划
//
//  Created by jgrm on 2017/4/5.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import <UIKit/UIKit.h>

@interface MapGeoPoint : JSONModel

///纬度（垂直方向）
@property (nonatomic, assign) CGFloat latitude;
///经度（水平方向）
@property (nonatomic, assign) CGFloat longitude;

@end
