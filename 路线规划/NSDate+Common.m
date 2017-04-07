//
//  NSDate+Common.m
//  路线规划
//
//  Created by jgrm on 2017/4/7.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import "NSDate+Common.h"

@implementation NSDate (Common)

+ (NSString *)showTimeWithSec:(NSInteger)duration {
    
    if (duration < 60) {
        return [NSString stringWithFormat:@"%ld秒", duration];
    } else if(duration >= 60 && duration < 3600) {
        NSInteger min = duration / 60;
        NSInteger sec = duration % 60;
        NSString *showTime;
        if (sec == 0) {
            showTime = [NSString stringWithFormat:@"%ld分钟", min];
        } else {
            showTime = [NSString stringWithFormat:@"%ld分钟%ld秒", min, sec];
        }
        return showTime;
    } else {
        NSInteger hour = duration / 3600;
        NSInteger min = duration / 60;
        NSInteger sec = duration % 60;
        NSString *showTime;
        if (min == 0 && sec == 0) {
            showTime = [NSString stringWithFormat:@"%ld小时", hour];
        } else if (min == 0 && sec != 0) {
            showTime = [NSString stringWithFormat:@"%ld小时%ld分钟%ld秒", hour, min, sec];
        } else if (min != 0 && sec == 0) {
            showTime = [NSString stringWithFormat:@"%ld小时%ld分钟", hour, min];
        }
        return showTime;
    }
    
}






@end
