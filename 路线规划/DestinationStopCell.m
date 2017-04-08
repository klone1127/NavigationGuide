//
//  DestinationStopCell.m
//  路线规划
//
//  Created by jgrm on 2017/4/8.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import "DestinationStopCell.h"

@implementation DestinationStopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configCellWithModel:(DestinationStopModel *)model {
    self.DestinationStopLabel.text = model.arrivalStop;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
