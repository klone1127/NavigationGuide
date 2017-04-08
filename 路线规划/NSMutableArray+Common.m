//
//  NSMutableArray+Common.m
//  路线规划
//
//  Created by jgrm on 2017/4/8.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import "NSMutableArray+Common.h"

@implementation NSMutableArray (Common)

- (void)insertArray:(NSArray *)array atIndex:(NSInteger)index {
    for (int i = 0; i < array.count; i++) {
        [self insertObject:array[i] atIndex:(index + 1)];
        index++;
    }
}

@end
