//
//  FGMathDiffcultyViewController.m
//  FGProject
//
//  Created by 鑫龙魂 on 2018/8/26.
//  Copyright © 2018年 bert. All rights reserved.
//

#import "FGMathDiffcultyViewController.h"
#import "FGRewardsView.h"
#import "FGMediumLevelOperatorView.h"
#import "MCFireworksButton.h"
#import "FGMathRootViewController.h"
#import "FGClickRandomAnswerCountModel.h"
#import "FGMathAnswerOptionsModel.h"
#import "FGDiffcultyCandidateAnswerView.h"
@interface FGMathDiffcultyViewController ()<FGDiffcultyCandidateAnswerViewDelegate>
{
    FGClickRandomAnswerCountModel *clickRandomCounModel;
}
@property (nonatomic,strong) FGMediumLevelOperatorView *mediumLOV;
@property (nonatomic,strong) FGDiffcultyCandidateAnswerView *candidateAV;
@property (nonatomic,strong) FGMathOperationModel *currentOperaModel;
@end

@implementation FGMathDiffcultyViewController


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.mediumLOV.timer setFireDate:[NSDate distantFuture]];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.mediumLOV.timer setFireDate:[NSDate distantPast]];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initSubviews{
    [super initSubviews];
    self.titleStr = @"困难";
    [self hiddenCircleView];
    //运算式
    self.mediumLOV  = [[FGMediumLevelOperatorView alloc]init];
    [self.view addSubview:self.mediumLOV];
    
    //候选答案
    self.candidateAV = [[FGDiffcultyCandidateAnswerView alloc]init];
    self.candidateAV.delegate = self;
    [self.view addSubview:self.candidateAV];
    [self updateView];
    
   __unused UIButton *paustBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(50);
            make.right.mas_equalTo(-50);
            make.size.mas_equalTo(CGSizeMake(90, 40));
        }];
       [btn addTarget:self action:@selector(paustAction:) forControlEvents:UIControlEventTouchUpInside];
       [btn setTitle:@"暂停" forState:UIControlStateNormal];
       btn.titleLabel.font = [UIFont systemFontOfSize:20.0];
       [btn setBackgroundColor:RGB(41, 124, 247)];
       [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
       btn.layer.cornerRadius = 5.0;
       btn.layer.masksToBounds = YES;
       btn;
   });
    
}

#pragma mark -
#pragma mark --- update view
- (void)updateView{
    self.currentOperaModel = [self.mathManager generateCompreMathOperationModelWithOperationType:MathOperationActionTypeCompreOfChallenge];
    [self.mediumLOV setMediumOperationModel:self.currentOperaModel];
    FGMathAnswerOptionsModel *answerOptionModel = [self.mathManager generateRandomAnswerNum:self.currentOperaModel.answerNum];
    [self.candidateAV setupAnswerModel:answerOptionModel];
}

- (void)paustAction:(UIButton*)sender{
    [self.candidateAV pauseWaterRipper];
    [JCAlertView showOneButtonWithTitle:@"挑战暂停" Message:@"目前得分100" ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"继续挑战" Click:^{
        sender.selected = !sender.selected;
        [self.candidateAV continueWaterRipper];
    }];
}

#pragma mark -
#pragma mark --- MediumCandidateAnswerViewDelegate
- (void)didClickCandidateActionType:(MathOperationChooseResultType)actionType{
    
    [self.mathManager saveMathOperationDataStatisticsWithUserOperationState:actionType];
    [self updatCircleviewData];//更新数据

    if (actionType == MathOperationChooseResultTypeCorrect) {
        [[SoundsProcess shareInstance] playSoundOfWonderful];
        [self updateView];
    }else{

        [self showErrorView];
    }
}

- (void)challengeFailure{
    [self showErrorView];
}

- (void)showErrorView{
    [[SoundsProcess shareInstance] playSoundOfWrong];
    [JCAlertView showOneButtonWithTitle:@"挑战失败" Message:@"本次得分100" ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"确定" Click:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


/**
 *  烟花效果
 */
- (void)fireworksProcess{
    [FGRewardViewHUD show];
    //播放烟花声音
    [[SoundsProcess shareInstance] playSoundOfFireworks];
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_main_queue(), ^{
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < 10; i ++)
        {
            int x = arc4random()%((int)kScreenWidth - 10 + 1) + 1;
            int y = arc4random()%((int)kScreenHeight - 10 + 1) + 1;
            int w = arc4random()%((int)kScreenHeight/6 - 50 + 1) + 1;
            int h = w;
            
            MCFireworksButton *likeButton = [MCFireworksButton buttonWithType:UIButtonTypeCustom];
            likeButton.backgroundColor = [UIColor clearColor];
            int num = (arc4random()%(5-1+1)+1);
            likeButton.particleImage = [UIImage imageNamed:[NSString stringWithFormat:@"fireworks-0%d",num]];
            likeButton.particleScale = 0.5;
            likeButton.particleScaleRange = 0.02;
            likeButton.frame = CGRectMake(x, y, w, h);
            [arr addObject:likeButton];
        }
        UIView *shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        shadowView.tag = 10012;
        shadowView.backgroundColor = [UIColor blackColor];
        [self.view insertSubview:shadowView aboveSubview:self.view.superview];
        
        for (int i = 0; i < arr.count; i ++)
        {
            // 并行执行的线程一
            MCFireworksButton *likeButton = arr[i];
            [likeButton popOutsideWithDuration:5.5];
            [likeButton animate];
            [shadowView addSubview:likeButton];
        }
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 汇总结果
        [UIView animateWithDuration:3 delay:1.2 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            [self.view viewWithTag:10012].alpha = 0;
        } completion:^(BOOL finished) {
            [[self.view viewWithTag:10012] removeFromSuperview];
            
        }];
    });
}


- (void)setupLayoutSubviews{
    [super setupLayoutSubviews];
    [self.mediumLOV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenHeight/4));
    }];
    
    [self.candidateAV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mediumLOV.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenHeight/4));
    }];
}

@end
