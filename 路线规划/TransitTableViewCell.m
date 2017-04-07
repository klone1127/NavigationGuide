//
//  TransitTableViewCell.m
//  路线规划
//
//  Created by CF on 2017/4/5.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import "TransitTableViewCell.h"

@implementation TransitTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor colorWithHexCode:@"F1F5F6"];
}

- (void)configDataWithTranditsModel:(AMapTransit *)transit {
    NSString *time = [NSDate showTimeWithSec:transit.duration];
    CGFloat cost = transit.cost;
    NSString *distance = [self showDistance:transit.walkingDistance];
    self.transitsInfoLabel.text = [NSString stringWithFormat:@"  %@ · %.f元 · %@", time, cost, distance];
    
    self.transitsLabel.text = [NSString stringWithFormat:@"  %@", [self showTransferInfo:transit]];
}

- (NSString *)showTransferInfo:(AMapTransit *)transit {
    NSString *resultString;
    NSMutableArray *buslineArray = @[].mutableCopy;
    for (AMapSegment *segment in transit.segments) {
        AMapRailway *railway = segment.railway;
        AMapTaxi *taxi = segment.taxi;
        AMapWalking *walking = segment.walking;
        AMapBusLine *busline = [segment.buslines firstObject];
        if (busline.name) {
            [buslineArray addObject:[self replaceBracketsOfBulineName:[self replaceBuslineName:busline.name]]];
        } else if (railway.uid) {
            [buslineArray addObject:railway.name];
        }
    }
    
    resultString = [buslineArray componentsJoinedByString:@" / "];
    return resultString;
}

// 替换 大站快车
- (NSString *)replaceBuslineName:(NSString *)name {
    if ([name containsString:@"大站快车"]) {
        return [name stringByReplacingOccurrencesOfString:@"大站快车" withString:@"快"];
    }
    return name;
}

// 替换 ( )
- (NSString *)replaceBracketsOfBulineName:(NSString *)name {
    // 之后使用正则替换方法
    if ([name containsString:@"("]) {
        if ([name hasSuffix:@")"]) {
            NSRange range = [name rangeOfString:@"("];
            return [name stringByReplacingCharactersInRange:NSMakeRange(range.location, name.length - range.location) withString:@""];
        }
    }
    
    return name;
}

- (NSString *)showDistance:(NSInteger)walkingDistance {
    if (walkingDistance > 1000) {
        NSInteger km = walkingDistance / 1000;
        NSInteger m = walkingDistance % 1000 / 100;
        if (m != 0) {
            return [NSString stringWithFormat:@"步行%ld.%ld公里", km, m];
        } else {
            return [NSString stringWithFormat:@"步行%ld公里", km];
        }
    } else {
        return [NSString stringWithFormat:@"步行%ld米", walkingDistance];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
