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
//#import "ReGoecode.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "StationCell.h"

#import "DestinationStopModel.h"
#import "DestinationStopCell.h"
#import "StartStopModel.h"
#import "StartStopCell.h"

#define kWalkCellID                 @"walkCell"
#define kBusLineDetailCellID        @"busLineDetailCell"
#define kStationCellID              @"stationCell"

#define kStartStopCellID           @"startStopCell"
#define kDestinationStopCellID      @"destinationStopCell"

@interface RouteMapDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView        *detailTableView;
@property (nonatomic, strong)AMapSegment        *mapSegment;

@property (nonatomic, strong)NSMutableArray     *dataSource;

@property (nonatomic, strong)NSMutableArray     *transBusLineArray;         // 存放可转程的公交数组

@property (nonatomic, assign)BOOL               isClick;
@property (nonatomic, strong)NSMutableArray     *busStopsArray;             // 存放停靠站点


@end

@implementation RouteMapDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.dataSource = [NSMutableArray arrayWithCapacity:0];
    self.busStopsArray = [NSMutableArray arrayWithCapacity:0];
    [self initDetailTableView];
    [self initData];
    self.isClick = NO;
    
}

- (void)initData {
    
    [self.dataSource removeAllObjects];
    
#warning TODO - 封装 for 循环
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
#warning TODO - 区分 公交/地铁
//          if  ([segments.buslines firstObject].type = "地铁线路") {}
            // 添加公交到数据源
                // 拆分公交数据为 始发和到达
            
            StartStopModel *startStopModel = [StartStopModel initStartStopModelWithBusLine:firstBusline];
            DestinationStopModel *destinationStopModel = [DestinationStopModel initDestinationStopModelWithBusLine:firstBusline];
            [self.dataSource addObject:startStopModel];
            [self.dataSource addObject:destinationStopModel];
//            [self.dataSource addObject:firstBusline];
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
    [self.detailTableView registerNib:[UINib nibWithNibName:@"StationCell" bundle:nil] forCellReuseIdentifier:kStationCellID];
    [self.detailTableView registerNib:[UINib nibWithNibName:@"StartStopCell" bundle:nil] forCellReuseIdentifier:kStartStopCellID];
    [self.detailTableView registerNib:[UINib nibWithNibName:@"DestinationStopCell" bundle:nil] forCellReuseIdentifier:kDestinationStopCellID];
    
    self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 转公交的 次数
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 根据类名区分 [self.dataSource[indexPath.row] isKindOfClass:[AMapStep class]]
    
    id currentClass = self.dataSource[indexPath.row];
#warning TODO - cell 种类太多，重构
    if ([currentClass isKindOfClass:[AMapStep class]]) {
        AMapStep *mapStep = currentClass;
        
        WalkCell *cell = [tableView dequeueReusableCellWithIdentifier:kWalkCellID];
        if (!cell) {
            NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"WalkCell" owner:nil options:nil];
            cell = [cellArray firstObject];
        }
        self.detailTableView.rowHeight = cell.frame.size.height;
        [cell configWalkCell:mapStep];
        return cell;
    }
    
    if ([currentClass isKindOfClass:[StartStopModel class]]) {
        StartStopModel *startStopModel = currentClass;
        
        StartStopCell *cell = [tableView dequeueReusableCellWithIdentifier:kStartStopCellID];
        if (!cell) {
            NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"StartStopCell" owner:nil options:nil];
            cell = [cellArray firstObject];
        }
        self.detailTableView.rowHeight = cell.frame.size.height;
        
        [cell configStartStopCellWithModel:startStopModel];
        [cell.showStopBtn addTarget:self action:@selector(ShowMoreStation:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    if ([currentClass isKindOfClass:[DestinationStopModel class]]) {
        DestinationStopModel *model = currentClass;
        
        DestinationStopCell *cell = [tableView dequeueReusableCellWithIdentifier:kDestinationStopCellID];
        if (!cell) {
            NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"DestinationStopCell" owner:nil options:nil];
            cell = [cellArray firstObject];
        }
        self.detailTableView.rowHeight = cell.frame.size.height;
        cell.OtherStationLabel.hidden = YES;
        [cell configCellWithModel:model];
        return cell;
    }
    
    
    if ([currentClass isKindOfClass:[AMapBusStop class]]) {
        AMapBusStop *busStop = currentClass;
        StationCell *cell = [tableView dequeueReusableCellWithIdentifier:kStationCellID];
        if (!cell) {
            NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"StationCell" owner:nil options:nil];
            cell = [cellArray firstObject];
        }
        
        self.detailTableView.rowHeight = cell.frame.size.height;
        cell.stationLabel.text = busStop.name;
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

- (void)ShowMoreStation:(UIButton *)sender {
//    BusLineDetailCell
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.detailTableView indexPathForCell:cell];
    NSIndexPath *index1 = [NSIndexPath indexPathForItem:indexPath.row inSection:0];
    
    StartStopModel *busLine = self.dataSource[index1.row];
    
    // 按位置插入
    if ([self.dataSource containsObject:[busLine.viaBusStops firstObject]]) {
        [self.dataSource removeObjectsInArray:busLine.viaBusStops];
        self.isClick = NO;
        
        [UIView animateWithDuration:1.0 animations:^{
            sender.imageView.transform = CGAffineTransformIdentity;
        }];
    } else {
        NSUInteger busLineIndex = [self.dataSource indexOfObject:busLine];
        if (self.dataSource.count == busLineIndex) {
            [self.dataSource addObjectsFromArray:busLine.viaBusStops];
        } else {
            for (int i = 0; i < busLine.viaBusStops.count; i++) {
                [self.dataSource insertObject:busLine.viaBusStops[i] atIndex:(busLineIndex + 1)];
                busLineIndex++;
            }
        }
        self.isClick = YES;
        
        [UIView animateWithDuration:1 animations:^{
            sender.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    }
    
    [self.detailTableView reloadData];
    
    
    NSLog(@"data:%@", busLine);
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
