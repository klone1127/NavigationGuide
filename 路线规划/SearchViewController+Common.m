//
//  SearchViewController+Common.m
//  路线规划
//
//  Created by CF on 13/11/2017.
//  Copyright © 2017 klone1127. All rights reserved.
//

#import "SearchViewController+Common.h"

@implementation SearchViewController (Common)

- (void)setDelegate:(UITableView *)tableView {
    tableView.delegate = self;
    tableView.dataSource = self;
}


#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tipsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AMapTip *tip = self.tipsArray[indexPath.row];
    
    SearchTipsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchTipsCell"];
    if (!cell) {
        NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"SearchTipsCell" owner:nil options:nil];
        cell = [cellArray firstObject];
    }
    self.searchTipsTableView.rowHeight = cell.frame.size.height;
    [cell configSearchTipsCell:tip];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AMapTip *tip = self.tipsArray[indexPath.row];
    UITextField *textField = (UITextField *)self.currentTextfield;
    textField.text = tip.name;
    
    if ([textField isEqual:self.searchView.startLocation]) {
        self.startCoordinate = CLLocationCoordinate2DMake(tip.location.latitude, tip.location.longitude);
    }
    
    if ([textField isEqual:self.searchView.finishLocation] || [tip.name isEqual:self.recognitionString]) {
        self.destinationCoordinate = CLLocationCoordinate2DMake(tip.location.latitude, tip.location.longitude);
    }
    
    if (self.recognitionString) {
        self.searchView.finishLocation.text = self.recognitionString;
        self.destinationCoordinate = CLLocationCoordinate2DMake(tip.location.latitude, tip.location.longitude);
    }
    
    if ((self.startCoordinate.latitude != 0) && (self.destinationCoordinate.latitude != 0)) {
        [self transitRouteSearchWithStartCoordinate:self.startCoordinate DestinationCoordinate:self.destinationCoordinate];
    }
}

@end
