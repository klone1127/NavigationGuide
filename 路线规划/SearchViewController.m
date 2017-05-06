//
//  SearchViewController.m
//  路线规划
//
//  Created by jgrm on 2017/4/5.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import "SearchViewController.h"
#import "AMapSearchKit/AMapSearchKit.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>
#import "SearchView.h"
#import "TransitResultViewController.h"
#import "SearchTipsCell.h"
#import "TipsEmptyView.h"
#import "SpeedRecognitionViewController.h"

#define kSearchViewID           @"searchView"
#define kInputViewY             64
#define kInputViewH             120
#define kSearchTipsTableViewY   kInputViewY + kInputViewH
#define kSearchTipsCellID       @"searchTipsCell"

@interface SearchViewController ()<AMapSearchDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, AMapLocationManagerDelegate, RecognizerStringDelegate>

@property (nonatomic, strong)AMapSearchAPI                  *mapSearch;

@property (assign, nonatomic) CLLocationCoordinate2D startCoordinate; //起始点经纬度
@property (assign, nonatomic) CLLocationCoordinate2D destinationCoordinate; //终点经纬度
@property (strong, nonatomic) AMapRoute         *route;  //路径规划信息
@property (copy, nonatomic) NSArray             *routeArray;  //规划的路径数组
@property (nonatomic, strong)SearchView         *searchView;
@property (nonatomic, strong)UITableView        *searchTipsTableView;
@property (nonatomic, strong)NSMutableArray     *tipsArray;
@property (nonatomic, strong)TipsEmptyView      *tipsEmptyView;
@property (nonatomic, strong)id                 currentTextfield;
@property (nonatomic, strong)AMapLocationManager    *locationManager;
@property (nonatomic, copy)NSString             *currentCity;
@property (nonatomic, copy)NSString             *recognitionString;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.tipsArray = [NSMutableArray arrayWithCapacity:0];
    [self initInputLocationView];
    [self initSearchTipsTableView];
    [self initMapSearch];
    [self configTipsEmptyView];
    [self initLocationManager];
}

- (void)initMapSearch {
    self.mapSearch = [[AMapSearchAPI alloc] init];
    self.mapSearch.delegate = self;
}

// 定位
- (void)initLocationManager {
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 10;
    self.locationManager.locatingWithReGeocode = YES; // 返回逆地理信息(仅限国内)
    
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9) {
        self.locationManager.allowsBackgroundLocationUpdates = YES;
    }
    
}

-(void)startLocation {
    // 持续返回逆地理编码信息
    [self.locationManager setLocatingWithReGeocode:YES];
    [self.locationManager startUpdatingLocation];
}

- (void)configNavigationBar {
    UIView *barView = [self navigationBarViewWithColor:kSearchBarColor title:@"公交线路规划"];
    [self.speedButton addTarget:self action:@selector(showSpeedRecognitionVIew) forControlEvents:UIControlEventTouchUpInside];
    [self hideNavigationBar];
    [self.view addSubview:barView];
    
}

- (void)configTipsEmptyView {
    self.tipsEmptyView = [[TipsEmptyView alloc] initWithFrame:self.searchTipsTableView.bounds];
}

- (void)initSearchTipsTableView {
    self.searchTipsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kSearchTipsTableViewY, kScreenSize.width, kScreenSize.height - kInputViewY - kInputViewH) style:UITableViewStylePlain];
    self.searchTipsTableView.delegate = self;
    self.searchTipsTableView.dataSource = self;
    [self.view addSubview:self.searchTipsTableView];
    
    self.searchTipsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.searchTipsTableView registerNib:[UINib nibWithNibName:@"SearchTipsCell" bundle:nil] forCellReuseIdentifier:kSearchTipsCellID];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configNavigationBar];
    [self startLocation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startLocationChange:) name:UITextFieldTextDidChangeNotification object:self.searchView.startLocation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishLocationChange:) name:UITextFieldTextDidChangeNotification object:self.searchView.finishLocation];
    
    // 监听键盘高度变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.searchView.finishLocation];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.searchView.startLocation];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)initInputLocationView {
    self.searchView = [[SearchView alloc] initWithFrame:CGRectMake(0, kInputViewY, self.view.frame.size.width, kInputViewH)];
    [self.view addSubview:self.searchView];
    
    self.searchView.startLocation.delegate = self;
    self.searchView.finishLocation.delegate = self;
    self.searchView.finishLocation.returnKeyType = UIReturnKeyDone;
    self.searchView.startLocation.returnKeyType = UIReturnKeyDone;
}

- (void)keyboardShow:(NSNotification *)not {
    NSLog(@"not:%@", not.userInfo);
    
    CGRect keyBoardFrame = [[not.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat animationDuration = [NSString stringWithFormat:@"%@", [not.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]].floatValue;
    
    [self changeTableViewHeight:-keyBoardFrame.size.height animationDuration:animationDuration];
}

- (void)changeTableViewHeight:(CGFloat)height animationDuration:(CGFloat)time {
    [UIView animateWithDuration:time animations:^{
        self.searchTipsTableView.frame = CGRectMake(0, kSearchTipsTableViewY, kScreenSize.width, kScreenSize.height - kInputViewY - kInputViewH + height);
    }];
}

- (void)startLocationChange:(NSNotification *)not {
    [self inputTipsSearchWithText:self.searchView.startLocation.text];
    self.startCoordinate = CLLocationCoordinate2DMake(0, 0);
}

- (void)finishLocationChange:(NSNotification *)not {
    [self inputTipsSearchWithText:self.searchView.finishLocation.text];
    self.recognitionString = nil;
    self.destinationCoordinate = CLLocationCoordinate2DMake(0, 0);
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tipsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AMapTip *tip = self.tipsArray[indexPath.row];
    
    SearchTipsCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchTipsCellID];
    if (!cell) {
        NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"SearchTipsCell" owner:nil options:nil];
        cell = [cellArray firstObject];
    }
    self.searchTipsTableView.rowHeight = cell.frame.size.height;
    [cell configSearchTipsCell:tip];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AMapTip *tip = self.tipsArray[indexPath.row];
    UITextField *textField = (UITextField *)self.currentTextfield;
    textField.text = tip.name;
    
    if ([textField isEqual:self.searchView.startLocation]) {
        self.startCoordinate = CLLocationCoordinate2DMake(tip.location.latitude, tip.location.longitude);
    }
    
    if ([textField isEqual:self.searchView.finishLocation] || [tip.name isEqual:self.recognitionString]) {
        self.destinationCoordinate = CLLocationCoordinate2DMake(tip.location.latitude, tip.location.longitude);
    }
    
    if (self.recognitionString) {
       self.searchView.finishLocation.text = self.recognitionString;
        self.destinationCoordinate = CLLocationCoordinate2DMake(tip.location.latitude, tip.location.longitude);
    }
    
    if ((self.startCoordinate.latitude != 0) && (self.destinationCoordinate.latitude != 0)) {
        [self transitRouteSearchWithStartCoordinate:self.startCoordinate DestinationCoordinate:self.destinationCoordinate];
    }
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
        self.startCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    } else if ([request.address isEqualToString:self.searchView.finishLocation.text]) {
        self.destinationCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    } else {
//        NSLog(@"编码前的地址：%@， 响应的编码为:%@", request.address, response.geocodes);
    }
    
    if ((self.startCoordinate.latitude != 0) && (self.destinationCoordinate.latitude != 0)) {
        // 发起线路规划的请求
        [self transitRouteSearchWithStartCoordinate:self.startCoordinate DestinationCoordinate:self.destinationCoordinate];
    }
    
}

#pragma mark - 定位 delegate
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode {
    // 初始位置默认显示 -> 我的位置
    [self showStartLocation:reGeocode location:location];
    self.currentCity = reGeocode.city;
    [self.locationButton setTitle:reGeocode.city forState:UIControlStateNormal];
//    NSLog(@"location:%@, \n reGeocode:%@", location, reGeocode);
}
- (void)amapLocationManager:(AMapLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [self showNoAuthorizedTips:status];
    NSLog(@"定位权限改变！！！");
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"locationManager error:%@", error);
}

// 输入提示
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response {
    [self.tipsArray removeAllObjects];
    
    if ([request.keywords isEqualToString:self.searchView.startLocation.text]) {
        self.currentTextfield = self.searchView.startLocation;
    }
    
    if ([request.keywords isEqualToString:self.searchView.finishLocation.text]) {
        self.currentTextfield = self.searchView.finishLocation;
    }
    
    if (response.count == 0) {
        self.searchTipsTableView.backgroundView = self.tipsEmptyView;
    } else {
        self.searchTipsTableView.backgroundView = nil;
        [self.tipsArray addObjectsFromArray:response.tips];
        
        [self removeNoLocationCoordinateObject];
    }
    [self.searchTipsTableView reloadData];
    
    NSLog(@"----------------------");
    NSLog(@"tips request:%@, response:%@",request, response);
}

// 输入提示有时会给出坐标为空的地点，从数组中去除
- (void)removeNoLocationCoordinateObject {
    [self.tipsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AMapTip *tip = obj;
        if (tip.location.latitude == 0) {
            [self.tipsArray removeObject:tip];
        }
    }];
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

- (void)showNoAuthorizedTips:(CLAuthorizationStatus)status {
    if ( status == kCLAuthorizationStatusNotDetermined || status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您还没有授权使用定位" message:@"请前往设置授权" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"好的"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
// TODO: 改为跳转？
                                                              }];
            
        
        [alertController addAction:cancelAction];
        [alertController addAction:defaultAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        // 重新定位
        [self startLocation];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showStartLocation:(AMapLocationReGeocode *)reGeocode location:(CLLocation *)location {
    if (![self.searchView.startLocation isFirstResponder]) {
        NSString *start = [self currentLocation:reGeocode];
        self.searchView.startLocation.text = start;
        self.startCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    }
}

- (NSString *)currentLocation:(AMapLocationReGeocode *)reGeocode {
    NSString *start;
    if (reGeocode.city) {
        start = [NSString stringWithFormat:@"%@%@%@%@", reGeocode.city, reGeocode.district, reGeocode.street, reGeocode.number];
        if (reGeocode.AOIName) {
            start = [NSString stringWithFormat:@"%@%@%@",reGeocode.city, reGeocode.district, reGeocode.AOIName ];
        }
        if (reGeocode.POIName) {
            start = reGeocode.POIName;
        }
        
    }
    return [NSString stringWithFormat:@"(当前位置)%@", start];
}

- (void)geoWithText:(NSString *)text {
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = text;
    [self.mapSearch AMapGeocodeSearch:geo];
}

- (void)inputTipsSearchWithText:(NSString *)keywords {
    AMapInputTipsSearchRequest *inputTips = [[AMapInputTipsSearchRequest alloc] init];
    inputTips.keywords = keywords;
    inputTips.city = self.currentCity;
    inputTips.cityLimit = YES;
    [self.mapSearch AMapInputTipsSearch:inputTips];
}

#pragma mark - 发起路线规划
- (void)transitRouteSearchWithStartCoordinate:(CLLocationCoordinate2D)startCoordinate DestinationCoordinate:(CLLocationCoordinate2D)destinationCoordinate {
    AMapTransitRouteSearchRequest *navi = [[AMapTransitRouteSearchRequest alloc] init];

    navi.nightflag = YES;
    navi.requireExtension = YES;
    navi.city = self.currentCity;
    navi.destinationCity = self.currentCity;
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:startCoordinate.latitude
                                           longitude:startCoordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:destinationCoordinate.latitude
                                                longitude:destinationCoordinate.longitude];


    [self.mapSearch AMapTransitRouteSearch:navi];
}

- (void)recognizerString:(NSString *)string {
    [self inputTipsSearchWithText:string];
    self.destinationCoordinate = CLLocationCoordinate2DMake(0, 0);
    self.recognitionString = string;
}

- (void)showSpeedRecognitionVIew {
    SpeedRecognitionViewController *srVC = [[SpeedRecognitionViewController alloc] init];
    srVC.recognizerStringDelegate = self;
    [self.navigationController pushViewController:srVC animated:YES];
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
