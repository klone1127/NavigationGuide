//
//  UIViewController+Common.m
//  路线规划
//
//  Created by jgrm on 2017/4/8.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import "UIViewController+Common.h"

@implementation UIViewController (Common)

- (void)removeNavigationControllerBottonLine {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexCode:kSearchBarColor]]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

@end
