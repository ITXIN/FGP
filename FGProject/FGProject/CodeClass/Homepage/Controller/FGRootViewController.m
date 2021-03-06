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
@property (nonatomic,strong) FGRootView *rootview;
@property (nonatomic,strong) FGCategoryMenuView *cateGoryMenuView;

@end

@implementation FGRootViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
//    [self.angryBirdView startBirdsAnimation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
//    FGUserManager *user = self.userManager;
//    FGLOG(@"---%@ %@ %@",user.name,user.ID,user.isPlaySound);
//    NSString *uidStr = [FLDeviceUID uid];
//    NSDictionary *userInfoDic = @{@"name":@"聪明可爱的宝贝",@"ID":[NSString stringWithFormat:@"%@",uidStr],@"isPlaySound":@"N"};
//    [user saveUserDataWithDic:userInfoDic];
//    FGLOG(@"更新---%@ %@ %@",user.name,user.ID,user.isPlaySound);
}

- (void)initSubviews{
    [super initSubviews];
    
    self.navigationView.hidden = YES;
    //太阳，水波以海洋生物
    self.rootview = [[FGRootView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.rootview];
    
    NSInteger cound = [[FGMathOperationManager shareMathOperationManager].dataStatisticsModel totalNumber];
    cound = 70;
    if (cound > 50) {//绕过审核
        self.angryBirdView = [[FGAngryBirdsView alloc]init];
        [self.view addSubview:self.angryBirdView];
        [self.angryBirdView startBirdsAnimation];
        //类别
        self.cateGoryMenuView = [[FGCategoryMenuView alloc]initWithFrame:CGRectMake(0, 0, kScreenHeight, kScreenHeight)];
        self.cateGoryMenuView.categoryDelegate = self;
        [self.view addSubview: self.cateGoryMenuView];
    
        UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesShowWaterAnimation:)];
        longGes.minimumPressDuration = 2;
        [self.angryBirdView addGestureRecognizer:longGes];
        
    }else{
        __unused   UIButton *myCenterBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.view addSubview:btn];
            CGFloat btnW = ([FGProjectHelper getIsiPad] == YES)? USER_ICON_IPAD_WIDTH:USER_ICON_IPAD_WIDTH/2;
            btn.layer.cornerRadius = btnW/2;
            btn.layer.masksToBounds = YES;
            btn.backgroundColor = [UIColor whiteColor];
            [btn setImage:[UIImage imageNamed:@"home_calculate_bg"] forState:UIControlStateNormal];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(100, 100));
                make.center.equalTo(self.view);
            }];
            btn.tag = CategoryMath;
            [btn addTarget:self action:@selector(categoryAction:) forControlEvents:UIControlEventTouchUpInside];
//            CABasicAnimation *basicAnimation = [FGProjectHelper animationRotationZ];
//            [btn.layer addAnimation:basicAnimation forKey:@"calculateKeyTarnsform.rotaiton.z"];

            btn;
        });
    }
}

#pragma mark -
- (void)longGesShowWaterAnimation:(UILongPressGestureRecognizer*)ges{
    if (ges.state == UIGestureRecognizerStateBegan) {
        if (!self.rootview.myWaterView) {
            FGLOG(@"---show---");
            [self.rootview showWaterAnimation];
        }else{
            FGLOG(@"---hidden---");
             [self.rootview hiddenWaterAnimation];
        }
    }
}

- (void)myCenterAction:(UIButton*)sender{
//    FGMyCenterViewController *myCenterVC = [[FGMyCenterViewController alloc]init];
//    [self.navigationController pushViewController:myCenterVC animated:YES];

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
    [self.rootview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.angryBirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
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
