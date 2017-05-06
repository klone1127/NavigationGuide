//
//  UIAlertController+Common.h
//  路线规划
//
//  Created by CF on 2017/5/6.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Common)


/**
 alert 提示

 @param title
 @param message
 @param vc viewController
 */
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message controller:(UIViewController *)vc;

@end
