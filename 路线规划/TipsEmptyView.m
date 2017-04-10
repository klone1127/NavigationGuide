//
//  TipsEmptyView.m
//  路线规划
//
//  Created by jgrm on 2017/4/10.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import "TipsEmptyView.h"

@implementation TipsEmptyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self showEmptyTips];
    }
    return self;
}

- (void)showEmptyTips {
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    [self addSubview:label];
    
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"无相关结果，请重新输入";
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
