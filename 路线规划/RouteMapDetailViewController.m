//
//  RouteMapDetailViewController.m
//  路线规划
//
//  Created by jgrm on 2017/4/6.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import "RouteMapDetailViewController.h"
#import "LocationView.h"
#import "WalkCell.h"
#import "BusLineDetailCell.h"
//#import "ReGoecode.h"
#import <AMapSearchKit/AMapSearchKit.h>

#import <objc/objc-runtime.h>

#define kWalkCellID     @"walkCell"
#define kBusLineDetailCellID      @"busLineDetailCell"

@interface RouteMapDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView        *detailTableView;
@property (nonatomic, strong)AMapSegment        *mapSegment;

@end

@implementation RouteMapDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self initDetailTableView];
    
}

//- (void)getOriginLocationAndDestinationLocation:(CLLocationCoordinate2D)locationCoordinate {
//    
//}

- (void)initDetailTableView {
    self.detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    [self.view addSubview:self.detailTableView];
    
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    
    [self.detailTableView registerNib:[UINib nibWithNibName:@"WalkCell" bundle:nil] forCellReuseIdentifier:kWalkCellID];
    [self.detailTableView registerNib:[UINib nibWithNibName:@"BusLineDetailCell" bundle:nil] forCellReuseIdentifier:kBusLineDetailCellID];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 转公交的 次数
    return self.mapTransit.segments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.mapSegment = self.mapTransit.segments[indexPath.row];
    
    
    NSLog(@"****************************");
//    NSLog(@"\n%@", );
    // 判断时要根据 walking model 数组中走的路线
//    if (self.mapSegment.walking.distance != 0) {
//        WalkCell *cell = [tableView dequeueReusableCellWithIdentifier:kWalkCellID];
//        if (!cell) {
//            NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"WalkCell" owner:nil options:nil];
//            cell = [cellArray firstObject];
//        }
//        self.detailTableView.rowHeight = cell.frame.size.height;
////        NSString *walkDistance = [NSString stringWithFormat:@"%@, %@", self.mapSegment.walking];
//        cell.walkDetailLabel.text = @"步行215米";
//        return cell;
//    } else if (self.mapSegment.railway.uid !=nil) {
//        // 这里显示含有地铁的 cell
//        return nil;
//    } else {
        BusLineDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kBusLineDetailCellID];
        if (!cell) {
            NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"BusLineDetailCell" owner:nil options:nil];
            cell = [cellArray firstObject];
        }
    
        self.detailTableView.rowHeight = cell.frame.size.height;
        // 需要获取对应的 公交，然后做数据展示
//        cell.busNameLabel.text = self.mapSegment.buslines[indexPath.row].
        cell.originStationLabel.text = self.mapSegment.enterName;
        cell.destinationStationLabel.text = self.mapSegment.exitName;
//        cell.otherBusLineBut setTitle:<#(nullable NSString *)#> forState:<#(UIControlState)#>
//        cell.showStationDetailBut setTitle:self.mapSegment forState:<#(UIControlState)#>
        return cell;
//    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LocationView *headeView = [[LocationView alloc] initWithFrame:CGRectMake(0, 0, self.detailTableView.frame.size.width, 40)];
    [headeView originLocation:self.originLocation];
    return headeView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    LocationView *footerView = [[LocationView alloc] initWithFrame:CGRectMake(0, 0, self.detailTableView.frame.size.width, 40)];
    [footerView destinationLocation:self.destinationLocation];
    return footerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
