//
//  DestinationStopCell.h
//  路线规划
//
//  Created by jgrm on 2017/4/8.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DestinationStopModel.h"

@interface DestinationStopCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *OtherStationLabel;
@property (weak, nonatomic) IBOutlet UILabel *DestinationStopLabel;

- (void)configCellWithModel:(DestinationStopModel *)model;

@end
