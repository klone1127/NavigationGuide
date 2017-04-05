//
//  RouteModel.h
//  路线规划
//
//  Created by jgrm on 2017/4/5.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "TransitModel.h"

@interface RouteModel : JSONModel
@property (nonatomic, strong)NSMutableArray<TransitModel *>   *transits;
@end
