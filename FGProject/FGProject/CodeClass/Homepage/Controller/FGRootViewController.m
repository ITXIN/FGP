//
//  RootViewController.m
//  FGProject
//
//  Created by XL on 15/7/4.
//  Copyright (c) 2015年 XL. All rights reserved.
//

#import "FGRootViewController.h"
#import "FGMathRootViewController.h"
#import "RootView.h"
#import "FGTomViewController.h"
#import "AIVoiceMathematicsViewController.h"
#import "FGDateView.h"
#import "FGCategoryMenuView.h"
#import "FLStoryViewController.h"
#import "CARadarView.h"
#import "FGBuildingsView.h"
#import "FGAngryBirdsView.h"
#import "FGAlertView.h"
#import "FGGameViewController.h"
#import "PullCircleView.h"
#import "FGMyCenterViewController.h"
#import "FGVideoViewController.h"
@interface FGRootViewController ()<FGCategoryMenuViewDelegate>
{
}
@property (nonatomic,strong) FGAngryBirdsView *angryBirdView;
@property (nonatomic,strong) RootView *rootBgView;
@property (nonatomic,strong) FGCategoryMenuView *cateGoryMenuView;
@end

@implementation FGRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    FGUserManager *user = self.userManager;
    FGLOG(@"---%@ %@ %@",user.name,user.ID,user.isPlaySound);
    
    NSString *uidStr = [FLDeviceUID uid];
    NSDictionary *userInfoDic = @{@"name":@"聪明可爱的宝贝",@"ID":[NSString stringWithFormat:@"%@",uidStr],@"isPlaySound":@"N"};
    [user saveUserDataWithDic:userInfoDic];
    FGLOG(@"更新---%@ %@ %@",user.name,user.ID,user.isPlaySound);
}

- (void)initSubviews{
    [super initSubviews];
    self.navigationView.hidden = YES;
    //波以及背景
    self.rootBgView = [[RootView alloc]init];
    [self.bgView addSubview:self.rootBgView];
    
    self.angryBirdView = [[FGAngryBirdsView alloc]init];
    [self.bgView addSubview:self.angryBirdView];
    
    //类别
    self.cateGoryMenuView = [[FGCategoryMenuView alloc]initWithFrame:CGRectMake(0, 0, ScreenHeight, ScreenHeight)];
    self.cateGoryMenuView.categoryDelegate = self;
    [self.bgView addSubview: self.cateGoryMenuView];
    
    //
    //    UIButton *myCenterBtn = ({
    //        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //        [self.bgView addSubview:btn];
    //        CGFloat btnW = ([FGProjectHelper getIsiPad] == YES)? USER_ICON_IPAD_WIDTH:USER_ICON_IPAD_WIDTH/2;
    //        btn.layer.cornerRadius = btnW/2;
    //        btn.layer.masksToBounds = YES;
    //        btn.backgroundColor = [UIColor whiteColor];
    //        [btn setImage:[UIImage imageNamed:@"Indexbg-02"] forState:UIControlStateNormal];
    //        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.top.mas_equalTo(30);
    //            make.right.mas_equalTo(-30);
    //            make.size.mas_equalTo(CGSizeMake(btnW, btnW));
    //        }];
    //        [btn addTarget:self action:@selector(myCenterAction:) forControlEvents:UIControlEventTouchUpInside];
    //        btn;
    //    });
    //    FGLOG(@"isiPad %d",[FGProjectHelper getIsiPad]);
}

#pragma mark -
- (void)myCenterAction:(UIButton*)sender{
    FGMyCenterViewController *myCenterVC = [[FGMyCenterViewController alloc]init];
    [self.navigationController pushViewController:myCenterVC animated:YES];
}

#pragma mark -
#pragma mark --- categoryDelegate
- (void)categoryAction:(UIButton *)sender{
    CATransition *animation=[CATransition animation];
    animation.type=@"rippleEffect";
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
        make.size.mas_equalTo(CGSizeMake(ScreenHeight, ScreenHeight));
        make.center.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
