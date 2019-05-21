//
//  SpeechRecognitionViewController.h
//  路线规划
//
//  Created by CF on 2017/4/30.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol RecognizerStringDelegate <NSObject>

- (void)recognizerString:(NSString *)string;

@end

@interface SpeechRecognitionViewController : BaseViewController

@property (nonatomic, weak)id<RecognizerStringDelegate>     recognizerStringDelegate;

@end
