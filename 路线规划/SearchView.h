//
//  SearchView.h
//  路线规划
//
//  Created by jgrm on 2017/4/5.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchView : UIView
@property (nonatomic, strong)UITextField *startLocation;
@property (nonatomic, strong)UITextField *finishLocation;


/**
 finishLocation 输入是否为空

 @param excuteBlock 可执行代码
 */
- (void)isFinshLocationEmpty:(void(^)())excuteBlock;

/**
 startLocation 输入是否为空
 
 @param excuteBlock 可执行代码
 */
- (void)isStartLocationEmpty:(void(^)())excuteBlock;

- (BOOL)matchStartLocation:(NSString *)string;

- (BOOL)matchFinishLocation:(NSString *)string;

@end
