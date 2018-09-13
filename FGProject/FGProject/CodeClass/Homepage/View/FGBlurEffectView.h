//
//  FGBlurEffectView.h
//  FGProject
//
//  Created by Bert on 2016/12/27.
//  Copyright © 2016年 XL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGBaseView.h"
@interface FGBlurEffectView : FGBaseView
@property (nonatomic,strong) UIBlurEffect *blurEffect;
@property (nonatomic,strong) UIVisualEffectView *effView;
@property (nonatomic,strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIImageView *redImageView;
@property (nonatomic, strong) UIImageView *yellowImageView;
@end
