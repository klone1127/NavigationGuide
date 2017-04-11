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

- (void)hideNavigationBar;

- (void)showNavigationBar;

/**
 自定义 NavigationBar，

 @param viewColor viewColor
 @param title 标题
 @return view
 */
- (UIView *)navigationBarViewWithColor:(NSString *)viewColor title:(NSString *)title;

@end
