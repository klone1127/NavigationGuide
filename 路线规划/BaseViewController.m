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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 64)];
    view.backgroundColor = [UIColor colorWithHexCode:viewColor];
    
    UIImageView *locationImageView = [[UIImageView alloc] init];
    locationImageView.image = [UIImage imageNamed:@"地址"];
    [view addSubview:locationImageView];
    [locationImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_offset(20);
        make.left.mas_equalTo(11);
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
    
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
