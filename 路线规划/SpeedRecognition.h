//
//  SpeedRecognition.h
//  路线规划
//
//  Created by CF on 2017/4/30.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Speech/Speech.h>

@protocol SpeechRecognizerResultDelegate <NSObject>

- (void)speechRecognizerSuccess:(SFSpeechRecognitionResult *)result;

- (void)speechRecognizerFailure:(NSError *)error;

- (void)speechRecognizerStart;

@end


@interface SpeedRecognition : NSObject<SFSpeechRecognizerDelegate, SFSpeechRecognitionTaskDelegate>

@property (nonatomic, strong)SFSpeechRecognizer                     *speechRecognizer;
@property (nonatomic, strong)SFSpeechAudioBufferRecognitionRequest  *recognitionRequest;
@property (nonatomic, strong)SFSpeechRecognitionTask                *recognitionTask;
@property (nonatomic, strong)AVAudioEngine                          *audioEngine;
@property (nonatomic, weak)id <SpeechRecognizerResultDelegate>      speechRecofnizerResultDelegate;

- (void)startRecording;

@end
