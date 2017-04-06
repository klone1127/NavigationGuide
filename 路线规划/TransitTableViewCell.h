//
//  TransitTableViewCell.h
//  路线规划
//
//  Created by CF on 2017/4/5.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface TransitTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *transitsLabel;
@property (weak, nonatomic) IBOutlet UILabel *transitsInfoLabel;

- (void)configDataWithTranditsModel:(AMapTransit *)transit;

@end
