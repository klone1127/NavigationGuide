//
//  SpeedRecognition.m
//  路线规划
//
//  Created by CF on 2017/4/30.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import "SpeedRecognition.h"

@implementation SpeedRecognition

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self config];
    }
    return self;
}

- (void)config {
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    
    self.speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:locale];
    self.speechRecognizer.delegate = self;
    
    self.audioEngine = [[AVAudioEngine alloc] init];
    
    
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            switch (status) {
                case SFSpeechRecognizerAuthorizationStatusAuthorized:
                    // 按钮可用
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
    
}

- (void)startRecording {
    if (self.recognitionTask) {
        [self.recognitionTask cancel];
        self.recognitionTask = nil;
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    [audioSession setMode:AVAudioSessionModeMeasurement error:nil];
    [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    
    self.recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    
    AVAudioInputNode *inputNode = self.audioEngine.inputNode;
    
    if (!inputNode) {
        NSLog(@"无 node");
    }
    
    self.recognitionRequest.shouldReportPartialResults = YES;
    
    [self.speechRecognizer recognitionTaskWithRequest:self.recognitionRequest delegate:self];
    
    self.recognitionTask = [self.speechRecognizer recognitionTaskWithRequest:self.recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        BOOL isFinal = NO;
        
        NSLog(@"识别结果 result:%@", result);
        if (result) {
            NSLog(@"识别出的文字：%@",result.bestTranscription.formattedString);
            isFinal = result.isFinal;
        }
        
        if (error != nil || isFinal) {
            [self.audioEngine stop];
            [inputNode removeTapOnBus:0];
            
            self.recognitionRequest = nil;
            self.recognitionTask = nil;
            
            // 录制按钮改为可用状态， 更改 title
        }
        
    }];
    
    AVAudioFormat *recordingFormat = [inputNode outputFormatForBus:0];
    [inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [self.recognitionRequest appendAudioPCMBuffer:buffer];
    }];
    
    [self.audioEngine prepare];
    NSError *error;
    [self.audioEngine startAndReturnError:&error];
    if (error) {
        NSLog(@"startAndReturnError:%@", error);
    }
    
    NSLog(@"正在听...");
    
}

#pragma mark - delegate

- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available {
    NSLog(@"开始啦要");
}

- (void)speechRecognitionDidDetectSpeech:(SFSpeechRecognitionTask *)task {
    NSLog(@"任务状态:%ld", task.state);
}


@end
