//
//  BusLineDetailCell.h
//  路线规划
//
//  Created by jgrm on 2017/4/6.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusLineDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *busNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *originStationLabel;
@property (weak, nonatomic) IBOutlet UIButton *otherBusLineBut;
@property (weak, nonatomic) IBOutlet UILabel *destinationStationLabel;
@property (weak, nonatomic) IBOutlet UIButton *showStationDetailBut;
@property (weak, nonatomic) IBOutlet UILabel *anotherLineTipsLabel;

@end
