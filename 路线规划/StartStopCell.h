//
//  StartStopCell.h
//  路线规划
//
//  Created by jgrm on 2017/4/8.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StartStopModel.h"

@interface StartStopCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ShowStaionLabel;
@property (weak, nonatomic) IBOutlet UILabel *StartStopLabel;
@property (weak, nonatomic) IBOutlet UILabel *busTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *StopsCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *showStopBtn;

- (void)configStartStopCellWithModel:(StartStopModel *)model;

@end
