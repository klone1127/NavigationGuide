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


#define kWalkCellID     @"walkCell"
#define kBusLineDetailCellID      @"busLineDetailCell"

@interface RouteMapDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView        *detailTableView;
@property (nonatomic, strong)AMapSegment        *mapSegment;

@property (nonatomic, strong)NSMutableArray     *dataSource;

@property (nonatomic, strong)NSMutableArray     *transBusLineArray;         // 存放可转程的公交数组

@end

@implementation RouteMapDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.dataSource = [NSMutableArray arrayWithCapacity:0];
    [self initDetailTableView];
    [self initData];
    
}

- (void)initData {
    
    [self.dataSource removeAllObjects];
    
    for (int i = 0; i < self.mapTransit.segments.count; i++) {
        AMapSegment *segments = self.mapTransit.segments[i];
        
        AMapBusLine *firstBusline = [segments.buslines firstObject];
        NSLog(@"segments.walking.steps:%@", segments.walking.steps);
        NSLog(@"segments.buslines:%@", segments.buslines);

        if (segments.walking.distance) {
            // 添加步行到 数据源
            [self.dataSource addObjectsFromArray:segments.walking.steps];
            NSLog(@"步行路线加进去了");
        }

        if (firstBusline.name) {
            // 区分 公交/地铁
//          if  ([segments.buslines firstObject].type = "地铁线路") {}
            // 添加公交到数据源
            [self.dataSource addObject:firstBusline];
//            [self.dataSource addObjectsFromArray:segments.buslines];
            NSLog(@"公交/地铁 加进去了");
        }
    }
    
    NSLog(@"dataSource:%@", self.dataSource);
    
//    [self.detailTableView reloadData];
    
}

- (void)initDetailTableView {
    self.detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    [self.view addSubview:self.detailTableView];
    
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    
    [self.detailTableView registerNib:[UINib nibWithNibName:@"WalkCell" bundle:nil] forCellReuseIdentifier:kWalkCellID];
    [self.detailTableView registerNib:[UINib nibWithNibName:@"BusLineDetailCell" bundle:nil] forCellReuseIdentifier:kBusLineDetailCellID];
    
    self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 转公交的 次数
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"****************************");
    // 根据类名区分 [self.dataSource[indexPath.row] isKindOfClass:[AMapStep class]]
    
    if ([self.dataSource[indexPath.row] isKindOfClass:[AMapStep class]]) {
        AMapStep *mapStep = self.dataSource[indexPath.row];
        NSLog(@"AMapStep 行走指示:%@ 所需：%ld s", mapStep.instruction, mapStep.duration);
        
        WalkCell *cell = [tableView dequeueReusableCellWithIdentifier:kWalkCellID];
        if (!cell) {
            NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"WalkCell" owner:nil options:nil];
            cell = [cellArray firstObject];
        }
        self.detailTableView.rowHeight = cell.frame.size.height;
        
        cell.walkDetailLabel.text = [NSString stringWithFormat:@"%@ 约%@", mapStep.instruction, [NSDate showTimeWithSec:mapStep.duration]];
        return cell;
    }
    
    if ([self.dataSource[indexPath.row] isKindOfClass:[AMapBusLine class]]) {
        AMapBusLine *busLine = self.dataSource[indexPath.row];
        NSLog(@"busLine :%@", busLine.name);
        
        BusLineDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kBusLineDetailCellID];
        if (!cell) {
            NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"BusLineDetailCell" owner:nil options:nil];
            cell = [cellArray firstObject];
        }
        
        self.detailTableView.rowHeight = cell.frame.size.height;
        // 需要获取对应的 公交，然后做数据展示
        cell.busNameLabel.text = busLine.name;
        cell.originStationLabel.text = busLine.startStop;
        cell.destinationStationLabel.text = busLine.endStop;
        cell.otherBusLineBut.hidden = YES;
        cell.anotherLineTipsLabel.hidden = YES;
        
        [cell.showStationDetailBut setAttributedTitle:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld站", busLine.viaBusStops.count + 1]] forState:UIControlStateNormal];

//        cell.showStationDetailBut setTitle:self.mapSegment forState:<#(UIControlState)#>
        return cell;
        
    } else {
        return nil;
    }
    
    
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
