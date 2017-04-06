//
//  TransitResultViewController.m
//  
//
//  Created by CF on 2017/4/5.
//
//

#import "TransitResultViewController.h"
#import "TransitTableViewCell.h"
#import <AMapSearchKit/AMapSearchKit.h>

#define kTransitTableViewCellID  @"transitTableViewCell"

@interface TransitResultViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView    *transitResultTableView;
@property (strong, nonatomic)AMapTransit   *transit;  //公交换乘方案的详细信息

@end

@implementation TransitResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexCode:@"F1F5F6"];
    
    [self initTableView];
    
    
    for (int i = 0; i < self.transitArray.count; i++) {
        NSLog(@"data:%@", self.transitArray[i]);
    }
}

- (void)initTableView {
    self.transitResultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    [self.view addSubview:self.transitResultTableView];
    
    self.transitResultTableView.delegate = self;
    self.transitResultTableView.dataSource = self;
    
    self.transitResultTableView.backgroundColor = [UIColor colorWithHexCode:@"F1F5F6"];
    self.transitResultTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.transitResultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.transitResultTableView registerNib:[UINib nibWithNibName:@"TransitTableViewCell" bundle:nil] forCellReuseIdentifier:kTransitTableViewCellID];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return self.transitArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TransitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTransitTableViewCellID];
    if (!cell) {
        NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"TransitTableViewCell" owner:nil options:nil];
        cell = [cellArray firstObject];
    }
    self.transitResultTableView.rowHeight = cell.frame.size.height;
    self.transit = self.transitArray[indexPath.row];
    [cell configDataWithTranditsModel:self.transit];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
