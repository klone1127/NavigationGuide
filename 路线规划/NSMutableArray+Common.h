//
//  NSMutableArray+Common.h
//  路线规划
//
//  Created by jgrm on 2017/4/8.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Common)


/**
 插入一个数组

 @param array 要插入的数组
 @param index 要插入的位置
 */
- (void)insertArray:(NSArray *)array atIndex:(NSInteger)index;

@end
