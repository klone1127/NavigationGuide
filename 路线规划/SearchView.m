//
//  SearchView.m
//  路线规划
//
//  Created by jgrm on 2017/4/5.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import "SearchView.h"
#import "Masonry.h"

#define kLineImageW     20
#define kLineImageH     kLineImageW

#define kStartViewH     40
#define kEndViewH       kStartViewH

@implementation SearchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexCode:kSearchBarColor];
        [self loadSubviews];
    }
    return self;
}

- (void)loadSubviews {
    
    UIImageView *lineImageView  = [[UIImageView alloc] init];
    [self addSubview:lineImageView];

    lineImageView.image = [UIImage imageNamed:@"路线"];
    [lineImageView sizeToFit];
    
    
    [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(11);
        make.width.mas_equalTo(kLineImageW);
        make.height.mas_equalTo(kLineImageW);
        make.top.equalTo(self.mas_centerY).with.offset(-(kLineImageW/2.0));
    }];
    
#pragma mark - startView
    UIView *startView = [self InitBackgroundView:lineImageView y:(- 20 - 3)];
    
    [self tipsLabel:startView tips:@"从"];
    
    self.startLocation = [self InitSearchTextField:startView placeHolder:@"起始位置"];
    
    
#pragma mark - endView
    UIView *endView = [self InitBackgroundView:lineImageView y:(20 + 3)];
    [self tipsLabel:endView tips:@"到"];
    
    self.finishLocation = [self InitSearchTextField:endView placeHolder:@"结束位置"];
}

- (void)isFinshLocationEmpty:(void (^)())excuteBlock {
    if ([self.finishLocation.text isEqualToString:@""]) {
        excuteBlock();
    }
}

- (void)isStartLocationEmpty:(void (^)())excuteBlock {
    if ([self.startLocation.text isEqualToString:@""]) {
        excuteBlock();
    }
}

- (UITextField *)InitSearchTextField:(UIView *)superView placeHolder:(NSString *)string {
    UITextField *textField = [[UITextField alloc] init];
    [superView addSubview:textField];
    textField.placeholder = string;
    textField.textColor = [UIColor colorWithHexCode:KSearchBarTextColor];
    textField.backgroundColor = [UIColor colorWithHexCode:kSearchLabelColor];
    textField.clearButtonMode = UITextFieldViewModeAlways;
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.height.equalTo(superView);
        make.left.mas_equalTo(kEndViewH);
    }];
    
    return textField;
}

- (UIView *)InitBackgroundView:(UIImageView *)lineImageView y:(NSInteger)y {
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
    view.backgroundColor = [UIColor whiteColor];
    view.backgroundColor = [UIColor colorWithHexCode:kSearchLabelColor];
    [self showRoundView:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineImageView.mas_right).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.height.mas_equalTo(kStartViewH);
        make.centerY.equalTo(self.mas_centerY).with.offset(y);
    }];
    
    return view;
}

- (void)showRoundView:(UIView *)view {
    view.layer.cornerRadius = 3.0;
    view.layer.masksToBounds = YES;
}

- (void)tipsLabel:(UIView *)superView tips:(NSString *)tips {
    UILabel *label = [[UILabel alloc] init];
    [superView addSubview:label];
    label.text = tips;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHexCode:kSearchLabeltextColor];
    label.backgroundColor = [UIColor colorWithHexCode:kSearchLabelColor];
    [self showRoundView:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(superView);
        make.width.mas_equalTo(kStartViewH);
    }];
}

- (BOOL)matchStartLocation:(NSString *)string  {
    return [string isEqualToString:self.startLocation.text];
}

- (BOOL)matchFinishLocation:(NSString *)string  {
    return [string isEqualToString:self.finishLocation.text];
}

@end
