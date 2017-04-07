//
//  BusLineDetailCell.m
//  路线规划
//
//  Created by jgrm on 2017/4/6.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import "BusLineDetailCell.h"

@implementation BusLineDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configBusLineDetailCell:(AMapBusLine *)busLine {
    self.busNameLabel.text = busLine.name;
    self.originStationLabel.text = busLine.departureStop.name;
    self.destinationStationLabel.text = busLine.arrivalStop.name;
    self.otherBusLineBut.hidden = YES;
    self.anotherLineTipsLabel.hidden = YES;
    
    [self.showStationDetailBut setAttributedTitle:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld站", busLine.viaBusStops.count + 1]] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
