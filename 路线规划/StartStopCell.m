//
//  StartStopCell.m
//  路线规划
//
//  Created by jgrm on 2017/4/8.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import "StartStopCell.h"

@implementation StartStopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configStartStopCellWithModel:(StartStopModel *)model {
    self.ShowStaionLabel.text = model.staion;
    self.StartStopLabel.text = model.departureStop;
#warning TODO - busTime 使用 attributedText
    self.busTimeLabel.text = model.busTime;
    self.StopsCountLabel.text = [NSString stringWithFormat:@"%@站", model.stopCount];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
