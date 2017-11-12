//
//  SpeedRecognitionViewController.m
//  路线规划
//
//  Created by CF on 2017/4/30.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import "SpeedRecognitionViewController.h"
#import "SpeedRecognition.h"
#import <Masonry.h>
#import <POP.h>

static void *RecognizerResultString = &RecognizerResultString;

@interface SpeedRecognitionViewController ()<SpeechRecognizerResultDelegate>

@property (nonatomic, strong)UIButton           *operationButton;
@property (nonatomic, strong)SpeedRecognition   *recognition;
@property (nonatomic, strong)UIView             *backgroundView;

@end

@implementation SpeedRecognitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self halfView];
    [self setupSpeedRecognitionButton];
    
    self.recognition = [[SpeedRecognition alloc] init];
    self.recognition.speechRecofnizerResultDelegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.recognition stopRecording];
}

// 半屏的 View
- (void)halfView {
    self.backgroundView = [[UIView alloc] init];
    [self.view addSubview:self.backgroundView];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_centerY);
    }];
}

// 开始按钮
- (void)setupSpeedRecognitionButton {
    self.operationButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.backgroundView addSubview:self.operationButton];
    
    CGFloat h = 80.0;
    [self.operationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(h);
        make.center.equalTo(self.backgroundView);
    }];
    
    self.operationButton.backgroundColor = [UIColor colorWithHexCode:kMainColor];
    [self.operationButton setTitle:@"开始" forState:UIControlStateNormal];
    self.operationButton.titleLabel.font = [UIFont systemFontOfSize:25.0];
    [self.operationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.operationButton.layer.cornerRadius = h / 2.0;
    self.operationButton.layer.masksToBounds = YES;
    self.operationButton.alpha = 0.8;
    [self.operationButton addTarget:self action:@selector(operationButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self animationBtn];
}

- (void)animationBtn {
    [self.operationButton.layer pop_removeAllAnimations];
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    static BOOL ani = YES;
    if (ani) {
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    } else {
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.5, 1.5)];
    }
    
    ani = !ani;
    animation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            [self animationBtn];
        }
    };
    
    [self.operationButton.layer pop_addAnimation:animation forKey:@"Animation"];
}

- (void)animationTest {
    [self.operationButton pop_animationKeys];
    
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

#pragma mark - SpeechRecognizerDelegate
- (void)speechRecognizerStart {
    [self.operationButton setTitle:@"停止" forState:UIControlStateNormal];
}

- (void)speechRecognizerSuccess:(SFSpeechRecognitionResult *)result {
    // 显示识别结果
    NSLog(@"result:%@", result);
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

#pragma mark - 触摸返回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
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
