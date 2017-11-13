//
//  BaseViewController.h
//  路线规划
//
//  Created by jgrm on 2017/4/6.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic, strong)UIButton       *locationButton;
@property (nonatomic, strong)UIButton       *speedButton;

- (void)hideNavigationBar;

- (void)showNavigationBar;

- (void)setStatusBarBackgroundColor:(UIColor *)color;

/**
 自定义 NavigationBar，

 @param viewColor viewColor
 @param title 标题
 @return view
 */
- (UIView *)navigationBarViewWithColor:(NSString *)viewColor title:(NSString *)title;

/**
 自定义 NavigationBar

 @param viewColor 颜色
 @return
 */
- (UIView *)navigationBarView:(NSString *)viewColor;

/**
 带返回按钮

 @param viewColor 颜色
 */
- (UIView *)navigationBarViewWithBackButton:(NSString *)viewColor;

/**
 隐藏语音识别按钮
 */
- (void)hideSpeedButton;


/**
 显示语音识别按钮
 */
- (void)showSpeedButton;

@end
