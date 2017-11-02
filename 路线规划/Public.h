//
//  Public.h
//  路线规划
//
//  Created by jgrm on 2017/4/8.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#ifndef Public_h
#define Public_h

#define kSearchLabeltextColor   @"C0D7FF"
#define kSearchLabelColor       @"679FFF"
#define kSearchBarColor         @"4287FF"
#define KSearchBarTextColor     @"FFFFFF"
#define kMainColor              kSearchBarColor
#define kScreenSize             [UIScreen mainScreen].bounds.size
#define WS(weakSelf)            __weak typeof(self)weakSelf = self;
#define SS(strongSelf)          __strong typeof(weakSelf)strongSelf = weakSelf;

#endif /* Public_h */
