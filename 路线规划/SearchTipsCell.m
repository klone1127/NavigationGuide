//
//  SearchTipsCell.m
//  路线规划
//
//  Created by jgrm on 2017/4/10.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import "SearchTipsCell.h"

@implementation SearchTipsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configSearchTipsCell:(AMapTip *)tip {
    NSString *showString;
    if (tip.district == nil || [tip.district isEqualToString:@""]) {
        showString = [NSString stringWithFormat:@"%@", tip.name];
    } else {
        showString = [NSString stringWithFormat:@"%@·%@", tip.name, tip.district];
    }
    self.locationName.text = showString;
    self.location.text = tip.address;
#warning TODO - 添加距离
    self.distanceLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
