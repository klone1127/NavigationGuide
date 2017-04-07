//
//  WalkCell.m
//  路线规划
//
//  Created by jgrm on 2017/4/6.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import "WalkCell.h"

@implementation WalkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configWalkCell:(AMapStep *)mapStep {
    self.walkDetailLabel.text = [NSString stringWithFormat:@"%@ 约%@", mapStep.instruction, [NSDate showTimeWithSec:mapStep.duration]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
