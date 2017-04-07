//
//  NSDate+Common.h
//  路线规划
//
//  Created by jgrm on 2017/4/7.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Common)

/**
 
 格式化时间显示
 
 @param duration 单位 s
 
 @return h/m/s
 
 */

+ (NSString *)showTimeWithSec:(NSInteger)duration;


@end
