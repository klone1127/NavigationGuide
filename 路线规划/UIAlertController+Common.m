//
//  UIAlertController+Common.m
//  路线规划
//
//  Created by CF on 2017/5/6.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import "UIAlertController+Common.h"

@implementation UIAlertController (Common)

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message controller:(UIViewController *)vc {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:alertAction];
    [vc presentViewController:alert animated:YES completion:nil];
}

@end
