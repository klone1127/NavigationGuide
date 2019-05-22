//
//  SpeechRecognition.m
//  路线规划
//
//  Created by CF on 2017/4/30.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import "SpeechRecognition.h"

@implementation SpeechRecognition

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self config];
    }
    return self;
}

- (void)config {
    [self checkAuthorization];
}

- (void)initSpeechRecognizerWithLocale:(NSLocale *)locale {
    if (self.speechRecognizer) {
        return;
    }
    self.speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:locale];
    self.speechRecognizer.delegate = self;
}

- (void)initAudioEngine {
    if (self.audioEngine) {
        return;
    }
    self.audioEngine = [[AVAudioEngine alloc] init];
}

- (void)initAudioSession {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    [audioSession setMode:AVAudioSessionModeMeasurement error:nil];
    [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}

// 检测授权状态
- (BOOL)checkAuthorization {
    __block BOOL isAuthorization = NO;
    
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            switch (status) {
                case SFSpeechRecognizerAuthorizationStatusAuthorized:
                    // 按钮可用
                    isAuthorization = YES;
                    break;
                case SFSpeechRecognizerAuthorizationStatusDenied:
                    // 按钮不可用， 并提示
                    break;
                case SFSpeechRecognizerAuthorizationStatusRestricted:
                    // 按钮不可用， 并提示
                    break;
                case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                    // 按钮不可用， 并提示
                    break;
                default:
                    break;
            }
        }];
    }];
    
    return isAuthorization;
}

- (void)createSpeechAudioBufferRecognitionRequest {
    if (self.recognitionRequest) {
        [self.recognitionRequest endAudio];
        self.recognitionRequest = nil;
    }
    
    self.recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    self.recognitionRequest.shouldReportPartialResults = YES;
}

- (AVAudioNode *)inputNode {
    AVAudioInputNode *inputNode = self.audioEngine.inputNode;
    if (!inputNode) {
        NSLog(@"无 node");
    }
    return inputNode;
}

- (void)createRecognitionTask {
    WS(weakSelf)
    self.recognitionTask = [self.speechRecognizer recognitionTaskWithRequest:self.recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        SS(strongSelf)
        BOOL isFinal = NO;
        
        NSLog(@"识别结果 result:%@", result);
        if (result) {
            NSLog(@"识别出的文字：%@",result.bestTranscription.formattedString);
            isFinal = result.isFinal;
            if (self.speechRecofnizerResultDelegate && [self.speechRecofnizerResultDelegate respondsToSelector:@selector(speechRecognizerSuccess:)]) {
                [strongSelf.speechRecofnizerResultDelegate speechRecognizerSuccess:result];
            }
        }
        
        if (error != nil || isFinal) {
            [self endTask];
            if (self.speechRecofnizerResultDelegate && [self.speechRecofnizerResultDelegate respondsToSelector:@selector(speechRecognizerFailure:)]) {
                [strongSelf.speechRecofnizerResultDelegate speechRecognizerFailure:error];
            }
            
            // 录制按钮改为可用状态， 更改 title
        }
        
    }];
     
}

- (void)stopRecording {
    [self.audioEngine stop];
    [self.recognitionRequest endAudio];
    [self endTask];
}

- (void)endTask {
    [self.audioEngine stop];
    [[self inputNode] removeTapOnBus:0];
    
    self.recognitionRequest = nil;
    self.recognitionTask = nil;
}

- (void)startRecording {
    if (self.recognitionTask) {
        [self.recognitionTask cancel];
        self.recognitionTask = nil;
    }
    
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    [self initSpeechRecognizerWithLocale:locale];
    [self initAudioEngine];
    [self initAudioSession];
    [self createSpeechAudioBufferRecognitionRequest];
    [self createRecognitionTask];
    
    WS(weakSelf)
    AVAudioFormat *recordingFormat = [[self inputNode] outputFormatForBus:0];
    [[self inputNode] installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        SS(strongSelf)
        [strongSelf.recognitionRequest appendAudioPCMBuffer:buffer];
    }];
    
    [self.audioEngine prepare];
    NSError *error;
    [self.audioEngine startAndReturnError:&error];
    if (error) {
        NSLog(@"startAndReturnError:%@", error);
    }
    
    NSLog(@"正在听...");
    [self.speechRecofnizerResultDelegate speechRecognizerStart];
    
}

#pragma mark - delegate

- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available {
    NSLog(@"开始啦要");
}

@end
