//
//  NSString+Common.m
//  路线规划
//
//  Created by CF on 2017/11/2.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import "NSString+Common.h"

@implementation NSString (Common)

+ (NSString *)showTime:(NSString *)string {
    if (string.length == 4) {
        NSMutableString *tempString = [NSMutableString stringWithString:string];
        [tempString insertString:@":" atIndex:2];
        return tempString;
    }
    
    return @"";
}

@end
