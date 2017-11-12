//
//  SearchViewController.m
//  路线规划
//
//  Created by jgrm on 2017/4/5.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import "SearchViewController.h"
#import "MapSearchInitializer.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>
#import "SearchView.h"
#import "TransitResultViewController.h"
#import "SearchTipsCell.h"
#import "TipsEmptyView.h"
#import "SpeedRecognitionViewController.h"
#import "AppDelegate.h"

static NSString *kSearchViewID = @"searchView";
static CGFloat  kInputViewY = 64;
static CGFloat  kInputViewH = 120;
static CGFloat  kSearchTipsTableViewY = 64 + 120;
static NSString *kSearchTipsCellID = @"searchTipsCell";

@interface SearchViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, AMapLocationManagerDelegate, RecognizerStringDelegate>

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
@property (nonatomic, strong) MapSearchInitializer   *mapSearchInitializer;
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
    self.mapSearchInitializer = [[MapSearchInitializer alloc] init];
    WS(weakSelf)
    // 地理编码查询回调
    self.mapSearchInitializer.geocodeSearchDoneBlock = ^(AMapGeocodeSearchRequest *request, CGFloat latitude, CGFloat longitude) {
        if ([request.address isEqualToString:weakSelf.searchView.startLocation.text]) {
            weakSelf.startCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
        } else if ([request.address isEqualToString:weakSelf.searchView.finishLocation.text]) {
            weakSelf.destinationCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
        } else {
    //        NSLog(@"编码前的地址：%@， 响应的编码为:%@", request.address, response.geocodes);
        }
    
        if ((weakSelf.startCoordinate.latitude != 0) && (weakSelf.destinationCoordinate.latitude != 0)) {
            // 发起线路规划的请求
            [weakSelf transitRouteSearchWithStartCoordinate:weakSelf.startCoordinate DestinationCoordinate:weakSelf.destinationCoordinate];
        }
    };
    
    // 输入提示查询回调
    self.mapSearchInitializer.inputTipsSearchDoneBlock = ^(AMapInputTipsSearchRequest *request, AMapInputTipsSearchResponse *response) {
        [weakSelf.tipsArray removeAllObjects];
    
        if ([request.keywords isEqualToString:weakSelf.searchView.startLocation.text]) {
            weakSelf.currentTextfield = weakSelf.searchView.startLocation;
        }
    
        if ([request.keywords isEqualToString:weakSelf.searchView.finishLocation.text]) {
            weakSelf.currentTextfield = weakSelf.searchView.finishLocation;
        }
    
        if (response.count == 0) {
            weakSelf.searchTipsTableView.backgroundView = weakSelf.tipsEmptyView;
        } else {
            weakSelf.searchTipsTableView.backgroundView = nil;
            [weakSelf.tipsArray addObjectsFromArray:response.tips];
    
            [weakSelf removeNoLocationCoordinateObject];
        }
        [weakSelf.searchTipsTableView reloadData];
    };
    
    // 路径规划查询回调
    self.mapSearchInitializer.routeSearchDoneBlock = ^(AMapRouteSearchResponse *response) {
        // 解析数据
        weakSelf.route = nil;
        weakSelf.routeArray = nil;
        weakSelf.route = response.route;
        weakSelf.routeArray = response.route.transits;
    
        TransitResultViewController *TRVC = [[TransitResultViewController alloc] init];
        TRVC.routerCount = response.count;
        TRVC.route = weakSelf.route;
        TRVC.originLocation = weakSelf.searchView.startLocation.text;
        TRVC.destinationLocation = weakSelf.searchView.finishLocation.text;
        TRVC.transitArray = [NSMutableArray arrayWithArray:response.route.transits];
        [weakSelf.navigationController pushViewController:TRVC animated:YES];
    };
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

// 输入提示有时会给出坐标为空的地点，从数组中去除
- (void)removeNoLocationCoordinateObject {
    [self.tipsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AMapTip *tip = obj;
        if (tip.location.latitude == 0) {
            [self.tipsArray removeObject:tip];
        }
    }];
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
    [self.mapSearchInitializer mapGeocodeSearch:geo];
}

- (void)inputTipsSearchWithText:(NSString *)keywords {
    AMapInputTipsSearchRequest *inputTips = [[AMapInputTipsSearchRequest alloc] init];
    inputTips.keywords = keywords;
    [self.mapSearchInitializer mapInputTipsSearch:inputTips];
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


    [self.mapSearchInitializer mapTransitRouteSearch:navi];
}

- (void)recognizerString:(NSString *)string {
    [self inputTipsSearchWithText:string];
    self.destinationCoordinate = CLLocationCoordinate2DMake(0, 0);
    self.recognitionString = string;
    
    if ([self.searchView.startLocation isFirstResponder]) {
        self.searchView.startLocation.text = string;
    } else {
        self.searchView.finishLocation.text = string;
    }
}


- (void)showSpeedRecognitionVIew {
    SpeedRecognitionViewController *srVC = [[SpeedRecognitionViewController alloc] init];
    srVC.recognizerStringDelegate = self;
    self.definesPresentationContext = YES;
    srVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f];
    srVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:srVC animated:YES completion:^{
    }];
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
