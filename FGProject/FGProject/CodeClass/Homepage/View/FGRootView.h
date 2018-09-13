//
//  FGRootView.h
//  FGProject
//
//  Created by pingan on 2018/8/7.
//  Copyright © 2018年 bert. All rights reserved.
//

#import "FGBaseView.h"
@class CARadarView;
@interface FGRootView : FGBaseView
@property (nonatomic,strong) CARadarView *radarView;
//太阳图片
@property (nonatomic, strong) UIImageView *sunImgView;
//@property (nonatomic, strong) UIImageView *redImageView;
//@property (nonatomic, strong) UIImageView *yellowImageView;


@end
