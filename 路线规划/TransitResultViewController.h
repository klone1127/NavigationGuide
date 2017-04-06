//
//  TransitResultViewController.h
//  
//
//  Created by CF on 2017/4/5.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@class AMapRoute;
@class AMapTransit;

@interface TransitResultViewController : BaseViewController

@property (nonatomic, assign)NSInteger      routerCount;
@property (strong, nonatomic) AMapRoute     *route;
@property (nonatomic, strong)NSMutableArray *transitArray; //公交换乘方案的详细信息 数组

@property (nonatomic, copy)NSString             *originLocation;
@property (nonatomic, copy)NSString             *destinationLocation;

@end
