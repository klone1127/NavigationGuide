//
//  SearchViewController.m
//  路线规划
//
//  Created by jgrm on 2017/4/5.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import "SearchViewController.h"
#import "LocationManagerInitializer.h"
#import <MAMapKit/MAMapKit.h>
#import "TransitResultViewController.h"
#import "TipsEmptyView.h"
#import "SpeechRecognitionViewController.h"
#import "SearchViewController+Common.h"

static NSString *kSearchViewID = @"searchView";
static CGFloat  kInputViewY = 64;
static CGFloat  kInputViewH = 120;
static CGFloat  kSearchTipsTableViewY = 64 + 120;

@interface SearchViewController ()<UITextFieldDelegate, RecognizerStringDelegate>

@property (strong, nonatomic) AMapRoute         *route;  //路径规划信息
@property (copy, nonatomic) NSArray             *routeArray;  //规划的路径数组
@property (nonatomic, strong)TipsEmptyView      *tipsEmptyView;
@property (nonatomic, copy)NSString             *currentCity;
@property (nonatomic, strong) MapSearchInitializer   *mapSearchInitializer;
@property (nonatomic, strong) LocationManagerInitializer *locationManagerInitializer;
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
    [self disabledScrollViewAutolayout:self.searchTipsTableView];
}

- (void)initMapSearch {
    self.mapSearchInitializer = [[MapSearchInitializer alloc] init];
    WS(weakSelf)
    // 地理编码查询回调
    self.mapSearchInitializer.geocodeSearchDoneBlock = ^(AMapGeocodeSearchRequest *request, CGFloat latitude, CGFloat longitude) {
        [weakSelf getLocationCoordinate2D:request latitude:latitude longitude:longitude];
    
        if ((weakSelf.startCoordinate.latitude != 0) && (weakSelf.destinationCoordinate.latitude != 0)) {
            // 发起线路规划的请求
            [weakSelf transitRouteSearchWithStartCoordinate:weakSelf.startCoordinate DestinationCoordinate:weakSelf.destinationCoordinate];
            
        }
    };
    
    // 输入提示查询回调
    self.mapSearchInitializer.inputTipsSearchDoneBlock = ^(AMapInputTipsSearchRequest *request, AMapInputTipsSearchResponse *response) {
        [weakSelf.tipsArray removeAllObjects];
    
        if ([weakSelf.searchView matchStartLocation:request.keywords]) {
            weakSelf.currentTextfield = weakSelf.searchView.startLocation;
        }
    
        if ([weakSelf.searchView matchFinishLocation:request.keywords]) {
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
        [weakSelf pushToResultVC:response];
    };
}

// 定位
- (void)initLocationManager {
    self.locationManagerInitializer = [[LocationManagerInitializer alloc] init];
    WS(weakSelf)
    self.locationManagerInitializer.locationManagerBlock = ^(CLLocation *location, AMapLocationReGeocode *reGeocode) {
        [weakSelf showStartLocation:reGeocode location:location];
        weakSelf.currentCity = reGeocode.city;
        [weakSelf.locationButton setTitle:reGeocode.city forState:UIControlStateNormal];
    };
}

- (void)configNavigationBar {
    UIView *barView = [self navigationBarViewWithColor:kSearchBarColor title:@"公交线路规划"];
    [self.speechButton addTarget:self action:@selector(showSpeechRecognitionVIew) forControlEvents:UIControlEventTouchUpInside];
    [self hideNavigationBar];
    [self.view addSubview:barView];
    [self setStatusBarBackgroundColor:[UIColor colorWithHexCode:kSearchBarColor]];
}

- (void)configTipsEmptyView {
    self.tipsEmptyView = [[TipsEmptyView alloc] initWithFrame:self.searchTipsTableView.bounds];
}

- (void)initSearchTipsTableView {
    self.searchTipsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kSearchTipsTableViewY + kStatusBarFrame.size.height, kScreenSize.width, kScreenSize.height - kInputViewY - kInputViewH) style:UITableViewStylePlain];
    [self.view addSubview:self.searchTipsTableView];
    [self setDelegate:self.searchTipsTableView];
    self.searchTipsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.searchTipsTableView registerNib:[UINib nibWithNibName:@"SearchTipsCell" bundle:nil] forCellReuseIdentifier:@"searchTipsCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configNavigationBar];
    [self.locationManagerInitializer startLocation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startLocationChange:) name:UITextFieldTextDidChangeNotification object:self.searchView.startLocation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishLocationChange:) name:UITextFieldTextDidChangeNotification object:self.searchView.finishLocation];
    
    // 监听键盘高度变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    NSLog(@"%@", [statusBar performSelector:NSSelectorFromString(@"recursiveDescription")]);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.searchView.finishLocation];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.searchView.startLocation];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)initInputLocationView {
    self.searchView = [[SearchView alloc] initWithFrame:CGRectMake(0, kInputViewY + kStatusBarFrame.size.height, self.view.frame.size.width, kInputViewH)];
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
        self.searchTipsTableView.frame = CGRectMake(0, kSearchTipsTableViewY + kStatusBarFrame.size.height, kScreenSize.width, kScreenSize.height - kInputViewY - kInputViewH + height);
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
    WS(weakSelf)
    [self.mapSearchInitializer transitRouteSearchWithStartCoordinate:startCoordinate DestinationCoordinate:destinationCoordinate configurationBlock:^(AMapTransitRouteSearchRequest *request) {
        request.city = weakSelf.currentCity;
        request.destinationCity = weakSelf.currentCity;
    }];
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

- (void)showSpeechRecognitionVIew {
    SpeechRecognitionViewController *srVC = [[SpeechRecognitionViewController alloc] init];
    srVC.recognizerStringDelegate = self;
    self.definesPresentationContext = YES;
    srVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f];
    srVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:srVC animated:YES completion:^{
    }];
}

- (void)pushToResultVC:(AMapRouteSearchResponse *)response {
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

- (void)getLocationCoordinate2D:(AMapGeocodeSearchRequest *)request latitude:(double)latitude longitude:(double)longitude {
    if ([self.searchView matchStartLocation:request.address]) {
        self.startCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    } else if ([self.searchView matchFinishLocation:request.address]) {
        self.destinationCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    } else {
        //        NSLog(@"编码前的地址：%@， 响应的编码为:%@", request.address, response.geocodes);
    }
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
