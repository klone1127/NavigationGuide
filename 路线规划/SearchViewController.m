//
//  SearchViewController.m
//  路线规划
//
//  Created by jgrm on 2017/4/5.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import "SearchViewController.h"
#import "AMapSearchKit/AMapSearchKit.h"
#import <MAMapKit/MAMapKit.h>
#import "SearchView.h"
#import "TransitResultViewController.h"

#define kSearchViewID         @"searchView"

@interface SearchViewController ()<AMapSearchDelegate, UITextFieldDelegate>

@property (nonatomic, strong)AMapSearchAPI                  *mapSearch;

@property (assign, nonatomic) CLLocationCoordinate2D startCoordinate; //起始点经纬度
@property (assign, nonatomic) CLLocationCoordinate2D destinationCoordinate; //终点经纬度
@property (strong, nonatomic) AMapRoute         *route;  //路径规划信息
@property (copy, nonatomic) NSArray             *routeArray;  //规划的路径数组
@property (nonatomic, strong)SearchView         *searchView;


@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initInputLocationView];
    self.mapSearch = [[AMapSearchAPI alloc] init];
    self.mapSearch.delegate = self;
    
}

- (void)configNavigationBar {
    UIView *barView = [self navigationBarViewWithColor:kSearchBarColor title:@"公交线路规划"];
    [self hideNavigationBar];
    [self.view addSubview:barView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configNavigationBar];
    self.startCoordinate = CLLocationCoordinate2DMake(0, 0);
    self.destinationCoordinate = CLLocationCoordinate2DMake(0, 0);
}

- (void)initInputLocationView {
    self.searchView = [[SearchView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 120)];
    [self.view addSubview:_searchView];
    
    self.searchView.startLocation.delegate = self;
    self.searchView.finishLocation.delegate = self;
    self.searchView.finishLocation.returnKeyType = UIReturnKeyDone;
    self.searchView.startLocation.returnKeyType = UIReturnKeyDone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startLocationChange:) name:@"UITextFieldTextDidEndEditingNotification" object:self.searchView.startLocation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishLocationChange:) name:@"UITextFieldTextDidEndEditingNotification" object:self.searchView.finishLocation];
}

- (void)startLocationChange:(NSNotification *)not {
    // 获取地理编码
    [self geoWithText:self.searchView.startLocation.text];
//    [self inputTipsSearchWithText:self.searchView.startLocation.text];
}

- (void)finishLocationChange:(NSNotification *)not {
#warning TODO - 添加输入提示位置
//    [self geoWithText:self.searchView.finishLocation.text];
//    [self inputTipsSearchWithText:self.searchView.finishLocation.text];
}

#pragma mark - amapSearch Delegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"search request:%@, error:%@", request, error);
}

- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response {
    // 在这里进行 线路规划的请求工作， 在点击 完成的时候也会获取一次编码（如果有编码不存在）
    if ([response.geocodes firstObject].location.latitude == 0) {
        return;
    }
    
    CGFloat latitude = [response.geocodes firstObject].location.latitude;
    CGFloat longitude = [response.geocodes firstObject].location.longitude;
    
    if ([request.address isEqualToString:self.searchView.startLocation.text]) {
//        NSLog(@"编码前的起始地址：%@， 响应的编码为:%@", request.address, response.geocodes);
        self.startCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
    } else if ([request.address isEqualToString:self.searchView.finishLocation.text]) {
//        NSLog(@"编码前的结束地址：%@， 响应的编码为:%@", request.address, response.geocodes);
        self.destinationCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    } else {
//        NSLog(@"编码前的地址：%@， 响应的编码为:%@", request.address, response.geocodes);
    }
    
    if ((self.startCoordinate.latitude != 0) && (self.destinationCoordinate.latitude != 0)) {
        // 发起线路规划的请求
        [self transitRouteSearchWithStartCoordinate:self.startCoordinate DestinationCoordinate:self.destinationCoordinate];
    }
    
}

// 输入提示
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response {
    NSLog(@"----------------------");
    NSLog(@"tips request:%@, response:%@",request, response);
}

#pragma mark - 线路规划
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response {
    NSLog(@"routeSearchDone request:%@, response:%@", request, response);
    if (response.count == 0) { return; }

    // 解析数据
    self.route = nil;
    self.routeArray = nil;
    self.route = response.route;
    self.routeArray = response.route.transits;

    TransitResultViewController *TRVC = [[TransitResultViewController alloc] init];
    TRVC.routerCount = response.count;
    TRVC.route = self.route;
    TRVC.originLocation = self.searchView.startLocation.text;
    TRVC.destinationLocation = self.searchView.finishLocation.text;
    TRVC.transitArray = [NSMutableArray arrayWithArray:response.route.transits];
    [self.navigationController pushViewController:TRVC animated:YES];
}

#pragma mark - textfield Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ((self.searchView.startLocation.text == nil || ![self.searchView.startLocation.text isEqualToString:@""]) && ((self.searchView.finishLocation.text == nil || ![self.searchView.finishLocation.text isEqualToString:@""]))) {
        if ((self.startCoordinate.latitude == 0) && (self.destinationCoordinate.latitude == 0)) {
            [self geoWithText:self.searchView.startLocation.text];
            [self geoWithText:self.searchView.finishLocation.text];
        } else if (self.destinationCoordinate.latitude == 0) {
            [self geoWithText:self.searchView.finishLocation.text];
        } else if (self.startCoordinate.latitude == 0) {
            [self geoWithText:self.searchView.startLocation.text];
        } else {
            // 发起线路规划的请求
            [self transitRouteSearchWithStartCoordinate:self.startCoordinate DestinationCoordinate:self.destinationCoordinate];
        }
        NSLog(@"text:%@", textField.text);
        return YES;
    } else {
        return NO;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidEndEditingNotification" object:self.searchView.finishLocation];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidEndEditingNotification" object:self.searchView.startLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)geoWithText:(NSString *)text {
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = text;
    [self.mapSearch AMapGeocodeSearch:geo];
}

- (void)inputTipsSearchWithText:(NSString *)keywords {
    AMapInputTipsSearchRequest *inputTips = [[AMapInputTipsSearchRequest alloc] init];
    inputTips.keywords = keywords;
#warning TODO - 城市名基于定位
    inputTips.city = @"郑州市";
    inputTips.cityLimit = YES;
    [self.mapSearch AMapInputTipsSearch:inputTips];
}

#pragma mark - 发起路线规划
- (void)transitRouteSearchWithStartCoordinate:(CLLocationCoordinate2D)startCoordinate DestinationCoordinate:(CLLocationCoordinate2D)destinationCoordinate {
    AMapTransitRouteSearchRequest *navi = [[AMapTransitRouteSearchRequest alloc] init];

    navi.nightflag = YES;
    navi.requireExtension = YES;
    navi.city = @"郑州市";
    navi.destinationCity = @"郑州市";
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:startCoordinate.latitude
                                           longitude:startCoordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:destinationCoordinate.latitude
                                                longitude:destinationCoordinate.longitude];


    [self.mapSearch AMapTransitRouteSearch:navi];
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
