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

@implementation SearchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
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
    UIView *startView = [[UIView alloc] init];
    [self addSubview:startView];
    startView.backgroundColor = [UIColor whiteColor];
    
    [startView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineImageView.mas_right).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.height.mas_equalTo(40);
        make.centerY.equalTo(self.mas_centerY).with.offset(-20 - 3);
    }];
    
    self.startLocation = [[UITextField alloc] init];
    [startView addSubview:self.startLocation];
    self.startLocation.placeholder = @"起始位置";
    
    [self.startLocation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerY.centerX.equalTo(startView);
    }];
    
    
#pragma mark - endView
    UIView *endView = [[UIView alloc] init];
    [self addSubview:endView];
    endView.backgroundColor = [UIColor whiteColor];
    
    [endView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineImageView.mas_right).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.height.mas_equalTo(40);
        make.centerY.equalTo(self.mas_centerY).with.offset(20 + 3);
    }];
    
    self.finishLocation = [[UITextField alloc] init];
    [endView addSubview:self.finishLocation];
    self.finishLocation.placeholder = @"结束位置";
    
    [self.finishLocation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerY.centerX.equalTo(endView);
    }];
}

@end
