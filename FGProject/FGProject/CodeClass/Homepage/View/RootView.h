//
//  RootView.h
//  FGProject
//
//  Created by XL on 15/7/8.
//  Copyright (c) 2015年 XL. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol RootViewDelegate <NSObject>
//@optional
//- (void)startBtnAction;
//@end
#import "FGBaseView.h"
@class CARadarView;
@interface RootView : FGBaseView
@property (nonatomic,strong) CARadarView *radarView;
//太阳图片
@property (nonatomic, strong) UIImageView *sunImgView;
@property (nonatomic, strong) UIImageView *redImageView;
@property (nonatomic, strong) UIImageView *yellowImageView;
@property (nonatomic, strong) UIButton *startBtn;
@end
