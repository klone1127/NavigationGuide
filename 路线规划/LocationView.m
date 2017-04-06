//
//  LocationView.m
//  路线规划
//
//  Created by jgrm on 2017/4/6.
//  Copyright © 2017年 klone1127. All rights reserved.
//

#import "LocationView.h"
#import <Masonry.h>

#define kLocationImageW     30
#define kLocationImageL     15
#define kTop                10
#define kLocationTextH      30

@implementation LocationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)originLocation:(NSString *)location {
    [self isOriginPoint:YES];
    [self walkDetailText:location];
}

- (void)destinationLocation:(NSString *)location {
    [self isOriginPoint:NO];
    [self walkDetailText:location];
}

- (void)isOriginPoint:(BOOL)origin {
    UIImageView *originImage = [[UIImageView alloc] init];
    [self addSubview:originImage];
    
    if (origin) {
        originImage.image = [UIImage imageNamed:@"椭圆起点"];
    } else {
        originImage.image = [UIImage imageNamed:@"椭圆终点"];
    }
    
    [originImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(11);
        make.width.height.mas_equalTo(30);
        make.centerY.equalTo(self.mas_centerY);
    }];
}

- (void)walkDetailText:(NSString *)distance {
    UILabel *detail = [[UILabel alloc] init];
    [self addSubview:detail];
    detail.text = distance;
    
    [detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(self.mas_height);
        make.left.mas_equalTo(50);  // 和 BusLineDetailCell 中文字对齐
        make.right.equalTo(self.mas_right).with.offset(-15);
    }];
}

//- (void)showOriginLocationView:(NSString *)location walkDistance:(NSString *)distance {
//    [self locationImageWithImageName:@"椭圆起点"];
//    [self locationText:location isOrigin:YES];
//    [self walkDistance:distance];
//    [self walkImageViewWithCenterConstraint:YES];
//    
//}
//
//- (void)showDestionationLocationView:(NSString *)location walkDistance:(NSString *)distance {
//    [self locationImageWithImageName:@"椭圆终点"];
//    [self locationText:location isOrigin:NO];
//    [self walkDistance:distance];
//    [self walkImageViewWithCenterConstraint:NO];
//}
//
//- (void)walkImageViewWithCenterConstraint:(BOOL)origin {
//    UIImageView *walkImage = [[UIImageView alloc] init];
//    [self addSubview:walkImage];
//    
//    [walkImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (origin) {
//            make.centerY.equalTo(self.originLocation.mas_centerY);
//        } else {
//            make.centerY.equalTo(self.destinationLocation.mas_centerY);
//        }
//        make.height.width.mas_equalTo(30);
//        make.right.equalTo(self.mas_right).with.offset(-15);
//    }];
//}
//
//- (void)walkDistance:(NSString *)distance {
//    UILabel *distanceLabel = [[UILabel alloc] init];
//    [self addSubview:distanceLabel];
//    distanceLabel.text = distance;
//    
//    [distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(kLocationImageW + kLocationImageL + 20);
//        make.top.mas_equalTo(kTop + kLocationTextH);
//        make.bottom.mas_equalTo(kTop + kLocationTextH);
//        make.right.equalTo(self.mas_right).with.offset(-30);
//    }];
//}
//
//- (void)locationText:(NSString *)location isOrigin:(BOOL)origin {
//    UILabel *locationLabel = [[UILabel alloc] init];
//    [self addSubview:locationLabel];
//    locationLabel.text = location;
//    
//    [locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(kLocationImageW + kLocationImageL + 20);
//        if (origin) {
//            make.top.mas_equalTo(kTop);
//        } else {
//            make.bottom.equalTo(self.mas_bottom).with.offset(-20);
//        }
//        make.right.equalTo(self.mas_right).with.offset(-30);
//        make.height.mas_equalTo(kLocationTextH);
//    }];
//}
//
//- (void)locationImageWithImageName:(NSString *)imageName {
//    UIImageView *imageView = [[UIImageView alloc] init];
//    [self addSubview:imageView];
//    [imageView sizeToFit];
//    
//    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(kLocationImageL);
//        make.top.mas_equalTo(kTop);
//        make.width.mas_equalTo(kLocationImageW);
//        make.height.equalTo(self.mas_height).with.offset(-20);
//    }];
//    
//    imageView.image = [UIImage imageNamed:imageName];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
