//
//  SearchTipsCell.h
//  路线规划
//
//  Created by jgrm on 2017/4/10.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface SearchTipsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *locationName;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

- (void)configSearchTipsCell:(AMapTip *)tip;

@end
