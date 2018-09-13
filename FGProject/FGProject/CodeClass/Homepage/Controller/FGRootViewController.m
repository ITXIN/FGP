//
//  RootViewController.m
//  FGProject
//
//  Created by XL on 15/7/4.
//  Copyright (c) 2015年 XL. All rights reserved.
//

#import "FGRootViewController.h"
#import "FGMathRootViewController.h"
#import "FGRootView.h"
#import "FGTomViewController.h"
#import "AIVoiceMathematicsViewController.h"
#import "FGDateView.h"
#import "FGCategoryMenuView.h"
#import "FLStoryViewController.h"
#import "CARadarView.h"
#import "FGAngryBirdsView.h"
#import "FGAlertView.h"
#import "FGGameViewController.h"
#import "PullCircleView.h"
#import "FGMyCenterViewController.h"
#import "FGVideoViewController.h"
#import "FGMathDiffcultyViewController.h"
#import "FGMathSettingViewController.h"
#import "WaterRippleView.h"
@interface FGRootViewController ()<FGCategoryMenuViewDelegate>
@property (nonatomic,strong) FGAngryBirdsView *angryBirdView;
@property (nonatomic,strong) FGRootView *rootBgView;
@property (nonatomic,strong) FGCategoryMenuView *cateGoryMenuView;

@property (nonatomic, strong) WaterRippleView *myWaterView;
@end

@implementation FGRootViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self.angryBirdView startBirdsAnimation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
//    FGUserManager *user = self.userManager;
//    FGLOG(@"---%@ %@ %@",user.name,user.ID,user.isPlaySound);
//
//    NSString *uidStr = [FLDeviceUID uid];
//    NSDictionary *userInfoDic = @{@"name":@"聪明可爱的宝贝",@"ID":[NSString stringWithFormat:@"%@",uidStr],@"isPlaySound":@"N"};
//    [user saveUserDataWithDic:userInfoDic];
//    FGLOG(@"更新---%@ %@ %@",user.name,user.ID,user.isPlaySound);
}

- (void)initSubviews{
    [super initSubviews];
    
    self.navigationView.hidden = YES;
    //波以及背景
    self.rootBgView = [[FGRootView alloc]init];
    [self.bgView addSubview:self.rootBgView];
    NSInteger cound = [[FGMathOperationManager shareMathOperationManager].dataStatisticsModel totalNumber];
    cound = 70;
    if (cound > 50) {//绕过审核
        self.angryBirdView = [[FGAngryBirdsView alloc]init];
        [self.bgView addSubview:self.angryBirdView];
        
        
        self.myWaterView = [[WaterRippleView alloc] initWithFrame:CGRectMake(0, kScreenHeight/2, kScreenWidth, kScreenHeight/2)
                                                  mainRippleColor:[UIColor colorWithRed:86/255.0f green:202/255.0f blue:139/255.0f alpha:1]
                                                 minorRippleColor:[UIColor colorWithRed:84/255.0f green:200/255.0f blue:120/255.0f alpha:0.9]
                                                mainRippleoffsetX:6.0f
                                               minorRippleoffsetX:1.1f
                                                      rippleSpeed:2.0f
                                                   ripplePosition:kScreenHeight/2//高度
                                                  rippleAmplitude:15.0f];
        self.myWaterView.backgroundColor = UIColor.clearColor;
        [self.bgView addSubview:self.myWaterView];
        
        //类别
        self.cateGoryMenuView = [[FGCategoryMenuView alloc]initWithFrame:CGRectMake(0, 0, kScreenHeight, kScreenHeight)];
        self.cateGoryMenuView.categoryDelegate = self;
        [self.bgView addSubview: self.cateGoryMenuView];
    
    }else{
        __unused   UIButton *myCenterBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.bgView addSubview:btn];
            CGFloat btnW = ([FGProjectHelper getIsiPad] == YES)? USER_ICON_IPAD_WIDTH:USER_ICON_IPAD_WIDTH/2;
            btn.layer.cornerRadius = btnW/2;
            btn.layer.masksToBounds = YES;
            btn.backgroundColor = [UIColor whiteColor];
            [btn setImage:[UIImage imageNamed:@"home_calculate_bg"] forState:UIControlStateNormal];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(100, 100));
                make.center.equalTo(self.bgView);
            }];
            btn.tag = CategoryMath;
            [btn addTarget:self action:@selector(categoryAction:) forControlEvents:UIControlEventTouchUpInside];
            CABasicAnimation *basicAnimation = [FGProjectHelper animationRotationZ];
            [btn.layer addAnimation:basicAnimation forKey:@"calculateKeyTarnsform.rotaiton.z"];

            btn;
        });

    }
//  NSLog(@"---lev---%ld",[[FGMathOperationManager shareMathOperationManager] getCurrentChallengeLevel]);


    
}

#pragma mark -
- (void)myCenterAction:(UIButton*)sender{
//    FGMyCenterViewController *myCenterVC = [[FGMyCenterViewController alloc]init];
//    [self.navigationController pushViewController:myCenterVC animated:YES];
    
//
//    FGMathDiffcultyViewController *myCenterVC = [[FGMathDiffcultyViewController alloc]init];
//    [self.navigationController pushViewController:myCenterVC animated:YES];
    
    
//    FGMathSettingViewController *settingVC = [[FGMathSettingViewController alloc]init];
//    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark -
#pragma mark --- categoryDelegate
- (void)categoryAction:(UIButton *)sender{
    CATransition *animation=[CATransition animation];
    animation.type = @"rippleEffect";
    animation.duration=2.0;
    [self.view.superview.layer addAnimation:animation forKey:@"donghua"];
    
    switch (sender.tag) {
        case CategoryGame:
        {
            
            FGGameViewController *gameVC = [[FGGameViewController alloc]init];
            [self.navigationController pushViewController:gameVC animated:YES];
            
        }
            break;
        case CategoryAI:
        {
            AIVoiceMathematicsViewController *aiVoiceVC = [[AIVoiceMathematicsViewController alloc] init];
            [self.navigationController pushViewController:aiVoiceVC animated:YES];
        }
            break;
        case CategoryStory:
        {
            FLStoryViewController *storyVC = [[FLStoryViewController alloc]init];
            
            storyVC.titleStr = @"故事";
            [self.navigationController pushViewController:storyVC animated:YES];
            
        }
            break;
        case CategoryMath:
        {
            FGMathRootViewController *mathRootVC = [[FGMathRootViewController alloc]init];
            mathRootVC.title = @"数学乐园";
            [self.navigationController pushViewController:mathRootVC animated:YES];
            
        }
            break;
        default:
            break;
    }
}

- (void)setupLayoutSubviews{
    [super setupLayoutSubviews];
    
    [self.rootBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView);
    }];
    [self.angryBirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView);
    }];
    [self.cateGoryMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenHeight, kScreenHeight));
        make.center.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
