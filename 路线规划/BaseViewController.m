//
//  BaseViewController.m
//  路线规划
//
//  Created by jgrm on 2017/4/6.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import "BaseViewController.h"
#import <Masonry.h>

#define kBarTitleLabelL         50
#define kLeft                   11

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)hideNavigationBar {
    self.navigationController.navigationBarHidden = YES;
}

- (void)showNavigationBar {
    self.navigationController.navigationBarHidden = NO;
}

- (UIView *)navigationBarViewWithColor:(NSString *)viewColor title:(NSString *)title {
    UIView *view = [self navigationBarView:viewColor];
    
    UIImageView *locationImageView = [[UIImageView alloc] init];
    locationImageView.image = [UIImage imageNamed:@"地址"];
    [view addSubview:locationImageView];
    [locationImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_offset(20);
        make.left.mas_equalTo(kLeft);
        make.centerY.equalTo(view.mas_centerY);
    }];
    
    self.locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:self.locationButton];
    [self.locationButton setTitle:@"未知城市" forState:UIControlStateNormal];
    [self.locationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.locationButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    
    [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.left.equalTo(locationImageView.mas_right);
        make.width.mas_equalTo(80);
        make.centerY.equalTo(view.mas_centerY);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    [view addSubview:label];
    label.text = title;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:17.0];
    label.textAlignment = NSTextAlignmentCenter;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(view.mas_height);
        make.left.equalTo(view.mas_left).with.offset(kBarTitleLabelL);
        make.right.equalTo(view.mas_right).with.offset(-kBarTitleLabelL);
        make.centerY.equalTo(view.mas_centerY);
    }];
    
    [self setupSpeechButtonWithSuperView:view];
    
    return view;
}

//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

- (UIView *)navigationBarView:(NSString *)viewColor {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight([UIApplication sharedApplication].statusBarFrame), kScreenSize.width, 64.0)];
    view.backgroundColor = [UIColor colorWithHexCode:viewColor];
    
    return view;
}

- (UIView *)navigationBarViewWithBackButton:(NSString *)viewColor {
    UIView *view = [self navigationBarView:viewColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [view addSubview:button];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:19.0];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.height.mas_equalTo(view.mas_height);
        make.centerY.equalTo(view.mas_centerY);
        make.width.mas_equalTo(80);
    }];
    
    return view;
}

- (void)setupSpeechButtonWithSuperView:(UIView *)view {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"语音识别" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.speechButton = button;
    [view addSubview:self.speechButton];
    
    [self.speechButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).with.offset(-kLeft);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(80);
        make.centerY.equalTo(view.mas_centerY);
    }];
    
}

- (void)hideSpeechButton {
    self.speechButton.hidden = YES;
}

- (void)showSpeechButton {
    self.speechButton.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backVC {
    if (self.navigationController == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)disabledScrollViewAutolayout:(UIScrollView *)scrollView {
    if (@available(iOS 11, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
