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
    [self showDetailButton:[model.stopCount integerValue]];
    [self currentTransport:model.type];
}

// TODO: - 升级为整体换肤(类似高德公交和地铁显示)
- (void)currentTransport:(NSString *)type {
    if ([type isEqualToString:@"地铁线路"]) {
        [self showRailwayStationView];
    } else {
        [self showBusStationView];
    }
}

- (void)showDetailButton:(NSInteger)stopCount {
    if (stopCount <= 1) {
        self.showStopBtn.hidden = YES;
    } else {
        self.showStopBtn.hidden = NO;
    }
}

- (void)showRailwayStationView {
    self.busImageView.image = [UIImage imageNamed:@"地铁"];
}

- (void)showBusStationView {
    self.busImageView.image = [UIImage imageNamed:@"城市公交"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
