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
@interface FGRootViewController ()<FGCategoryMenuViewDelegate,GADBannerViewDelegate>
{
    GADBannerView *adView;//横幅
    GADInterstitial *interstitial;//插页
}
@property (nonatomic,strong) FGDateView *dateView;
@property (nonatomic,strong)  CARadarView *radarView;
@property (nonatomic,strong) FGAngryBirdsView *angryBirdView;
@end

@implementation FGRootViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.radarView startAnimation];
    [self.angryBirdView restartBirdsAnimation];
}


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
    
 
    [self setupBlurEffectImage:[FGProjectHelper blurryImage:[UIImage imageNamed:[NSString stringWithFormat:@"Indexbg-0%d",arc4random()%(3-1+1)+1]] withBlurLevel:1]];
    RootView *rootView = [[RootView alloc]init];
    [self.bgView addSubview:rootView];
    //波
    self.radarView = rootView.radarView;
    [rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView);
    }];
    
    self.angryBirdView = [[FGAngryBirdsView alloc]init];
    [self.bgView addSubview:self.angryBirdView];
    [self.angryBirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(rootView);
    }];

    //类别
    FGCategoryMenuView *cateGoryMenuView = [[FGCategoryMenuView alloc]initWithFrame:CGRectMake(0, 0, ScreenHeight, ScreenHeight)];
    cateGoryMenuView.categoryDelegate = self;
    [self.bgView addSubview:cateGoryMenuView];
    [cateGoryMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenHeight, ScreenHeight));
            make.center.equalTo(self.view);
    }];

  
    UIButton *myCenterBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgView addSubview:btn];
        CGFloat btnW = ([FGProjectHelper getIsiPad] == YES)? USER_ICON_IPAD_WIDTH:USER_ICON_IPAD_WIDTH/2;
        btn.layer.cornerRadius = btnW/2;
        btn.layer.masksToBounds = YES;
        btn.backgroundColor = [UIColor whiteColor];
        [btn setImage:[UIImage imageNamed:@"Indexbg-02"] forState:UIControlStateNormal];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.size.mas_equalTo(CGSizeMake(btnW, btnW));
        }];
        [btn addTarget:self action:@selector(myCenterAction:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    FGLOG(@"isiPad %d",[FGProjectHelper getIsiPad]);
    
    
    
    
    //横幅
    //    adView = [[GADBannerView alloc]initWithAdSize:kGADAdSizeSmartBannerLandscape];//自动
    //    [self.view addSubview:adView];
    //    adView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
    //    adView.rootViewController = self;
    //    [adView loadRequest:[GADRequest request]];
    //    adView.delegate = self;
    //    [adView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.bottom.mas_equalTo(0);
    //        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 100));
    //        make.centerX.mas_equalTo(self.view);
    //    }];
    //
    //    interstitial = [[GADInterstitial alloc]initWithAdUnitID:@"ca-app-pub-3940256099942544/4411468910"];
    //    [interstitial loadRequest:[GADRequest request]];
    //
    //    [self performSelector:@selector(removeAds) withObject:nil afterDelay:5.0f];
    
//    [self loadCircleView];
}

#pragma mark -
- (void)myCenterAction:(UIButton*)sender{
    FGMyCenterViewController *myCenterVC = [[FGMyCenterViewController alloc]init];
    [self.navigationController pushViewController:myCenterVC animated:YES];
//    [FGRewardViewHUD show];
    
    
//    FGVideoViewController *myCenterVC = [[FGVideoViewController alloc]init];
//    [self.navigationController pushViewController:myCenterVC animated:YES];
}

- (void)loadCircleView
{
    //圆圈半径为60，最大拉伸300
    PullCircleView *circle = [[PullCircleView alloc]initWithCenterPoint:CGPointMake(ScreenWidth-100, (ScreenHeight-64)/2) withRadius:60 withMaxPull:300];
    
    [self.view addSubview:circle];
    //类型为拉伸型
    circle.circleType = CircleTypePull;
    
    //大圆留在原地
    circle.pullType = PullTypeLeaveBig;
    
    //内容文本
    circle.contentString = @"66";
    
    //内容字号
    circle.contentFont = 30;
    
    //圆圈颜色
    circle.pointColor = [UIColor redColor];
    
    //大圆在移动中缩小的速率
    circle.bigChangeRate = 0.4;
    
    //小圆在移动中缩小的速率
    circle.smallChangeRate = 0.7;
    
    //小圆在移动中，最小的比率。如果初始半径为60，这里设置0.3，那么最小的半径则为18
    circle.minRate = 0.3;
    
    //是否需要动画
    circle.needAnimation = YES;
    
    //处理最大拉伸量
    [circle handleMaxPull:^{
        
        NSLog(@"最大拉伸了");
    }];
    
    //处理结束手势时事件
    [circle handleEndTouch:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (circle.isEnding) {
                [circle resetOriginCircle];
                
            }
        });
        
    }];
    
    
}



#pragma mark -
#pragma mark --- remove ads
- (void)removeAds
{
    NSLog(@"-----removeAds ");
    
    [UIView animateWithDuration:0.5 animations:^{
        adView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [adView removeFromSuperview];
        adView = nil;
        
        if ([interstitial isReady]) {
//            [interstitial presentFromRootViewController:self];
            
        }else
        {
            
        }
    }];
    
}
#pragma mark -
#pragma mark --- GADBannerViewDelegate

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
{
    NSLog(@"-----adViewDidReceiveAd ");
    [self performSelector:@selector(removeAds) withObject:nil afterDelay:5.0f];
}
- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error
{
    [self removeAds];
}

#pragma mark -
#pragma mark --- categoryDelegate
- (void)categoryAction:(UIButton *)sender
{
    [self.radarView startAnimation];
    
    CATransition *animation=[CATransition animation];
    animation.type=@"rippleEffect";
    animation.duration=2.0;
    [self.view.superview.layer addAnimation:animation forKey:@"donghua"];
    
    switch (sender.tag) {
        case CategoryGame:
        {
//            FGTomViewController *tomVC = [[FGTomViewController alloc]init];
//            [self.navigationController pushViewController:tomVC animated:YES];
            
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
            [self runOnMainThread:^{
                FLStoryViewController *storyVC = [[FLStoryViewController alloc]init];
//                CATransition *animation=[CATransition animation];
//                animation.type=@"rippleEffect";
//                animation.duration=2.0;
//                [self.view.superview.layer addAnimation:animation forKey:@"donghua"];
                storyVC.titleStr = @"故事";
                [self.navigationController pushViewController:storyVC animated:YES];
            }];
        }
            break;
        case CategoryMath:
        {
            [self runOnMainThread:^{
                FGMathRootViewController *mathRootVC = [[FGMathRootViewController alloc]init];
                mathRootVC.title = @"数学乐园";
                [self.navigationController pushViewController:mathRootVC animated:YES];
            }];
        }
            break;
        default:
            break;
    }
}

//iOS在执行动画效果，Controller切换，弹框这些和UI界面相关的程序的时候，必须并且只能在主线程上运行，否则会出现延时或者各种诡异的现象。
//因此，在参考了各种方法后，整理了一个静态的block方法，如果不在主线程的话，直接切换到主线程执行动画
#pragma mark 始终在主线程运行
- (void)runOnMainThread:(dispatch_block_t)block
{
    if ([NSThread isMainThread]) {
        block();
    }else{
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
