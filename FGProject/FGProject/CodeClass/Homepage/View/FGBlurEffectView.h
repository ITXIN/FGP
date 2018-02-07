//
//  FGBlurEffectView.h
//  FGProject
//
//  Created by Bert on 2016/12/27.
//  Copyright © 2016年 XL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGBlurEffectView : UIView
@property (nonatomic,strong) UIBlurEffect *blurEffect;
@property (nonatomic,strong) UIVisualEffectView *effView;
@property (nonatomic,strong) UIImageView *bgImageView;
@end
