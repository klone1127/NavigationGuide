//
//  LocationView.h
//  路线规划
//
//  Created by jgrm on 2017/4/6.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationView : UIView

@property (nonatomic, strong)UILabel    *originLocation;
@property (nonatomic, strong)UILabel    *destinationLocation;

//@property (nonatomic, copy)NSString     *originWalkDistance;
//@property (nonatomic, copy)NSString     *destinationWalkDistance;

// 初始位置
- (void)originLocation:(NSString *)location;
//- (void)showOriginLocationView:(NSString *)location walkDistance:(NSString *)distance;

// 结束位置
- (void)destinationLocation:(NSString *)location;
//- (void)showDestionationLocationView:(NSString *)location walkDistance:(NSString *)distance;

@end
