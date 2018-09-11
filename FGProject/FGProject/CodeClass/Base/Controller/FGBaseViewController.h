//
//  FGBaseViewController.h
//  FGProject
//
//  Created by avazuholding on 2017/11/9.
//  Copyright © 2017年 bert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGBaseViewController : UIViewController
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) FGNavigationView *navigationView;
@property (nonatomic,strong) NSString *titleStr;
@property (nonatomic,strong) NSAttributedString *attributedTitleStr;
@property (nonatomic,strong) FGBlurEffectView *blurView;
@property (nonatomic,strong) FGUserManager *userManager;

- (void)initSubviews;
- (void)setupLayoutSubviews;
- (void)setupBlurEffectImage:(UIImage*)image;
@end
