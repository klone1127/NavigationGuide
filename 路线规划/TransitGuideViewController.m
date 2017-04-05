//
//  TransitGuideViewController.m
//  路线规划
//
//  Created by CF on 2017/4/6.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import "TransitGuideViewController.h"
#import "SearchViewController.h"

@interface TransitGuideViewController ()

@end

@implementation TransitGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    [self setViewControllers:@[searchVC]];
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
