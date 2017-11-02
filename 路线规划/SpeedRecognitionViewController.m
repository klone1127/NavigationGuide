//
//  SpeedRecognitionViewController.m
//  路线规划
//
//  Created by CF on 2017/4/30.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import "SpeedRecognitionViewController.h"
#import "SpeedRecognition.h"

@interface SpeedRecognitionViewController ()<SpeechRecognizerResultDelegate>

@property (nonatomic, strong)UILabel            *textLabel;
@property (nonatomic, strong)UIButton           *operationButton;
@property (nonatomic, strong)SpeedRecognition   *recognition;

@end

@implementation SpeedRecognitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self configNavigationBar];
    [self setupTextLabel];
    [self setupSpeedRecognitionButton];
    
    self.recognition = [[SpeedRecognition alloc] init];
    self.recognition.speechRecofnizerResultDelegate = self;
}

- (void)setupTextLabel {
    CGFloat x = 5;
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 64 + x, kScreenSize.width - 2*x, 200)];
    [self.view addSubview:self.textLabel];
    self.textLabel.numberOfLines = 0;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.layer.borderColor = [UIColor cyanColor].CGColor;
    self.textLabel.layer.borderWidth = 1;
    self.textLabel.layer.masksToBounds = YES;
    self.textLabel.layer.cornerRadius = 5.0;
    self.textLabel.text = @"请说出你要去地方";
    self.textLabel.textColor = [UIColor lightGrayColor];
}

- (void)setupSpeedRecognitionButton {
    self.operationButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.operationButton];
    CGFloat h = 150;
    CGFloat w = h;
    CGFloat x = kScreenSize.width / 2 - w / 2;
    CGFloat y = CGRectGetMaxY(self.textLabel.frame) + 100;
    self.operationButton.frame = CGRectMake(x, y, w, h);
    self.operationButton.backgroundColor = [UIColor colorWithHexCode:kMainColor];
    [self.operationButton setTitle:@"开始" forState:UIControlStateNormal];
    self.operationButton.titleLabel.font = [UIFont systemFontOfSize:25.0];
    [self.operationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.operationButton.layer.cornerRadius = h / 2.0;
    self.operationButton.layer.masksToBounds = YES;
    [self.operationButton addTarget:self action:@selector(operationButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)operationButtonHandle:(UIButton *)sender {
    
    if ([self.recognition.audioEngine isRunning]) {
        [self.recognition stopRecording];
        NSLog(@"停止操作");
        [self.operationButton setTitle:@"开始" forState:UIControlStateNormal];
    } else {
        [self.recognition startRecording];
        NSLog(@"开始操作");
    }
    
}

- (void)configNavigationBar {
    UIView *view = [self navigationBarViewWithBackButton:kSearchBarColor];
    [self.view addSubview:view];
}

#pragma mark - SpeechRecognizerDelegate
- (void)speechRecognizerStart {
    [self.operationButton setTitle:@"正在听..." forState:UIControlStateNormal];
}

- (void)speechRecognizerSuccess:(SFSpeechRecognitionResult *)result {
    // 显示识别结果
    NSLog(@"result:%@", result);
    self.textLabel.text = result.bestTranscription.formattedString;
    self.textLabel.textColor = [UIColor blackColor];
    [self.recognizerStringDelegate recognizerString:result.bestTranscription.formattedString];
}

- (void)speechRecognizerFailure:(NSError *)error {
    NSLog(@"speedRec Error:%@", error);
    id errorString = [error.userInfo objectForKey:@"NSLocalizedDescription"];
    if (errorString) {
        [UIAlertController alertWithTitle:errorString message:@"" controller:self];
        [self.operationButton setTitle:@"开始" forState:UIControlStateNormal];
    }
    
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
