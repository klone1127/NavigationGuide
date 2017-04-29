//
//  SpeedRecognitionViewController.m
//  路线规划
//
//  Created by CF on 2017/4/30.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import "SpeedRecognitionViewController.h"

@interface SpeedRecognitionViewController ()

@end

@implementation SpeedRecognitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    NSArray *vcArray = self.navigationController.viewControllers;
    NSLog(@"VCs:%@", vcArray);
    [self configNavigationBar];
}

- (void)configNavigationBar {
    UIView *view = [self navigationBarViewWithBackButton:kSearchBarColor];
    [self.view addSubview:view];
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
